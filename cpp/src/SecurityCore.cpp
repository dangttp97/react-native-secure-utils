#include "SecurityCore.h"

#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#if !defined(__APPLE__) || defined(__ANDROID__)
#include <sys/ptrace.h>
#endif
#include <fcntl.h>
#include <cstring>
#include <dirent.h>
#include <thread>
#include <chrono>
#include <stdio.h>

#if defined(__APPLE__) && !defined(__ANDROID__)
#include <mach-o/dyld.h>
#include <mach-o/getsect.h>
#include <dlfcn.h>
#endif

#if defined(__ANDROID__)
#include <android/log.h>
#include <sys/system_properties.h>
#define LOG(...) __android_log_print(ANDROID_LOG_INFO, "SecurityCore", "%s", )
#else
#define LOG(...) printf(__VA_ARGS__)
#endif

// ========== XOR Decryption ==========
const char* xor_decode(const char* enc, char key) {
    static char buf[128];
    int i = 0;
    while (enc[i]) {
        buf[i] = enc[i] ^ key;
        i++;
    }
    buf[i] = '\0';
    return buf;
}

// ========== CRC32 ==========
unsigned int crc32(unsigned char* data, size_t len) {
    unsigned int crc = 0xFFFFFFFF;
    for (size_t i = 0; i < len; ++i) {
        crc ^= data[i];
        for (int j = 0; j < 8; ++j)
            crc = (crc >> 1) ^ (0xEDB88320 & -(crc & 1));
    }
    return ~crc;
}

// ========== Sensitive Function ==========
__attribute__((noinline)) __attribute__((visibility("hidden")))
void sensitive_function() {
#if defined(__i386__) || defined(__x86_64__)
    asm volatile(
        "nop\n"
        "nop\n"
        "ret\n"
    );
#elif defined(__arm__)
    asm volatile(
        "nop\n"
        "nop\n"
        // ARM32: bx lr
        "bx lr\n"
    );
#elif defined(__aarch64__)
    asm volatile(
        "nop\n"
        "nop\n"
        // ARM64: ret
        "ret\n"
    );
#else
    // fallback: chỉ nop
    asm volatile("nop\n");
#endif
}

// ========== Frida Thread Detection ==========
bool detect_frida_thread() {
#if !defined(__APPLE__)
    DIR* dir = opendir("/proc/self/task/");
    if (!dir) return false;

    struct dirent* entry;
    char path[64], name[64];
    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_type != DT_DIR) continue;
        snprintf(path, sizeof(path), "/proc/self/task/%s/comm", entry->d_name);
        FILE* f = fopen(path, "r");
        if (!f) continue;
        fgets(name, sizeof(name), f);
        fclose(f);
        if (strstr(name, "gum-js-loop")) {
            closedir(dir);
            return true;
        }
    }
    closedir(dir);
    return false;
#else
    // iOS không có /proc/, return false
    return false;
#endif
}

// ========== Debugger Detection ==========
bool detect_debugger() {
#if !defined(__APPLE__) || defined(__ANDROID__)
    return ptrace(PTRACE_TRACEME, 0, 0, 0) == -1;
#else
    // iOS không hỗ trợ ptrace, return false
    return false;
#endif
}

// ========== Memory Map Check ==========
bool detect_memory_maps() {
#if !defined(__APPLE__)
    FILE* fp = fopen("/proc/self/maps", "r");
    if (!fp) return false;

    char line[512];
    const char* pattern = xor_decode("\xD4\xF8\xE3\xC6\xCB", 0xAA);  // "frida"
    while (fgets(line, sizeof(line), fp)) {
        if (strstr(line, pattern) != nullptr) {
            fclose(fp);
            return true;
        }
    }
    fclose(fp);
    return false;
#else
    // iOS không có /proc/self/maps, return false
    return false;
#endif
}

// ========== Process Name Validation ==========
bool check_process_name() {
#if !defined(__APPLE__)
    char name[256];
    FILE* f = fopen("/proc/self/cmdline", "r");
    if (!f) return false;
    fgets(name, sizeof(name), f);
    fclose(f);
    return strstr(name, "com.app.trusted") != NULL;
#else
    // iOS không có /proc/self/cmdline, return true
    return true;
#endif
}

