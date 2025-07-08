#ifndef SECURITY_CORE_H
#define SECURITY_CORE_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

// Main security check function
bool run_advanced_checks();

// Individual detection functions
bool detect_debugger();
bool detect_frida_thread();
bool detect_memory_maps();
bool check_process_name();
bool verify_integrity();

// iOS-specific functions
bool run_ios_anti_frida();
bool run_ios_security_checks();

// Utility functions
const char* xor_decode(const char* enc, char key);
unsigned int crc32(unsigned char* data, size_t len);

// Unified advanced root/jailbreak detection
bool is_rooted();

#ifdef __cplusplus
}
#endif

#endif // SECURITY_CORE_H
