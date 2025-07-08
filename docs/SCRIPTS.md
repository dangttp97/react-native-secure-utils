# 📜 Scripts Documentation

## 🚀 Build Scripts

### Complete Library Build

```bash
# Build complete library (clean + setup + build + prepare)
yarn build

# Platform-specific complete builds
yarn build:android  # Android only
yarn build:ios      # iOS only
```

**Mô tả**: Clean → Setup → Build CPP → Prepare TypeScript/JavaScript

### Development Builds

```bash
# Development builds (no clean)
yarn dev              # Build all platforms
yarn dev:android      # Build Android only
yarn dev:ios          # Build iOS only
```

**Mô tả**: Build CPP → Prepare TypeScript/JavaScript (không clean)

## 🔧 Build Process

### Complete Build

```bash
# One command build
yarn build              # Clean + Setup + Build + Prepare
yarn build:android      # Android only
yarn build:ios          # iOS only
```

**Mô tả**: Clean → Setup → Build CPP → Prepare TypeScript/JavaScript

### Development Build

```bash
# Quick development build
yarn dev                # Build + Prepare (no clean)
yarn dev:android        # Android only
yarn dev:ios            # iOS only
```

**Mô tả**: Build CPP → Prepare TypeScript/JavaScript (không clean)

## 🔗 Link Management

### Symbolic Links

```bash
# Link management
yarn link              # Create symbolic links
yarn unlink            # Remove symbolic links
yarn check:links       # Check link status
```

**Mô tả**: Quản lý symbolic links từ `cpp/out/` đến platform directories

## 🧹 Clean Scripts

### Clean Build

```bash
# Clean all build artifacts
yarn clean
```

**Mô tả**: Remove `android/build`, `example/android/build`, `example/android/app/build`, `example/ios/build`, `lib`, `cpp/out`

## 📋 Standard Scripts

### Development

```bash
# Standard development scripts
yarn test              # Run tests
yarn typecheck         # TypeScript type checking
yarn lint              # ESLint
yarn prepare           # Build TypeScript/JavaScript
yarn release           # Release with release-it
```

## 🔄 Workflow Examples

### First Time Setup

```bash
# Complete setup and build
yarn build
```

### Development Workflow

```bash
# Quick development build
yarn dev

# Platform-specific development
yarn dev:android
yarn dev:ios
```

### Link Management

```bash
# Check current links
yarn check:links

# Remove links (cleanup)
yarn unlink

# Recreate links
yarn link
```

### Testing

```bash
# Test build
yarn build:cpp:test

# Run tests
yarn test
```

## 📁 Output Structure

### After `yarn build`

```
react-native-security-core/
├── lib/                    # TypeScript/JavaScript output
│   ├── commonjs/
│   ├── module/
│   └── typescript/
├── android/src/main/jniLibs/  # Android libraries (symbolic links)
│   ├── armeabi-v7a/libSecurityCore.so
│   ├── arm64-v8a/libSecurityCore.so
│   ├── x86/libSecurityCore.so
│   └── x86_64/libSecurityCore.so
├── ios/                   # iOS library (symbolic link)
│   └── libSecurityCore.a
└── cpp/out/              # Native build output
    ├── armeabi-v7a/
    ├── arm64-v8a/
    ├── x86/
    ├── x86_64/
    └── ios/
```

## ⚡ Quick Commands

### One-liners

```bash
# Complete build
yarn build

# Development
yarn dev

# Check links
yarn check:links

# Clean everything
yarn clean
```

### Platform-specific

```bash
# Android only
yarn build:android
yarn dev:android

# iOS only
yarn build:ios
yarn dev:ios
```

## 🔍 Troubleshooting

### Common Issues

```bash
# If build fails, try clean build
yarn clean && yarn build

# If links are broken
yarn unlink && yarn link

# Check link status
yarn check:links
```

### Debug Commands

```bash
# Check what scripts do
yarn run --help

# Check specific script
yarn run build:lib

# Direct CPP access
cd cpp && ./scripts/build.sh check
```

## 📚 Related Documentation

- [🔗 Integration Guide](INTEGRATION_GUIDE.md) - Complete integration guide
- [🔨 Build Guide](cpp/docs/BUILD_GUIDE.md) - Detailed build instructions
- [🔗 Symbolic Links](cpp/docs/SYMBOLIC_LINKS.md) - Symbolic links documentation
