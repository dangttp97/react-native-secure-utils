# 🔒 SecurityCore API Documentation

## Overview

SecurityCore cung cấp các functions bảo mật cho React Native apps trên Android và iOS.

## 📱 Android Functions

### Main Security Check

```cpp
bool run_advanced_checks();
```

**Mô tả**: Chạy tất cả security checks cho Android
**Trả về**: `true` nếu an toàn, `false` nếu phát hiện compromise
**Ví dụ**:

```cpp
if (!run_advanced_checks()) {
    // App bị compromise
    exit(1);
}
```

### Individual Detection Functions

#### Debugger Detection

```cpp
bool detect_debugger();
```

**Mô tả**: Phát hiện debugger đang attach
**Trả về**: `true` nếu có debugger, `false` nếu không

#### Frida Thread Detection

```cpp
bool detect_frida_thread();
```

**Mô tả**: Phát hiện Frida threads trong process
**Trả về**: `true` nếu có Frida threads, `false` nếu không

#### Memory Map Analysis

```cpp
bool detect_memory_maps();
```

**Mô tả**: Phân tích memory maps để tìm suspicious patterns
**Trả về**: `true` nếu phát hiện suspicious patterns, `false` nếu không

#### Process Name Validation

```cpp
bool check_process_name();
```

**Mô tả**: Kiểm tra process name có đúng không
**Trả về**: `true` nếu process name đúng, `false` nếu không

#### Code Integrity Check

```cpp
bool verify_integrity();
```

**Mô tả**: Kiểm tra tính toàn vẹn của sensitive functions
**Trả về**: `true` nếu code nguyên vẹn, `false` nếu bị thay đổi

## 🍎 iOS Functions

### Main Anti-Frida Check

```cpp
bool run_ios_anti_frida();
```

**Mô tả**: Chạy tất cả anti-Frida checks cho iOS
**Trả về**: `true` nếu không có Frida, `false` nếu phát hiện Frida
**Ví dụ**:

```cpp
if (!run_ios_anti_frida()) {
    // Frida detected on iOS
    // Implement countermeasures
}
```

### iOS Security Checks

```cpp
bool run_ios_security_checks();
```

**Mô tả**: Kiểm tra jailbreak và iOS security
**Trả về**: `true` nếu iOS secure, `false` nếu jailbroken

### Individual iOS Detection Functions

#### Frida Library Detection

```cpp
bool detect_frida_libraries();
```

**Mô tả**: Scan loaded libraries để tìm Frida libraries
**Trả về**: `true` nếu phát hiện Frida libraries, `false` nếu không

#### Environment Variable Check

```cpp
bool detect_frida_env();
```

**Mô tả**: Kiểm tra Frida environment variables
**Trả về**: `true` nếu có Frida env vars, `false` nếu không

#### File System Check

```cpp
bool detect_frida_files();
```

**Mô tả**: Scan filesystem để tìm Frida files
**Trả về**: `true` nếu phát hiện Frida files, `false` nếu không

#### Symbol Detection

```cpp
bool detect_frida_symbols();
```

**Mô tả**: Tìm Frida symbols trong loaded libraries
**Trả về**: `true` nếu phát hiện Frida symbols, `false` nếu không

#### Code Injection Detection

```cpp
bool detect_code_injection();
```

**Mô tả**: Phát hiện code injection patterns
**Trả về**: `true` nếu phát hiện injection, `false` nếu không

## 🔧 Utility Functions

### XOR Decryption

```cpp
const char* xor_decode(const char* enc, char key);
```

**Mô tả**: Decrypt XOR-encoded strings
**Tham số**:

- `enc`: Encoded string
- `key`: XOR key
  **Trả về**: Decoded string

### CRC32 Calculation

```cpp
unsigned int crc32(unsigned char* data, size_t len);
```

**Mô tả**: Tính CRC32 checksum
**Tham số**:

- `data`: Data buffer
- `len`: Data length
  **Trả về**: CRC32 checksum

### Self-Healing

```cpp
void start_self_heal();
```

**Mô tả**: Bắt đầu background thread để tự động sửa chữa code
**Ví dụ**:

```cpp
// Start self-healing in background
start_self_heal();
```

## 📋 Usage Examples

### Basic Security Check

```cpp
#include "SecurityCore.h"

int main() {
    // Check Android security
    if (!run_advanced_checks()) {
        printf("Android compromised!\n");
        return 1;
    }

    // Check iOS security
    if (!run_ios_anti_frida()) {
        printf("Frida detected on iOS!\n");
        return 1;
    }

    printf("All security checks passed!\n");
    return 0;
}
```

### React Native Integration

```typescript
import { NativeModules } from 'react-native';

const { SecurityCore } = NativeModules;

// Android checks
const androidSecure = await SecurityCore.runAdvancedChecks();

// iOS checks
const fridaDetected = await SecurityCore.runIOSAntiFrida();
const iosSecure = await SecurityCore.runIOSSecurityChecks();

if (!androidSecure || fridaDetected || !iosSecure) {
  // Handle security breach
  console.log('Security breach detected!');
}
```

## ⚠️ Important Notes

1. **Platform Specific**: Một số functions chỉ hoạt động trên platform cụ thể
2. **Performance**: Security checks có thể ảnh hưởng performance
3. **False Positives**: Có thể có false positives, cần test kỹ
4. **App Store**: Một số methods có thể bị reject bởi App Store
