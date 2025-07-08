# 🔒 React Native Security Core

Advanced security library for React Native apps with anti-debugging, anti-Frida, and code integrity protection.

## 📋 Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Documentation](#documentation)
- [Contributing](#contributing)

## ✨ Features

### 🛡️ Security Protection

- **Anti-Debugging**: Detect debugger attachment
- **Anti-Frida**: Detect Frida and dynamic instrumentation
- **Code Integrity**: Verify code hasn't been tampered
- **Self-Healing**: Automatically restore modified code
- **Multi-Platform**: Android and iOS support

### 📱 Platform Support

- **Android**: ARMv7, ARMv8, x86, x86_64
- **iOS**: ARM64, x86_64 (simulator)
- **React Native**: 0.60+ support

## 🚀 Quick Start

### 1. Build Library (Recommended)

```bash
# Build complete library (clean + setup + build + prepare)
yarn build

# Platform-specific builds
yarn build:android  # Android only
yarn build:ios      # iOS only
```

### 2. Development Builds

```bash
# Development builds (no clean)
yarn dev            # Build all platforms
yarn dev:android    # Android only
yarn dev:ios        # iOS only
```

### 2. Use in React Native

```typescript
import SecurityCoreHelper from 'react-native-security-core';

// Check all security
const security = await SecurityCoreHelper.checkAllSecurity();

if (!security.overall) {
  console.log('Security breach detected!');
  console.log('Android:', security.android);
  console.log('iOS:', security.ios);
}
```

## 📦 Installation

### Prerequisites

```bash
# Install required tools
pip install conan
brew install cmake  # macOS
sudo apt install cmake  # Ubuntu
```

### Build Native Libraries

```bash
# Complete build (recommended)
yarn build

# Platform-specific builds
yarn build:android  # Android only
yarn build:ios      # iOS only

# Development builds (no clean)
yarn dev            # Build all platforms
yarn dev:android    # Android only
yarn dev:ios        # iOS only

# Manual link management (optional)
yarn link           # Create symbolic links manually
yarn unlink         # Remove symbolic links
yarn check:links    # Check link status
```

### Link Libraries

#### Android

```kotlin
// Add to MainApplication.kt
import com.securitycore.SecurityCorePackage

class MainApplication : Application(), ReactApplication {
    private val mReactNativeHost = object : ReactNativeHost(this) {
        override fun getPackages(): List<ReactPackage> {
            return PackageList(this).packages.apply {
                add(SecurityCorePackage())
            }
        }
    }
}
```

#### iOS

```objc
// Add to AppDelegate.mm
#import "SecurityCore.h"

@implementation AppDelegate
- (NSArray<id<RCTBridgeModule>> *)extraModulesForBridge:(RCTBridge *)bridge {
    return @[[SecurityCore new]];
}
@end
```

## 💡 Usage

### Basic Security Check

```typescript
import SecurityCoreHelper from 'react-native-security-core';

// Check all security
const security = await SecurityCoreHelper.checkAllSecurity();

if (!security.overall) {
  // Handle security breach
  handleSecurityBreach();
}
```

### Platform-specific Checks

```typescript
// Android security
const androidSecure = await SecurityCoreHelper.checkAndroidSecurity();
const debuggerDetected = await SecurityCore.detectDebugger();

// iOS security
const iosSecure = await SecurityCoreHelper.checkIOSSecurity();
const fridaDetected = await SecurityCore.runIOSAntiFrida();
```

### Utility Functions

```typescript
// Decode string
const decoded = await SecurityCore.xorDecode('encoded_string', 0xaa);

// Calculate checksum
const checksum = await SecurityCore.crc32([1, 2, 3, 4, 5]);

// Start self-healing
await SecurityCore.startSelfHeal();
```

## 📖 API Reference

### Android Security Functions

| Function              | Description                     | Returns            |
| --------------------- | ------------------------------- | ------------------ |
| `runAdvancedChecks()` | Run all Android security checks | `Promise<boolean>` |
| `detectDebugger()`    | Detect debugger attachment      | `Promise<boolean>` |
| `detectFridaThread()` | Detect Frida threads            | `Promise<boolean>` |
| `detectMemoryMaps()`  | Analyze memory maps             | `Promise<boolean>` |
| `checkProcessName()`  | Validate process name           | `Promise<boolean>` |
| `verifyIntegrity()`   | Check code integrity            | `Promise<boolean>` |

### iOS Security Functions

| Function                 | Description               | Returns            |
| ------------------------ | ------------------------- | ------------------ |
| `runIOSAntiFrida()`      | Run iOS anti-Frida checks | `Promise<boolean>` |
| `runIOSSecurityChecks()` | Run iOS security checks   | `Promise<boolean>` |
| `detectFridaLibraries()` | Detect Frida libraries    | `Promise<boolean>` |
| `detectFridaEnv()`       | Check Frida environment   | `Promise<boolean>` |
| `detectFridaFiles()`     | Scan for Frida files      | `Promise<boolean>` |
| `detectFridaSymbols()`   | Detect Frida symbols      | `Promise<boolean>` |
| `detectCodeInjection()`  | Detect code injection     | `Promise<boolean>` |

### Utility Functions

| Function                  | Description               | Returns            |
| ------------------------- | ------------------------- | ------------------ |
| `xorDecode(encoded, key)` | Decode XOR-encoded string | `Promise<string>`  |
| `crc32(data)`             | Calculate CRC32 checksum  | `Promise<number>`  |
| `startSelfHeal()`         | Start self-healing        | `Promise<boolean>` |

## 📚 Documentation

| Document                                              | Description                   |
| ----------------------------------------------------- | ----------------------------- |
| [📜 Scripts Guide](docs/SCRIPTS.md)                   | All available scripts         |
| [🔗 Integration Guide](docs/INTEGRATION_GUIDE.md)     | Complete integration guide    |
| [📖 API Reference](cpp/docs/API.md)                   | Detailed API documentation    |
| [🔨 Build Guide](cpp/docs/BUILD_GUIDE.md)             | Build instructions            |
| [🛡️ Security Features](cpp/docs/SECURITY_FEATURES.md) | Security features explanation |
| [📁 Directory Structure](cpp/DIRECTORY_STRUCTURE.md)  | Project structure overview    |

## 🚀 Best Practices

1. **Check on App Start**: Run security checks when app starts
2. **Periodic Checks**: Run checks periodically during app usage
3. **Graceful Handling**: Don't crash app on security breach
4. **User Feedback**: Inform users about security status
5. **Server Validation**: Combine with server-side security checks

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

# Setup environment
./cpp/scripts/setup.sh all

# Test build
./cpp/scripts/build.sh test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Frida Community**: For inspiring anti-detection techniques
- **React Native Community**: For the amazing framework
- **Open Source Contributors**: For valuable feedback and contributions

---

**🔒 SecurityCore** - Protecting React Native apps with advanced security features
