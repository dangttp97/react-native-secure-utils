#!/bin/bash

# ========== SecurityCore Build Script ==========
# Build SecurityCore cho tất cả platforms

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

cd "$SCRIPT_DIR"
echo "[DEBUG] After cd to script dir: $(pwd)"

echo "[🔒] SecurityCore Build Script"
echo "================================"

# Configuration
ANDROID_JNILIBS_DIR="$REPO_ROOT/android/src/main/jniLibs"
IOS_DIR="$REPO_ROOT/ios"
CPP_OUT_DIR="$OUT_DIR"

echo "[DEBUG] ANDROID_JNILIBS_DIR: $ANDROID_JNILIBS_DIR"
echo "[DEBUG] IOS_DIR: $IOS_DIR"
echo "[DEBUG] CPP_OUT_DIR: $CPP_OUT_DIR"

# Warn if out exists at repo root
if [ -d "$REPO_ROOT/out" ]; then
    echo "[⚠️] WARNING: 'out' directory exists at repo root ($REPO_ROOT/out). This is incorrect."
    echo "[💡] You should delete it: rm -rf $REPO_ROOT/out"
fi

# Function to create symbolic links
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -f "$source" ]; then
        # Remove existing file/link
        if [ -L "$target" ] || [ -f "$target" ]; then
            rm "$target"
        fi

        # Create symbolic link
        ln -sf "$source" "$target"
        echo "[✅] Linked: $target -> $source"
    else
        echo "[❌] Source not found: $source"
        return 1
    fi
}

# Function to remove symbolic links
remove_symlink() {
    local target="$1"

    if [ -L "$target" ]; then
        rm "$target"
        echo "[✅] Removed link: $target"
    elif [ -f "$target" ]; then
        echo "[⚠️] File exists (not a link): $target"
        echo "[💡] Use 'rm $target' to remove manually"
    else
        echo "[ℹ️] No link/file found: $target"
    fi
}

# Function to check link
check_link() {
    local target="$1"
    local description="$2"

    echo "[📋] Checking: $description"
    echo "  Target: $target"

    if [ -L "$target" ]; then
        local link_target=$(readlink "$target")
        echo "  ✅ Symbolic link exists"
        echo "  🔗 Points to: $link_target"

        if [ -f "$link_target" ]; then
            echo "  ✅ Target file exists"
            local size=$(stat -f%z "$link_target" 2>/dev/null || stat -c%s "$link_target" 2>/dev/null)
            echo "  📏 File size: $size bytes"
        else
            echo "  ❌ Target file missing: $link_target"
        fi
    elif [ -f "$target" ]; then
        echo "  ⚠️  Regular file (not a link): $target"
        local size=$(stat -f%z "$target" 2>/dev/null || stat -c%s "$target" 2>/dev/null)
        echo "  📏 File size: $size bytes"
    else
        echo "  ❌ No link or file found"
    fi
    echo ""
}

# Function to link all libraries
link_libraries() {
    echo "[🔗] Linking libraries from cpp/out..."

    # Create Android jniLibs directory structure
    echo "[📱] Setting up Android links..."
    mkdir -p "$ANDROID_JNILIBS_DIR"

    # Link Android libraries
    ANDROID_ABIS=("armeabi-v7a" "arm64-v8a" "x86" "x86_64")

    for ABI in "${ANDROID_ABIS[@]}"; do
        ABI_DIR="$ANDROID_JNILIBS_DIR/$ABI"
        mkdir -p "$ABI_DIR"

        SOURCE_LIB="$CPP_OUT_DIR/$ABI/libSecurityCore.so"
        TARGET_LIB="$ABI_DIR/libSecurityCore.so"

        create_symlink "$SOURCE_LIB" "$TARGET_LIB"
    done

    # Create iOS directory
    echo "[🍎] Setting up iOS links..."
    mkdir -p "$IOS_DIR"

    # Link iOS library
    SOURCE_IOS_LIB="$CPP_OUT_DIR/ios/libSecurityCore.a"
    TARGET_IOS_LIB="$IOS_DIR/libSecurityCore.a"

    create_symlink "$SOURCE_IOS_LIB" "$TARGET_IOS_LIB"

    echo "[✅] All libraries linked successfully!"
    echo "[💡] Libraries are now linked from cpp/out/"
    echo "[📁] Android: $ANDROID_JNILIBS_DIR"
    echo "[📁] iOS: $IOS_DIR"
}

