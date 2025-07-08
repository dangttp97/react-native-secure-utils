# 🔗 Symbolic Links - SecurityCore

## Overview

SecurityCore sử dụng symbolic links để link libraries từ `cpp/out/` đến platform directories thay vì copy files. Điều này giúp:

- **Tiết kiệm disk space**: Không duplicate files
- **Auto-update**: Khi rebuild, links tự động point đến files mới
- **Consistency**: Đảm bảo luôn dùng files mới nhất
- **Easy management**: Dễ dàng manage và cleanup

## 📁 Structure

```
cpp/
├── out/                          # Build output
│   ├── armeabi-v7a/
│   │   └── libSecurityCore.so   # Android ARMv7
│   ├── arm64-v8a/
│   │   └── libSecurityCore.so   # Android ARMv8
│   ├── x86/
│   │   └── libSecurityCore.so   # Android x86
│   ├── x86_64/
│   │   └── libSecurityCore.so   # Android x86_64
│   └── ios/
│       └── libSecurityCore.a    # iOS library
│
android/src/main/jniLibs/     # Android links
├── armeabi-v7a/
│   └── libSecurityCore.so -> ../../../cpp/out/armeabi-v7a/libSecurityCore.so
├── arm64-v8a/
│   └── libSecurityCore.so -> ../../../cpp/out/arm64-v8a/libSecurityCore.so
├── x86/
│   └── libSecurityCore.so -> ../../../cpp/out/x86/libSecurityCore.so
└── x86_64/
    └── libSecurityCore.so -> ../../../cpp/out/x86_64/libSecurityCore.so
│
ios/                              # iOS link
└── libSecurityCore.a -> ../cpp/out/ios/libSecurityCore.a
```

## 🚀 Usage

### Automatic Linking (Recommended)

```bash
# Build và tự động link
./cpp/scripts/build.sh android  # Auto-links Android libraries
./cpp/scripts/build.sh ios      # Auto-links iOS library
./cpp/scripts/build.sh all      # Auto-links all libraries
```

### Manual Linking

```bash
# Link libraries manually
./cpp/scripts/build.sh link

# Unlink libraries
./cpp/scripts/build.sh unlink
```

### Check Links

```bash
# Check symbolic links
ls -la android/app/src/main/jniLibs/*/libSecurityCore.so
ls -la ios/libSecurityCore.a
```

## 🔧 Commands

### Link Libraries

```bash
./cpp/scripts/build.sh link
```

**Mô tả**: Tạo symbolic links từ `cpp/out/` đến platform directories

### Unlink Libraries

```bash
./cpp/scripts/build.sh unlink
```

**Mô tả**: Remove symbolic links, giữ nguyên files gốc trong `cpp/out/`

### Check Links

```bash
./cpp/scripts/build.sh check
```

**Mô tả**: Check status của tất cả symbolic links

### Manual Check

```bash
# Check Android links
ls -la android/src/main/jniLibs/*/libSecurityCore.so

# Check iOS link
ls -la ios/libSecurityCore.a

# Check if links are valid
file android/src/main/jniLibs/arm64-v8a/libSecurityCore.so
file ios/libSecurityCore.a
```

## ⚠️ Important Notes

### 1. Git Ignore

```gitignore
# Ignore symbolic links in git
android/src/main/jniLibs/*/libSecurityCore.so
ios/libSecurityCore.a
```

### 2. Build Process

- **Build**: Libraries được build vào `cpp/out/`
- **Auto-Link**: Symbolic links được tạo tự động sau build
- **Update**: Khi rebuild, links tự động point đến files mới

### 3. Platform Support

- **macOS**: Symbolic links hoạt động bình thường
- **Linux**: Symbolic links hoạt động bình thường
- **Windows**: Cần WSL hoặc Git Bash để symbolic links

### 4. Troubleshooting

#### Broken Links

```bash
# Check if links are broken
find android/src/main/jniLibs -type l -exec test ! -e {} \; -print
find ios -type l -exec test ! -e {} \; -print

# Recreate links
./cpp/scripts/build.sh link
```

#### Permission Issues

```bash
# Check permissions
ls -la cpp/out/*/libSecurityCore.so
ls -la cpp/out/ios/libSecurityCore.a

# Fix permissions if needed
chmod 644 cpp/out/*/libSecurityCore.so
chmod 644 cpp/out/ios/libSecurityCore.a
```

#### File Not Found

```bash
# Check if source files exist
ls -la cpp/out/*/libSecurityCore.so
ls -la cpp/out/ios/libSecurityCore.a

# Rebuild if files missing
./cpp/scripts/build.sh all
```

## 🎯 Benefits

### 1. Disk Space

- **Before**: 4 copies cho Android + 1 copy cho iOS = 5 files
- **After**: 5 files gốc + 5 symbolic links = Tiết kiệm space

### 2. Consistency

- **Auto-sync**: Links luôn point đến files mới nhất
- **No manual copy**: Không cần copy files thủ công
- **Build once**: Build 1 lần, dùng ở nhiều nơi

### 3. Management

- **Easy cleanup**: `unlink` để remove links
- **Easy restore**: `link` để recreate links
- **Version control**: Chỉ track source files, ignore links

## 🔄 Workflow

### Development

```bash
# 1. Build libraries (auto-links)
./cpp/scripts/build.sh all

# 2. Libraries đã được linked tự động
# 3. Test trong React Native app
# 4. Rebuild khi cần (auto-links again)
./cpp/scripts/build.sh all
# Links tự động update
```

### Cleanup

```bash
# Remove links
./cpp/scripts/build.sh unlink

# Clean build
rm -rf cpp/out/

# Rebuild và link
./cpp/scripts/build.sh all
```

### CI/CD

```bash
# Build và auto-link trong CI
./cpp/scripts/build.sh all

# Verify links
ls -la android/src/main/jniLibs/*/libSecurityCore.so
ls -la ios/libSecurityCore.a
```

## 📋 Best Practices

1. **Always use scripts**: Dùng `build.sh` thay vì manual commands
2. **Check links**: Verify links sau khi build
3. **Cleanup properly**: Dùng `unlink` để remove links
4. **Version control**: Ignore symbolic links trong git
5. **Cross-platform**: Test trên macOS, Linux, Windows