// ========== Code Integrity Check ==========
bool verify_integrity() {
    void* addr = (void*)&sensitive_function;
    unsigned char expected[] = {0x90, 0x90, 0xC3}; // nop, nop, ret
    return memcmp((unsigned char*)addr, expected, sizeof(expected)) == 0;
}

// ========== Self-healing ==========
void heal_function() {
    unsigned char expected[] = {0x90, 0x90, 0xC3};
    void* addr = (void*)&sensitive_function;

    size_t page_size = sysconf(_SC_PAGESIZE);
    uintptr_t page = (uintptr_t)addr & ~(page_size - 1);
    mprotect((void*)page, page_size, PROT_READ | PROT_WRITE | PROT_EXEC);

    while (true) {
        if (memcmp((unsigned char*)addr, expected, sizeof(expected)) != 0) {
            LOG("Function tampered! Healing...\n");
            memcpy((unsigned char*)addr, expected, sizeof(expected));
        }
        std::this_thread::sleep_for(std::chrono::seconds(2));
    }
}

// ========== Public Entry ==========
bool run_advanced_checks() {
    if (detect_debugger()) {
        LOG("[!] Debugger detected.\n");
        return false;
    }
    if (detect_frida_thread()) {
        LOG("[!] Frida thread detected.\n");
        return false;
    }
    if (detect_memory_maps()) {
        LOG("[!] Memory maps show suspicious patterns.\n");
        return false;
    }
    if (!check_process_name()) {
        LOG("[!] Process name mismatch.\n");
        return false;
    }
    if (!verify_integrity()) {
        LOG("[!] Sensitive function was modified.\n");
        return false;
    }
    LOG("[+] All checks passed.\n");
    return true;
}

void start_self_heal() {
    std::thread(heal_function).detach();
}

// ========== iOS Anti-Frida Detection ==========

// Check for Frida libraries in memory
bool detect_frida_libraries() {
#if defined(__APPLE__) && !defined(__ANDROID__)
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char* name = _dyld_get_image_name(i);
        if (name && (strstr(name, "frida") || strstr(name, "gum") || strstr(name, "gjs"))) {
            return true;
        }
    }
#endif
    return false;
}

// Check for suspicious environment variables
bool detect_frida_env() {
    const char* env_vars[] = {"FRIDA_DNS_SERVER", "FRIDA_EXTRA_ARGS", "FRIDA_LOADER"};
    for (const char* var : env_vars) {
        if (getenv(var)) {
            return true;
        }
    }
    return false;
}

// Check for suspicious files
bool detect_frida_files() {
    const char* suspicious_paths[] = {
        "/usr/lib/frida",
        "/usr/lib/frida-gadget.dylib",
        "/usr/lib/frida-agent.dylib",
        "/var/root/frida",
        "/data/local/tmp/fd-server"
    };
    
    for (const char* path : suspicious_paths) {
        struct stat st;
        int res = stat(path, &st);
        LOG("Check path: %s, stat result: %d, errno: %d", path, res, errno);
        if (res == 0) {
            return true;
        }
    }
    return false;
}

// Check for suspicious symbols in memory
bool detect_frida_symbols() {
#if defined(__APPLE__) && !defined(__ANDROID__)
    // Check for Frida symbols in loaded libraries
    void* handle = dlopen(NULL, RTLD_NOW);
    if (handle) {
        const char* symbols[] = {"frida_agent_main", "gum_init", "gjs_context_eval"};
        for (const char* symbol : symbols) {
            if (dlsym(handle, symbol)) {
                dlclose(handle);
                return true;
            }
        }
        dlclose(handle);
    }
#endif
    return false;
}

// Check for code injection patterns
bool detect_code_injection() {
#if defined(__APPLE__) && !defined(__ANDROID__)
    // Check for suspicious memory regions
    const struct mach_header_64* header = (const struct mach_header_64*)_dyld_get_image_header(0);
    if (header) {
        // Check for suspicious segments
        struct load_command* lc = (struct load_command*)((uint8_t*)header + sizeof(struct mach_header_64));
        for (uint32_t i = 0; i < header->ncmds; i++) {
            if (lc->cmd == LC_SEGMENT_64) {
                struct segment_command_64* seg = (struct segment_command_64*)lc;
                // Check for suspicious segment names
                if (strstr(seg->segname, "frida") || strstr(seg->segname, "gum")) {
                    return true;
                }
            }
            lc = (struct load_command*)((uint8_t*)lc + lc->cmdsize);
        }
    }
#endif
    return false;
}

