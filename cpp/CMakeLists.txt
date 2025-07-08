cmake_minimum_required(VERSION 3.6)
project(SecurityCore)

# Find Conan dependencies
find_package(OpenSSL REQUIRED)

set(CMAKE_CXX_STANDARD 11)

# Add src files
file(GLOB SOURCE_FILES "src/*.cpp")

# Determine library type based on platform
if(ANDROID)
    set(LIBRARY_TYPE SHARED)
    set(LIBRARY_NAME SecurityCore)
else()
    set(LIBRARY_TYPE STATIC)
    set(LIBRARY_NAME SecurityCore)
endif()

add_library(
    ${LIBRARY_NAME}
    ${LIBRARY_TYPE}
    ${SOURCE_FILES}
)

target_link_libraries(${LIBRARY_NAME} OpenSSL::SSL OpenSSL::Crypto)

# Add log library for Android
if(ANDROID)
    target_link_libraries(${LIBRARY_NAME} log)
endif()

target_include_directories(
    ${LIBRARY_NAME}
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)


