#!/bin/bash

# ========== iOS Build Script ==========
# Build SecurityCore cho iOS (ARM64 + x86_64 simulator)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../.."
CPP_DIR="$SCRIPT_DIR/.."
OUT_DIR="$CPP_DIR/out"
IOS_DIR="$REPO_ROOT/ios"

# Debug log
echo "[DEBUG] SCRIPT_DIR: $SCRIPT_DIR"
echo "[DEBUG] REPO_ROOT: $REPO_ROOT"
echo "[DEBUG] CPP_DIR: $CPP_DIR"
echo "[DEBUG] OUT_DIR: $OUT_DIR"
echo "[DEBUG] IOS_DIR: $IOS_DIR"
echo "[DEBUG] Current working dir: $(pwd)"

cd "$CPP_DIR"
echo "[DEBUG] After cd to CPP dir: $(pwd)"

# Install Conan dependencies for iOS
echo "[📦] Installing Conan dependencies for iOS..."
echo "[🔍] DEBUG: CPP_OUT_DIR/ios: $OUT_DIR/ios"
echo "[🔍] DEBUG: Conan profile: ./conan_profiles/ios_profile"
echo "[🔍] DEBUG: Current dir for conan: $(pwd)"
conan install . --output-folder=$OUT_DIR/ios --build=missing --profile:host=./conan_profiles/ios_profile

# Build with CMake using Conan toolchain
echo "[🔨] Building with CMake for iOS..."
TOOLCHAIN_FILE="$OUT_DIR/ios/build/Release/generators/conan_toolchain.cmake"
echo "[🔧] Using toolchain: $TOOLCHAIN_FILE"

cmake -B $OUT_DIR/ios -S . \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release

cmake --build $OUT_DIR/ios --target SecurityCore -- -j4

# Link to iOS directory (symbolic link)
mkdir -p $IOS_DIR

SOURCE_LIB="$OUT_DIR/ios/libSecurityCore.a"
TARGET_LIB="$IOS_DIR/libSecurityCore.a"

# Remove existing file/link
if [ -L "$TARGET_LIB" ] || [ -f "$TARGET_LIB" ]; then
    rm "$TARGET_LIB"
fi

# Create symbolic link
ln -sf "$SOURCE_LIB" "$TARGET_LIB"
echo "[✔] Linked libSecurityCore.a to $IOS_DIR"

echo "[✅] iOS build completed successfully!"
echo "[📁] Output (symbolic link): ios/libSecurityCore.a"
