# 📁 Cấu trúc thư mục SecurityCore

```
cpp/
├── 📁 src/                    # Source code chính
│   ├── SecurityCore.cpp       # 🔒 Core security functions
│   └── WebSocketClient.cpp    # 🌐 WebSocket functionality
│
├── 📁 include/                # Headers
│   ├── SecurityCore.h         # 🔒 Main API
│   ├── WebSocketClient.h      # 🌐 WebSocket API
│   └── WebSocketListener.h    # 🌐 WebSocket callbacks
│
├── 📁 conan_profiles/         # Build configurations
│   ├── android_armv7_profile  # 📱 Android ARMv7 (32-bit)
│   ├── android_armv8_profile  # 📱 Android ARMv8 (64-bit)
│   ├── android_x86_profile    # 📱 Android x86 (32-bit)
│   ├── android_x86_64_profile # 📱 Android x86_64 (64-bit)
│   └── ios_profile           # 🍎 iOS (ARM64 + x86_64)
│
├── 📁 scripts/               # Build scripts
│   ├── build.sh              # 🚀 Main build script
│   ├── setup.sh              # 🔧 Setup environment
│   ├── build_android.sh      # 📱 Build Android
│   ├── build_ios.sh          # 🍎 Build iOS
│   ├── test.sh               # 🧪 Run tests
│   └── make_executable.sh    # 🔧 Make scripts executable
│
├── 📁 docs/                  # Documentation
│   ├── API.md               # 📚 API documentation
│   ├── BUILD_GUIDE.md       # 🔨 Build instructions
│   └── SECURITY_FEATURES.md # 🛡️ Security features
│
├── CMakeLists.txt           # 🔨 CMake configuration
├── conanfile.txt           # 📦 Conan dependencies
├── README.md              # 📖 Main documentation
└── DIRECTORY_STRUCTURE.md # 📁 This file
```

## 🎯 Mục đích từng thư mục

### `src/` - Source Code

- **SecurityCore.cpp**: Tất cả security functions (Android + iOS)
- **WebSocketClient.cpp**: WebSocket functionality

### `include/` - Headers

- **SecurityCore.h**: Main API cho security functions
- **WebSocket\*.h**: WebSocket API

### `conan_profiles/` - Build Configs

- Mỗi file cho 1 architecture/platform
- Định nghĩa compiler, flags, paths

### `scripts/` - Build Scripts

- **build.sh**: Main script để build tất cả platforms
- **setup.sh**: Setup environment cho từng platform
- **build_android.sh**: Build cho Android multi-arch
- **build_ios.sh**: Build cho iOS
- **test.sh**: Test build và list functions
- **make_executable.sh**: Make scripts executable

### `docs/` - Documentation

- **API.md**: Complete API documentation
- **BUILD_GUIDE.md**: Detailed build instructions
- **SECURITY_FEATURES.md**: Security features explanation

## 🚀 Quick Commands

```bash
# Setup environment
./cpp/scripts/setup.sh all

# Build libraries
./cpp/scripts/build.sh all

# Test build
./cpp/scripts/build.sh test

# Make scripts executable
./cpp/scripts/make_executable.sh
```
