#!/bin/bash

# ========== Test Script ==========
# Test SecurityCore build và functions

set -e

echo "[🧪] Testing SecurityCore..."

# Configuration
SRC_DIR=.. # Relative to scripts/

# Test iOS build
echo "[🍎] Testing iOS build..."
cd $SRC_DIR
conan install . --output-folder=./out/test --build=missing --profile:host=./conan_profiles/ios_profile --profile:build=default
cd scripts

TOOLCHAIN_FILE="$(pwd)/../out/test/build/Release/generators/conan_toolchain.cmake"

cmake -B ../out/test -S .. \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release

cmake --build ../out/test --target SecurityCore -- -j4

echo "[✅] SecurityCore built successfully!"
echo "[📁] Library: out/test/libSecurityCore.a"

# List available functions
echo "[🔍] Available SecurityCore functions:"
echo "  📱 Android functions:"
echo "    - run_advanced_checks()"
echo "    - detect_debugger()"
echo "    - detect_frida_thread()"
echo "    - detect_memory_maps()"
echo "    - check_process_name()"
echo "    - verify_integrity()"
echo ""
echo "  🍎 iOS functions:"
echo "    - run_ios_anti_frida()"
echo "    - run_ios_security_checks()"
echo "    - detect_frida_libraries()"
echo "    - detect_frida_env()"
echo "    - detect_frida_files()"
echo "    - detect_frida_symbols()"
echo "    - detect_code_injection()"
echo ""
echo "  🔧 Utility functions:"
echo "    - xor_decode()"
echo "    - crc32()"
echo "    - start_self_heal()"

echo "[✅] Test completed successfully!"
