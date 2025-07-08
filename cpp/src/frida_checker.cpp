#include "frida_checker.h"

// Android specific functions
#if defined(__ANDROID__) && !defined(__APPLE__)
bool android_detect_frida_thread() {
    return false;
}

bool android_detect_frida_env() {
    const char* env_vars[] = {"FRIDA_DNS_SERVER", "FRIDA_EXTRA_ARGS", "FRIDA_LOADER"};
    for (const char* var : env_vars) {
        if (getenv(var)) {
            return true;
        }
    }
    return false;
}

bool android_detect_frida_files() {
    const char* suspicious_paths[] = {
        "/usr/lib/frida",
        "/usr/lib/frida-gadget.dylib",
        "/usr/lib/frida-agent.dylib",
        "/var/root/frida",
        "/data/local/tmp/frida-server"
        "/data/local/tmp/fd-server"
    };
    
    for (const char* path : suspicious_paths) {
        struct stat st;
        int res = stat(path, &st);
        __android_log_print(ANDROID_LOG_INFO, "SecurityCore", "Check path: %s, stat result: %d, errno: %d", path, res, errno);
        if (res == 0) {
            return true;
        }
    }
    return false;
}

bool detect_frida_symbols() {
    return false;
}

bool detect_code_injection() {
    return false;
}


bool android_detect_frida_thread() {
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
}
#endif

// Apple specific functions
#if defined(__APPLE__) && !defined(__ANDROID__)
bool apple_detect_frida_files() {
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char* name = _dyld_get_image_name(i);
        if (name && (strstr(name, "frida") || strstr(name, "gum") || strstr(name, "gjs"))) {
            return true;
        }
    }
    return false;
}

bool apple_detect_frida_symbols() {
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
    return false;
}

bool apple_detect_code_injection() {
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
    return false;
}
#endif

bool check_frida_free_env() {
    #if defined(__ANDROID__) && !defined(__APPLE__)
    return android_detect_frida_files() || android_detect_frida_env();
    #elif defined(__APPLE__) && !defined(__ANDROID__)
    return apple_detect_frida_files() || apple_detect_frida_env();
    #else
    return false;
    #endif
}