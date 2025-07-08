# 🔒 SecurityCore - React Native Security Library

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Features](#features)
- [Documentation](#documentation)
- [Building](#building)
- [API Reference](#api-reference)
- [Contributing](#contributing)

## 🎯 Overview

SecurityCore là thư viện bảo mật toàn diện cho React Native apps, cung cấp:

- **🛡️ Anti-Debugging**: Phát hiện debugger và analysis tools
- **🔍 Anti-Frida**: Phát hiện Frida và dynamic instrumentation
- **🔒 Code Integrity**: Kiểm tra và bảo vệ tính toàn vẹn code
- **🔄 Self-Healing**: Tự động sửa chữa code bị thay đổi
- **📱 Multi-Platform**: Hỗ trợ Android và iOS
- **🏗️ Multi-Architecture**: ARMv7, ARMv8, x86, x86_64

## 🚀 Quick Start

### 1. Build Libraries

```bash
# Build cho Android (tất cả ABIs)
./cpp/scripts/build_android.sh

# Build cho iOS
./cpp/scripts/build_ios.sh
```

### 2. Test Build

```bash
# Test build và list functions
./cpp/scripts/test.sh
```

### 3. Use in React Native

```typescript
import { NativeModules } from 'react-native';

const { SecurityCore } = NativeModules;

// Android security check
const androidSecure = await SecurityCore.runAdvancedChecks();

// iOS anti-Frida check
const fridaDetected = await SecurityCore.runIOSAntiFrida();

if (!androidSecure || fridaDetected) {
  console.log('Security breach detected!');
}
```

## ✨ Features

### 📱 Android Features

- **Debugger Detection**: Phát hiện ptrace và debugger
- **Frida Detection**: Scan threads và memory maps
- **Process Validation**: Kiểm tra process name
- **Code Integrity**: Verify function signatures
- **Multi-Architecture**: ARMv7, ARMv8, x86, x86_64

### 🍎 iOS Features

- **Anti-Frida**: Library scanning, symbol detection
- **Jailbreak Detection**: File system checks
- **Environment Monitoring**: Variable scanning
- **Code Injection Detection**: Mach-O analysis
- **Multi-Architecture**: ARM64, x86_64 (simulator)

### 🔧 Utility Functions

- **XOR Decryption**: Obfuscate strings
- **CRC32 Checksum**: Data integrity verification
- **Self-Healing**: Background code restoration

## 📚 Documentation

| Document                                          | Description                   |
| ------------------------------------------------- | ----------------------------- |
| [📖 API Reference](docs/API.md)                   | Complete API documentation    |
| [🔨 Build Guide](docs/BUILD_GUIDE.md)             | Detailed build instructions   |
| [🛡️ Security Features](docs/SECURITY_FEATURES.md) | Security features explanation |
| [📁 Directory Structure](DIRECTORY_STRUCTURE.md)  | Project structure overview    |

## 🔨 Building

### Prerequisites

```bash
# Install required tools
pip install conan
brew install cmake  # macOS
sudo apt install cmake  # Ubuntu

# Verify installation
conan --version
cmake --version
```

### Quick Setup & Build

```bash
# Setup environment
./cpp/scripts/setup.sh all

# Build for platforms
./cpp/scripts/build.sh android
./cpp/scripts/build.sh ios
./cpp/scripts/build.sh all

# Test build
./cpp/scripts/build.sh test
```

### Output Files

```
📁 Android
├── android/app/src/main/jniLibs/armeabi-v7a/libSecurityCore.so
├── android/app/src/main/jniLibs/arm64-v8a/libSecurityCore.so
├── android/app/src/main/jniLibs/x86/libSecurityCore.so
└── android/app/src/main/jniLibs/x86_64/libSecurityCore.so

📁 iOS
└── ios/libSecurityCore.a
```

## 📖 API Reference

### Main Functions

```cpp
#include "SecurityCore.h"

// Android security checks
bool run_advanced_checks();
bool detect_debugger();
bool detect_frida_thread();
bool detect_memory_maps();
bool check_process_name();
bool verify_integrity();

// iOS anti-Frida checks
bool run_ios_anti_frida();
bool run_ios_security_checks();
bool detect_frida_libraries();
bool detect_frida_env();
bool detect_frida_files();
bool detect_frida_symbols();
bool detect_code_injection();

// Utility functions
const char* xor_decode(const char* enc, char key);
unsigned int crc32(unsigned char* data, size_t len);
void start_self_heal();
```

### React Native Integration

```typescript
import { NativeModules } from 'react-native';

const { SecurityCore } = NativeModules;

// Security checks
const androidSecure = await SecurityCore.runAdvancedChecks();
const fridaDetected = await SecurityCore.runIOSAntiFrida();
const iosSecure = await SecurityCore.runIOSSecurityChecks();

// Handle results
if (!androidSecure || fridaDetected || !iosSecure) {
  // Implement security breach handling
  console.log('Security breach detected!');
}
```

## 🏗️ Project Structure

```
cpp/
├── 📁 src/                    # Source code
│   ├── SecurityCore.cpp       # 🔒 Core security functions
│   └── WebSocketClient.cpp    # 🌐 WebSocket functionality
│
├── 📁 include/                # Headers
│   ├── SecurityCore.h         # 🔒 Main API
│   ├── WebSocketClient.h      # 🌐 WebSocket API
│   └── WebSocketListener.h    # 🌐 WebSocket callbacks
│
├── 📁 conan_profiles/         # Build configurations
│   ├── android_armv7_profile  # 📱 Android ARMv7
│   ├── android_armv8_profile  # 📱 Android ARMv8
│   ├── android_x86_profile    # 📱 Android x86
│   ├── android_x86_64_profile # 📱 Android x86_64
│   └── ios_profile           # 🍎 iOS
│
├── 📁 scripts/               # Build scripts
│   ├── build_android.sh      # 📱 Build Android
│   ├── build_ios.sh          # 🍎 Build iOS
│   └── test.sh               # 🧪 Run tests
│
├── 📁 docs/                  # Documentation
│   ├── API.md               # 📚 API docs
│   ├── BUILD_GUIDE.md       # 🔨 Build guide
│   └── SECURITY_FEATURES.md # 🛡️ Security features
│
├── CMakeLists.txt           # 🔨 CMake config
├── conanfile.txt           # 📦 Dependencies
└── README.md              # 📖 This file
```

## ⚠️ Limitations

1. **iOS Non-Jailbreak**: Limited detection on non-jailbroken devices
2. **Frida Evolution**: Frida constantly evolves to bypass detection
3. **App Store**: Some methods may be rejected by App Store
4. **Performance**: Security checks may impact performance
5. **False Positives**: Legitimate apps may trigger alerts

## 🛠️ Best Practices

1. **Combine Methods**: Use multiple detection techniques
2. **Regular Updates**: Keep detection methods current
3. **Code Obfuscation**: Obfuscate detection code
4. **Server Validation**: Combine with server-side checks
5. **Graceful Handling**: Don't crash app on detection

## 🤝 Contributing

1. **Fork** the repository
2. **Create** feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** changes (`git commit -m 'Add amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Open** Pull Request

### Development Setup

```bash
# Clone repository
git clone https://github.com/your-username/react-native-security-core.git
cd react-native-security-core

# Install dependencies
pip install conan

# Test build
./cpp/scripts/test.sh
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## 🙏 Acknowledgments

- **Frida Community**: For inspiring anti-detection techniques
- **React Native Community**: For the amazing framework
- **Open Source Contributors**: For valuable feedback and contributions

---

**🔒 SecurityCore** - Protecting React Native apps with advanced security features