// Main anti-Frida function for iOS
bool run_ios_anti_frida() {
    bool detected = false;
    
    if (detect_frida_libraries()) {
        LOG("[!] Frida libraries detected in memory\n");
        detected = true;
    }
    
    if (detect_frida_env()) {
        LOG("[!] Frida environment variables detected\n");
        detected = true;
    }
    
    if (detect_frida_files()) {
        LOG("[!] Frida files detected on filesystem\n");
        detected = true;
    }
    
    if (detect_frida_symbols()) {
        LOG("[!] Frida symbols detected in memory\n");
        detected = true;
    }
    
    if (detect_code_injection()) {
        LOG("[!] Code injection patterns detected\n");
        detected = true;
    }
    
    if (!detected) {
        LOG("[+] No Frida detected on iOS\n");
    }
    
    return !detected; // Return true if no Frida detected
}

// Additional iOS-specific security checks
bool run_ios_security_checks() {
    bool secure = true;
    
    // Check for jailbreak indicators
    const char* jailbreak_paths[] = {
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt"
    };
    
    for (const char* path : jailbreak_paths) {
        struct stat st;
        if (stat(path, &st) == 0) {
            LOG("[!] Jailbreak detected: %s\n", path);
            secure = false;
        }
    }
    
    return secure;
}

bool is_rooted() {
#if defined(__ANDROID__)
    // 1. Check for root binaries
    const char* paths[] = {
        "/system/xbin/su", "/system/bin/su", "/sbin/su", "/system/app/Superuser.apk",
        "/system/bin/.ext/.su", "/system/usr/we-need-root/su.backup", "/system/xbin/mu", nullptr
    };
    for (int i = 0; paths[i]; ++i) {
        if (access(paths[i], F_OK) == 0) return true;
    }
    // 2. Check for dangerous props
    char value[PROP_VALUE_MAX];
    if (__system_property_get("ro.debuggable", value) && strcmp(value, "1") == 0) return true;
    if (__system_property_get("ro.secure", value) && strcmp(value, "0") == 0) return true;
    // 3. Check for RW system
    FILE* f = fopen("/proc/mounts", "r");
    if (f) {
        char line[512];
        while (fgets(line, sizeof(line), f)) {
            if (strstr(line, "/system") && strstr(line, "rw")) {
                fclose(f);
                return true;
            }
        }
        fclose(f);
    }
    // 4. Check for root packages
    const char* pkgs[] = { "com.noshufou.android.su", "eu.chainfire.supersu", "com.koushikdutta.superuser", "com.zachspong.temprootremovejb", "com.ramdroid.appquarantine", nullptr };
    // (Optional: check via JNI/Java)
    // 5. Check for Frida/Xposed
    if (detect_frida_thread() || detect_memory_maps()) return true;
    // 6. Check for dangerous files
    if (access("/data/local/tmp/frida-server", F_OK) == 0) return true;
    // 7. Anti-debug
    if (detect_debugger()) return true;
    return false;
#elif defined(__APPLE__)
    // 1. Check for jailbreak files
    const char* paths[] = {
        "/Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib", "/bin/bash", "/usr/sbin/sshd", "/etc/apt", "/private/var/lib/apt/", nullptr
    };
    for (int i = 0; paths[i]; ++i) {
        if (access(paths[i], F_OK) == 0) return true;
    }
    // 2. Check for sandbox escape
    FILE* f = fopen("/private/jailbreak.txt", "w");
    if (f) {
        fclose(f);
        remove("/private/jailbreak.txt");
        return true;
    }
    // 3. Check for suspicious dylibs
    // (Optional: check loaded dylibs)
    // 4. Check for Frida
    if (detect_frida_symbols() || detect_frida_env() || detect_frida_files()) return true;
    // 5. Anti-debug
    if (detect_debugger()) return true;
    return false;
#else
    return false;
#endif
}
