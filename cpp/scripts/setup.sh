#!/bin/bash

# ========== SecurityCore Setup Script ==========
# Setup build environment cho SecurityCore

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../.."
CPP_DIR="$SCRIPT_DIR/.."
OUT_DIR="$CPP_DIR/out"

# Debug log
echo "[DEBUG] SCRIPT_DIR: $SCRIPT_DIR"
echo "[DEBUG] REPO_ROOT: $REPO_ROOT"
echo "[DEBUG] CPP_DIR: $CPP_DIR"
echo "[DEBUG] OUT_DIR: $OUT_DIR"
echo "[DEBUG] Current working dir: $(pwd)"

echo "[🔧] SecurityCore Setup Script"
echo "================================"

# Check if platform argument is provided
if [ $# -eq 0 ]; then
    echo "[❌] Usage: $0 <platform>"
    echo "Platforms:"
    echo "  android    - Setup Android environment"
    echo "  ios        - Setup iOS environment"
    echo "  all        - Setup all platforms"
    echo "  check      - Check current environment"
    echo ""
    echo "Examples:"
    echo "  $0 android"
    echo "  $0 ios"
    echo "  $0 all"
    echo "  $0 check"
    exit 1
fi

PLATFORM=$1

# Function to check prerequisites
check_prerequisites() {
    echo "[🔍] Checking prerequisites..."

    # Check Conan
    if ! command -v conan &>/dev/null; then
        echo "[❌] Conan is not installed. Please install it first:"
        echo "pip install conan"
        return 1
    else
        echo "[✅] Conan: $(conan --version)"
    fi

    # Check CMake
    if ! command -v cmake &>/dev/null; then
        echo "[❌] CMake is not installed. Please install it first:"
        echo "macOS: brew install cmake"
        echo "Ubuntu: sudo apt install cmake"
        return 1
    else
        echo "[✅] CMake: $(cmake --version | head -n1)"
    fi

    return 0
}

# Function to setup Android
setup_android() {
    echo "[📱] Setting up Android environment..."

    # Check Android NDK
    NDK_PATH=$HOME/Library/Android/sdk/ndk/28.0.12674087
    if [ ! -d "$NDK_PATH" ]; then
        echo "[❌] Android NDK not found at $NDK_PATH"
        echo "Please install Android NDK or update the path in scripts/build_android.sh"
        echo "You can download NDK from Android Studio or command line tools"
        return 1
    fi

    echo "[✅] Android NDK found at: $NDK_PATH"

    # Create build directories
    echo "[DEBUG] mkdir -p $OUT_DIR/armeabi-v7a"
    mkdir -p "$OUT_DIR/armeabi-v7a"
    echo "[DEBUG] mkdir -p $OUT_DIR/arm64-v8a"
    mkdir -p "$OUT_DIR/arm64-v8a"
    echo "[DEBUG] mkdir -p $OUT_DIR/x86"
    mkdir -p "$OUT_DIR/x86"
    echo "[DEBUG] mkdir -p $OUT_DIR/x86_64"
    mkdir -p "$OUT_DIR/x86_64"

    echo "[✅] Android setup completed!"
}

# Function to setup iOS
setup_ios() {
    echo "[🍎] Setting up iOS environment..."

    # Check Xcode (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command -v xcodebuild &>/dev/null; then
            echo "[❌] Xcode is not installed. Please install Xcode from App Store"
            return 1
        else
            echo "[✅] Xcode: $(xcodebuild -version | head -n1)"
        fi
    else
        echo "[⚠️] iOS development requires macOS with Xcode"
        return 1
    fi

    # Create build directories
    echo "[DEBUG] mkdir -p $OUT_DIR/ios"
    mkdir -p "$OUT_DIR/ios"
    echo "[DEBUG] mkdir -p $OUT_DIR/test"
    mkdir -p "$OUT_DIR/test"

    echo "[✅] iOS setup completed!"
}

# Function to setup Conan profiles
setup_conan_profiles() {
    echo "[📦] Setting up Conan profiles..."

    # Create default profile (ignore if already exists)
    if ! conan profile detect 2>/dev/null; then
        echo "[ℹ️] Default profile already exists, skipping..."
    else
        echo "[✅] Default profile created"
    fi

    # Create project-local profiles directory
    mkdir -p ../conan_profiles

    echo "[✅] Conan profiles setup completed!"
}

# Function to check environment
check_environment() {
    echo "[🔍] Checking current environment..."

    # Check tools
    check_prerequisites

    # Check Android NDK
    NDK_PATH=$HOME/Library/Android/sdk/ndk/28.0.12674087
    if [ -d "$NDK_PATH" ]; then
        echo "[✅] Android NDK: $NDK_PATH"
    else
        echo "[❌] Android NDK: Not found"
    fi

    # Check Xcode (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v xcodebuild &>/dev/null; then
            echo "[✅] Xcode: Available"
        else
            echo "[❌] Xcode: Not found"
        fi
    fi

    # Check build directories
    if [ -d "$OUT_DIR" ]; then
        echo "[✅] Build directories: Available ($OUT_DIR)"
    else
        echo "[❌] Build directories: Not found ($OUT_DIR)"
    fi

    # Check Conan profiles
    if [ -d "../conan_profiles" ]; then
        echo "[✅] Conan profiles: Available"
    else
        echo "[❌] Conan profiles: Not found"
    fi
}

# Main execution
case $PLATFORM in
"android")
    check_prerequisites || exit 1
    setup_android
    setup_conan_profiles
    ;;
"ios")
    check_prerequisites || exit 1
    setup_ios
    setup_conan_profiles
    ;;
"all")
    check_prerequisites || exit 1
    setup_android
    setup_ios
    setup_conan_profiles
    ;;
"check")
    check_environment
    ;;
*)
    echo "[❌] Unknown platform: $PLATFORM"
    echo "Available platforms: android, ios, all, check"
    exit 1
    ;;
esac

echo "[✅] Setup completed successfully!"

# Make scripts executable
echo "[🔧] Making scripts executable..."
chmod +x scripts/build.sh
chmod +x scripts/build_android.sh
chmod +x scripts/build_ios.sh
chmod +x scripts/test.sh
chmod +x scripts/setup.sh

echo "[💡] You can now run: ./scripts/build.sh <platform>"
