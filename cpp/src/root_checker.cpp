bool android_check_root() {
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
}

bool apple_check_root() {
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
}

bool check_root() {
    #if defined(__ANDROID__) && !defined(__APPLE__)
    return android_check_root();
    #elif defined(__APPLE__) && !defined(__ANDROID__)
    return apple_check_root();
    #else
    return false;
    #endif
}