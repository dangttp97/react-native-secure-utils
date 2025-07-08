#!/bin/bash

# ========== Android Multi-Architecture Build Script ==========
# Build SecurityCore cho tất cả Android ABIs: ARMv7, ARMv8, x86, x86_64

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../.."
CPP_DIR="$SCRIPT_DIR/.."
OUT_DIR="$CPP_DIR/out"
ANDROID_JNILIBS_DIR="$REPO_ROOT/android/src/main/jniLibs"

# Debug log
echo "[DEBUG] SCRIPT_DIR: $SCRIPT_DIR"
echo "[DEBUG] REPO_ROOT: $REPO_ROOT"
echo "[DEBUG] CPP_DIR: $CPP_DIR"
echo "[DEBUG] OUT_DIR: $OUT_DIR"
echo "[DEBUG] ANDROID_JNILIBS_DIR: $ANDROID_JNILIBS_DIR"
echo "[DEBUG] Current working dir: $(pwd)"

cd "$CPP_DIR"
echo "[DEBUG] After cd to CPP dir: $(pwd)"

# Build for multiple ABIs with corresponding profiles
ABIS=("armeabi-v7a" "arm64-v8a" "x86" "x86_64")
PROFILES=("android_armv7_profile" "android_armv8_profile" "android_x86_profile" "android_x86_64_profile")

for i in "${!ABIS[@]}"; do
    ABI=${ABIS[$i]}
    PROFILE=${PROFILES[$i]}
    echo "[📱] Building for ABI: $ABI with profile: $PROFILE"
    BUILD_DIR=$OUT_DIR/$ABI

    # Install Conan dependencies
    echo "[📦] Installing Conan dependencies for Android ($ABI)..."
    echo "[🔍] DEBUG: BUILD_DIR: $BUILD_DIR"
    echo "[🔍] DEBUG: Conan profile: ./conan_profiles/$PROFILE"
    echo "[🔍] DEBUG: Current dir for conan: $(pwd)"
    conan install . --output-folder=$BUILD_DIR --build=missing --profile:host=./conan_profiles/$PROFILE --profile:build=default

    # Build with CMake using Conan toolchain
    echo "[🔨] Building with CMake for Android ($ABI)..."
    TOOLCHAIN_FILE="$BUILD_DIR/build/Release/generators/conan_toolchain.cmake"
    echo "[🔧] Using toolchain: $TOOLCHAIN_FILE"

    cmake -B $BUILD_DIR -S . \
        -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
        -DCMAKE_BUILD_TYPE=Release

    cmake --build $BUILD_DIR --target SecurityCore -- -j4

    # Link to jniLibs (symbolic link)
    JNILIBS_DIR=$ANDROID_JNILIBS_DIR/$ABI
    mkdir -p $JNILIBS_DIR

    SOURCE_LIB="$BUILD_DIR/libSecurityCore.so"
    TARGET_LIB="$JNILIBS_DIR/libSecurityCore.so"

    # Remove existing file/link
    if [ -L "$TARGET_LIB" ] || [ -f "$TARGET_LIB" ]; then
        rm "$TARGET_LIB"
    fi

    # Create symbolic link
    ln -sf "$SOURCE_LIB" "$TARGET_LIB"
    echo "[✔] Linked libSecurityCore.so to $JNILIBS_DIR"
done

echo "[✅] All Android ABIs built and linked successfully!"
echo "[📁] Output files (symbolic links):"
echo "  - android/src/main/jniLibs/armeabi-v7a/libSecurityCore.so"
echo "  - android/src/main/jniLibs/arm64-v8a/libSecurityCore.so"
echo "  - android/src/main/jniLibs/x86/libSecurityCore.so"
echo "  - android/src/main/jniLibs/x86_64/libSecurityCore.so"
