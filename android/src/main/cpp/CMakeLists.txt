cmake_minimum_required(VERSION 3.4.1)

project("react-native-security-core")

include_directories(
    ../../../include
)

# Tạo thư viện JNI bridge (nếu có file .cpp JNI)
add_library(SecurityCoreJNI SHARED SecurityCoreJNI.cpp)

# Khai báo thư viện .so đã build sẵn là IMPORTED
add_library(SecurityCore SHARED IMPORTED)
# Chỉ định đường dẫn .so cho từng ABI
set_target_properties(SecurityCore PROPERTIES
        IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/../jniLibs/${ANDROID_ABI}/libSecurityCore.so"
)

# Link JNI bridge với thư viện .so gốc và log
find_library(log-lib log)

target_link_libraries(SecurityCoreJNI
        SecurityCore
        ${log-lib}
)
