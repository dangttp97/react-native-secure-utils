# 🔗 Integration Guide - SecurityCore

## 📋 Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Android Setup](#android-setup)
- [iOS Setup](#ios-setup)
- [React Native Integration](#react-native-integration)
- [API Reference](#api-reference)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

SecurityCore cung cấp security functions cho React Native apps trên cả Android và iOS. Tất cả functions đều có cùng interface, giúp cross-platform development dễ dàng.

## 📦 Installation

### 1. Build Native Libraries

```bash
# Setup environment
./cpp/scripts/setup.sh all

# Build libraries
./cpp/scripts/build.sh all
```

### 2. Link Libraries

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

## 📱 Android Setup

### 1. Kotlin Module

```kotlin
// android/app/src/main/java/com/securitycore/SecurityCoreModule.kt
class SecurityCoreModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    @ReactMethod
    fun runAdvancedChecks(promise: Promise) {
        try {
            val result = runAdvancedChecksNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    // ... other methods
}
```

### 2. Package Registration

```kotlin
// android/app/src/main/java/com/securitycore/SecurityCorePackage.kt
class SecurityCorePackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return listOf(SecurityCoreModule(reactContext))
    }
}
```

### 3. Native Library Loading

```kotlin
companion object {
    init {
        System.loadLibrary("SecurityCore")
    }
}
```

## 🍎 iOS Setup

### 1. Objective-C++ Module

```objc
// ios/SecurityCore.mm
#import "SecurityCore.h"

@implementation SecurityCore

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(runAdvancedChecks:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = run_advanced_checks();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

// ... other methods
@end
```

### 2. Header File

```objc
// ios/SecurityCore.h
#import <React/RCTBridgeModule.h>

@interface SecurityCore : NSObject <RCTBridgeModule>

- (void)runAdvancedChecks:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject;

// ... other method declarations

@end
```

## ⚛️ React Native Integration

### 1. TypeScript Interface

```typescript
// src/index.tsx
export interface SecurityCoreInterface {
  // Android Security Functions
  runAdvancedChecks(): Promise<boolean>;
  detectDebugger(): Promise<boolean>;
  detectFridaThread(): Promise<boolean>;

  // iOS Security Functions
  runIOSAntiFrida(): Promise<boolean>;
  runIOSSecurityChecks(): Promise<boolean>;

  // Utility Functions
  xorDecode(encoded: string, key: number): Promise<string>;
  crc32(data: number[]): Promise<number>;
  startSelfHeal(): Promise<boolean>;
}
```

### 2. Helper Class

```typescript
export class SecurityCoreHelper {
  // Android Security
  static async checkAndroidSecurity(): Promise<boolean> {
    return await this.instance.runAdvancedChecks();
  }

  // iOS Security
  static async checkIOSSecurity(): Promise<boolean> {
    const fridaClean = await this.instance.runIOSAntiFrida();
    const iosSecure = await this.instance.runIOSSecurityChecks();
    return fridaClean && iosSecure;
  }

  // Cross-platform
  static async checkAllSecurity(): Promise<{
    android: boolean;
    ios: boolean;
    overall: boolean;
  }> {
    const androidSecure = await this.checkAndroidSecurity();
    const iosSecure = await this.checkIOSSecurity();

    return {
      android: androidSecure,
      ios: iosSecure,
      overall: androidSecure && iosSecure,
    };
  }
}
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

## 💡 Examples

### Basic Security Check

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

### Platform-specific Checks

```typescript
// Android only
const androidSecure = await SecurityCoreHelper.checkAndroidSecurity();
const debuggerDetected = await SecurityCore.detectDebugger();

// iOS only
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

### Error Handling

```typescript
try {
  const secure = await SecurityCoreHelper.checkAllSecurity();
  if (!secure.overall) {
    // Handle security breach
    handleSecurityBreach();
  }
} catch (error) {
  console.error('Security check failed:', error);
  // Handle error gracefully
}
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Library not found

```bash
# Rebuild libraries
./cpp/scripts/build.sh all

# Check library files
ls android/app/src/main/jniLibs/
ls ios/
```

#### 2. Module not registered

```kotlin
// Android: Check MainApplication.kt
override fun getPackages(): List<ReactPackage> {
    return PackageList(this).packages.apply {
        add(SecurityCorePackage())  // Make sure this is added
    }
}
```

#### 3. TypeScript errors

```typescript
// Check interface matches native implementation
import SecurityCore, {
  SecurityCoreInterface,
} from 'react-native-security-core';
```

#### 4. Build errors

```bash
# Clean and rebuild
cd android && ./gradlew clean
cd ios && xcodebuild clean
./cpp/scripts/build.sh all
```

### Debug Mode

```typescript
// Enable debug logging
import { NativeModules } from 'react-native';
const { SecurityCore } = NativeModules;

// Add debug logging
console.log('SecurityCore module:', SecurityCore);
```

## 🚀 Best Practices

1. **Check on App Start**: Run security checks when app starts
2. **Periodic Checks**: Run checks periodically during app usage
3. **Graceful Handling**: Don't crash app on security breach
4. **User Feedback**: Inform users about security status
5. **Server Validation**: Combine with server-side security checks

## 📚 Additional Resources

- [API Documentation](API.md)
- [Build Guide](BUILD_GUIDE.md)
- [Security Features](SECURITY_FEATURES.md)
- [Directory Structure](DIRECTORY_STRUCTURE.md)