# Function to unlink all libraries
unlink_libraries() {
    echo "[🔗] Unlinking libraries..."

    # Remove Android links
    echo "[📱] Removing Android links..."
    ANDROID_ABIS=("armeabi-v7a" "arm64-v8a" "x86" "x86_64")

    for ABI in "${ANDROID_ABIS[@]}"; do
        TARGET_LIB="$ANDROID_JNILIBS_DIR/$ABI/libSecurityCore.so"
        remove_symlink "$TARGET_LIB"
    done

    # Remove iOS link
    echo "[🍎] Removing iOS link..."
    TARGET_IOS_LIB="$IOS_DIR/libSecurityCore.a"
    remove_symlink "$TARGET_IOS_LIB"

    echo "[✅] All library links removed!"
    echo "[💡] Original files in cpp/out/ are preserved"
}

# Function to check all links
check_links() {
    echo "[🔍] Checking symbolic links..."

    # Check Android links
    echo "[📱] Android Links:"
    ANDROID_ABIS=("armeabi-v7a" "arm64-v8a" "x86" "x86_64")

    for ABI in "${ANDROID_ABIS[@]}"; do
        TARGET_LIB="$ANDROID_JNILIBS_DIR/$ABI/libSecurityCore.so"
        check_link "$TARGET_LIB" "Android $ABI"
    done

    # Check iOS link
    echo "[🍎] iOS Link:"
    TARGET_IOS_LIB="$IOS_DIR/libSecurityCore.a"
    check_link "$TARGET_IOS_LIB" "iOS"

    # Summary
    echo "[📊] Summary:"
    echo "  Android ABIs: ${#ANDROID_ABIS[@]}"
    echo "  iOS: 1"
    echo ""
    echo "[💡] Use '$0 link' to create missing links"
    echo "[💡] Use '$0 unlink' to remove all links"
}

# Check if platform argument is provided
if [ $# -eq 0 ]; then
    echo "[❌] Usage: $0 <platform>"
    echo "Platforms:"
    echo "  android    - Build for Android (all ABIs)"
    echo "  ios        - Build for iOS"
    echo "  all        - Build for all platforms"
    echo "  test       - Test build"
    echo "  link       - Link libraries (symbolic links)"
    echo "  unlink     - Unlink libraries"
    echo "  check      - Check link status"
    echo ""
    echo "Examples:"
    echo "  $0 android"
    echo "  $0 ios"
    echo "  $0 all"
    echo "  $0 test"
    echo "  $0 link"
    echo "  $0 unlink"
    echo "  $0 check"
    exit 1
fi

PLATFORM=$1

case $PLATFORM in
"android")
    echo "[📱] Building for Android (all ABIs)..."
    "$SCRIPT_DIR/build_android.sh"
    ;;
"ios")
    echo "[🍎] Building for iOS..."
    "$SCRIPT_DIR/build_ios.sh"
    ;;
"all")
    echo "[🚀] Building for all platforms..."
    echo "[📱] Building Android..."
    "$SCRIPT_DIR/build_android.sh"
    echo "[🍎] Building iOS..."
    "$SCRIPT_DIR/build_ios.sh"
    ;;
"test")
    echo "[🧪] Running tests..."
    "$SCRIPT_DIR/test.sh"
    ;;
"link")
    link_libraries
    ;;
"unlink")
    unlink_libraries
    ;;
"check")
    check_links
    ;;
*)
    echo "[❌] Unknown platform: $PLATFORM"
    echo "Available platforms: android, ios, all, test, link, unlink, check"
    exit 1
    ;;
esac

echo "[✅] Operation completed successfully!"
