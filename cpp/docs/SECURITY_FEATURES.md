# 🛡️ Security Features - SecurityCore

## Overview

SecurityCore cung cấp nhiều lớp bảo mật để bảo vệ React Native apps khỏi các tấn công phổ biến.

## 🔍 Detection Methods

### 1. Anti-Debugging

**Mục đích**: Phát hiện debugger đang attach vào app

**Cách hoạt động**:

- Sử dụng `ptrace(PTRACE_TRACEME)` trên Android
- Kiểm tra process flags và memory patterns
- Monitor system calls

**Code example**:

```cpp
bool detect_debugger() {
#if !defined(__APPLE__) || defined(__ANDROID__)
    return ptrace(PTRACE_TRACEME, 0, 0, 0) == -1;
#else
    return false; // iOS không hỗ trợ ptrace
#endif
}
```

### 2. Anti-Frida

**Mục đích**: Phát hiện Frida và dynamic instrumentation tools

**Android Methods**:

- Thread scanning: Tìm `gum-js-loop` threads
- Memory map analysis: Scan `/proc/self/maps`
- Process name validation

**iOS Methods**:

- Library scanning: `_dyld_image_count()` và `_dyld_get_image_name()`
- Symbol detection: `dlsym()` cho Frida symbols
- Environment variables: Check `FRIDA_*` vars
- File system: Scan suspicious paths
- Code injection: Analyze Mach-O segments

**Code example**:

```cpp
bool detect_frida_libraries() {
#if defined(__APPLE__) && !defined(__ANDROID__)
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char* name = _dyld_get_image_name(i);
        if (name && (strstr(name, "frida") || strstr(name, "gum"))) {
            return true;
        }
    }
#endif
    return false;
}
```

### 3. Code Integrity

**Mục đích**: Đảm bảo code không bị thay đổi

**Cách hoạt động**:

- Verify function signatures
- Check code checksums
- Monitor memory regions
- Self-healing capabilities

**Code example**:

```cpp
bool verify_integrity() {
    void* addr = (void*)&sensitive_function;
    unsigned char expected[] = {0x90, 0x90, 0xC3}; // nop, nop, ret
    return memcmp((unsigned char*)addr, expected, sizeof(expected)) == 0;
}
```

### 4. Self-Healing

**Mục đích**: Tự động sửa chữa code bị thay đổi

**Cách hoạt động**:

- Background thread monitoring
- Memory protection với `mprotect()`
- Automatic code restoration

**Code example**:

```cpp
void heal_function() {
    unsigned char expected[] = {0x90, 0x90, 0xC3};
    void* addr = (void*)&sensitive_function;

    size_t page_size = sysconf(_SC_PAGESIZE);
    uintptr_t page = (uintptr_t)addr & ~(page_size - 1);
    mprotect((void*)page, page_size, PROT_READ | PROT_WRITE | PROT_EXEC);

    while (true) {
        if (memcmp((unsigned char*)addr, expected, sizeof(expected)) != 0) {
            LOG("Function tampered! Healing...\n");
            memcpy((unsigned char*)addr, expected, sizeof(expected));
        }
        std::this_thread::sleep_for(std::chrono::seconds(2));
    }
}
```

## 🎯 Platform-Specific Features

### Android Features

- **ptrace detection**: Phát hiện debugger
- **Process monitoring**: Kiểm tra `/proc/self/`
- **Memory map analysis**: Scan `/proc/self/maps`
- **Thread scanning**: Tìm suspicious threads
- **Multi-architecture**: ARMv7, ARMv8, x86, x86_64

### iOS Features

- **Library scanning**: `_dyld_*` functions
- **Symbol detection**: `dlsym()` và `dlopen()`
- **Mach-O analysis**: Segment và section scanning
- **Jailbreak detection**: File system checks
- **Environment monitoring**: Variable scanning

## 🔧 Utility Functions

### XOR Decryption

**Mục đích**: Obfuscate strings để tránh static analysis

```cpp
const char* xor_decode(const char* enc, char key) {
    static char buf[128];
    int i = 0;
    while (enc[i]) {
        buf[i] = enc[i] ^ key;
        i++;
    }
    buf[i] = '\0';
    return buf;
}
```

### CRC32 Checksum

**Mục đích**: Verify data integrity

```cpp
unsigned int crc32(unsigned char* data, size_t len) {
    unsigned int crc = 0xFFFFFFFF;
    for (size_t i = 0; i < len; ++i) {
        crc ^= data[i];
        for (int j = 0; j < 8; ++j)
            crc = (crc >> 1) ^ (0xEDB88320 & -(crc & 1));
    }
    return ~crc;
}
```

## 🚨 Security Levels

### Level 1: Basic Detection

- Debugger detection
- Simple Frida detection
- Process validation

### Level 2: Advanced Detection

- Memory map analysis
- Symbol scanning
- Code integrity checks

### Level 3: Active Protection

- Self-healing
- Real-time monitoring
- Anti-tampering

## ⚠️ Limitations

### iOS Non-Jailbreak

- Limited detection capabilities
- Sandbox restrictions
- App Store limitations

### Frida Evolution

- Frida constantly evolves
- Detection methods need updates
- False positives possible

### Performance Impact

- Security checks consume resources
- Real-time monitoring overhead
- Memory usage increase

## 🛠️ Best Practices

### 1. Combine Methods

```cpp
// Don't rely on single detection method
if (detect_debugger() || detect_frida_thread() || detect_memory_maps()) {
    // Handle compromise
}
```

### 2. Regular Updates

- Keep detection methods current
- Monitor Frida updates
- Update signatures regularly

### 3. Code Obfuscation

- Obfuscate detection code
- Use XOR encoding
- Hide function names

### 4. Server Validation

- Combine with server-side checks
- Implement behavioral analysis
- Use machine learning

### 5. Graceful Degradation

```cpp
// Don't crash app on detection
if (detect_compromise()) {
    // Log incident
    // Implement countermeasures
    // Continue with limited functionality
}
```

## 🔮 Future Enhancements

### Planned Features

1. **Network Traffic Analysis**: Detect Frida network communication
2. **Memory Pattern Analysis**: Advanced memory scanning
3. **Behavioral Detection**: Monitor API call patterns
4. **Machine Learning**: ML-based anomaly detection
5. **Real-time Monitoring**: Continuous security monitoring

### Research Areas

- **Anti-VM Detection**: Detect virtual machines
- **Anti-Analysis**: Prevent static analysis
- **Code Virtualization**: Virtualize sensitive code
- **Hardware-based**: Use hardware security features
