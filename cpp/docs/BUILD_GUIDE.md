# 🔨 Build Guide - SecurityCore

## Prerequisites

### Required Tools

- **Conan**: Package manager cho C++
  ```bash
  pip install conan
  ```
- **CMake**: Build system

  ```bash
  # macOS
  brew install cmake

  # Ubuntu
  sudo apt install cmake
  ```

- **Android NDK**: Cho Android builds
  ```bash
  # Download từ Android Studio hoặc command line
  # Default path: $HOME/Library/Android/sdk/ndk/28.0.12674087
  ```
- **Xcode**: Cho iOS builds (macOS only)

### Verify Installation

```bash
# Check Conan
conan --version

# Check CMake
cmake --version

# Check Android NDK
ls $HOME/Library/Android/sdk/ndk/
```

## 🚀 Quick Start

### Setup Environment

```bash
# Setup cho tất cả platforms
./cpp/scripts/setup.sh all

# Hoặc setup riêng lẻ
./cpp/scripts/setup.sh android
./cpp/scripts/setup.sh ios
```

### Build Libraries

```bash
# Build cho tất cả platforms
./cpp/scripts/build.sh all

# Hoặc build riêng lẻ
./cpp/scripts/build.sh android
./cpp/scripts/build.sh ios
```

## 📱 Building for Android

### Manual Build (Single ABI)

```bash
cd cpp

# 1. Install dependencies
conan install . --output-folder=./out/arm64-v8a --build=missing \
  --profile:host=./conan_profiles/android_armv8_profile \
  --profile:build=default

# 2. Build with CMake
TOOLCHAIN_FILE="$(pwd)/out/arm64-v8a/build/Release/generators/conan_toolchain.cmake"
cmake -B out/arm64-v8a -S . \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
  -DCMAKE_BUILD_TYPE=Release

cmake --build out/arm64-v8a --target SecurityCore -- -j4

# 3. Copy to jniLibs
mkdir -p ../android/app/src/main/jniLibs/arm64-v8a
cp out/arm64-v8a/libSecurityCore.so ../android/app/src/main/jniLibs/arm64-v8a/
```

### Available Android ABIs

| ABI           | Architecture       | Profile                  | Output                                   |
| ------------- | ------------------ | ------------------------ | ---------------------------------------- |
| `armeabi-v7a` | ARM 32-bit (ARMv7) | `android_armv7_profile`  | `jniLibs/armeabi-v7a/libSecurityCore.so` |
| `arm64-v8a`   | ARM 64-bit (ARMv8) | `android_armv8_profile`  | `jniLibs/arm64-v8a/libSecurityCore.so`   |
| `x86`         | Intel 32-bit       | `android_x86_profile`    | `jniLibs/x86/libSecurityCore.so`         |
| `x86_64`      | Intel 64-bit       | `android_x86_64_profile` | `jniLibs/x86_64/libSecurityCore.so`      |

## 🍎 Building for iOS

### Quick Build

```bash
# Build cho iOS
./cpp/scripts/build.sh ios
```

### Manual Build

```bash
cd cpp

# 1. Install dependencies
conan install . --output-folder=./out/ios --build=missing \
  --profile:host=./conan_profiles/ios_profile \
  --profile:build=default

# 2. Build with CMake
TOOLCHAIN_FILE="$(pwd)/out/ios/build/Release/generators/conan_toolchain.cmake"
cmake -B out/ios -S . \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
  -DCMAKE_BUILD_TYPE=Release

cmake --build out/ios --target SecurityCore -- -j4

# 3. Copy to iOS directory
cp out/ios/libSecurityCore.a ../ios/
```

### iOS Architectures

- **arm64**: Apple Silicon (iPhone, iPad)
- **x86_64**: Intel Mac (Simulator)

## 🧪 Testing

### Run Tests

```bash
# Test build và list functions
./cpp/scripts/build.sh test
```

### Manual Test

```bash
cd cpp

# Build test version
conan install . --output-folder=./out/test --build=missing \
  --profile:host=./conan_profiles/ios_profile \
  --profile:build=default

TOOLCHAIN_FILE="$(pwd)/out/test/build/Release/generators/conan_toolchain.cmake"
cmake -B out/test -S . \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
  -DCMAKE_BUILD_TYPE=Release

cmake --build out/test --target SecurityCore -- -j4

echo "✅ Test build successful!"
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Conan not found

```bash
# Install Conan
pip install conan

# Verify installation
conan --version
```

#### 2. Android NDK not found

```bash
# Check NDK path in scripts
cat cpp/scripts/build_android.sh | grep NDK_PATH

# Update path if needed
export ANDROID_NDK=$HOME/Library/Android/sdk/ndk/YOUR_VERSION
```

#### 3. CMake errors

```bash
# Clean build directory
rm -rf cpp/out/

# Reinstall dependencies
cd cpp
conan install . --output-folder=./out/test --build=missing
```

#### 4. OpenSSL not found

```bash
# Ensure Conan is properly configured
conan profile list
conan profile show default

# Reinstall with build=missing
conan install . --build=missing
```

### Debug Build

```bash
# Build with debug info
cmake -B out/debug -S . \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
  -DCMAKE_BUILD_TYPE=Debug

cmake --build out/debug --target SecurityCore
```

### Verbose Output

```bash
# Show detailed build output
cmake --build out/ios --target SecurityCore -- -j4 VERBOSE=1
```

## 📁 Output Files

### Android

```
android/app/src/main/jniLibs/
├── armeabi-v7a/libSecurityCore.so
├── arm64-v8a/libSecurityCore.so
├── x86/libSecurityCore.so
└── x86_64/libSecurityCore.so
```

### iOS

```
ios/
└── libSecurityCore.a
```

## 🚀 Integration

### React Native

1. Build native libraries (see above)
2. Link libraries trong React Native project
3. Import và sử dụng trong JavaScript/TypeScript

### Native Android

1. Copy `.so` files vào `jniLibs/`
2. Load library trong Java/Kotlin
3. Call native functions

### Native iOS

1. Add `.a` file vào Xcode project
2. Link library trong build settings
3. Import header và call functions
