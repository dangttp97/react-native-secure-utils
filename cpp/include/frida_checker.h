#ifndef FRIDA_CHECKER_H
#define FRIDA_CHECKER_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

bool detect_frida_env();
bool detect_frida_files();
bool detect_frida_symbols();
bool detect_code_injection();
bool detect_frida_thread();

#ifdef __cplusplus
}
#endif

#endif // FRIDA_CHECKER_H