#include <jni.h>
#include <string>
#include "SecurityCore.h"

extern "C" {
JNIEXPORT jboolean JNICALL
Java_com_securitycore_SecurityCoreModule_runAdvancedChecksNative(JNIEnv *, jobject) {
    return run_advanced_checks() ? JNI_TRUE : JNI_FALSE;
}
JNIEXPORT jboolean JNICALL
Java_com_securitycore_SecurityCoreModule_detectDebuggerNative(JNIEnv *, jobject) {
    return detect_debugger() ? JNI_TRUE : JNI_FALSE;
}
JNIEXPORT jboolean JNICALL
Java_com_securitycore_SecurityCoreModule_detectFridaThreadNative(JNIEnv *, jobject) {
    return detect_frida_thread() ? JNI_TRUE : JNI_FALSE;
}
JNIEXPORT jboolean JNICALL
Java_com_securitycore_SecurityCoreModule_detectMemoryMapsNative(JNIEnv *, jobject) {
    return detect_memory_maps() ? JNI_TRUE : JNI_FALSE;
}
JNIEXPORT jboolean JNICALL
Java_com_securitycore_SecurityCoreModule_checkProcessNameNative(JNIEnv *, jobject) {
    return check_process_name() ? JNI_TRUE : JNI_FALSE;
}
JNIEXPORT jboolean JNICALL
Java_com_securitycore_SecurityCoreModule_verifyIntegrityNative(JNIEnv *, jobject) {
    return verify_integrity() ? JNI_TRUE : JNI_FALSE;
}
JNIEXPORT jstring JNICALL
Java_com_securitycore_SecurityCoreModule_xorDecodeNative(JNIEnv *env, jobject, jstring encoded,
                                                         jchar key) {
    const char *encStr = env->GetStringUTFChars(encoded, nullptr);
    const char *decoded = xor_decode(encStr, (char) key);
    jstring result = env->NewStringUTF(decoded);
    env->ReleaseStringUTFChars(encoded, encStr);
    return result;
}
JNIEXPORT jint JNICALL
Java_com_securitycore_SecurityCoreModule_crc32Native(JNIEnv *env, jobject, jbyteArray data) {
    jsize len = env->GetArrayLength(data);
    jbyte *bytes = env->GetByteArrayElements(data, nullptr);
    unsigned int crc = crc32((unsigned char *) bytes, len);
    env->ReleaseByteArrayElements(data, bytes, JNI_ABORT);
    return (jint) crc;
}
JNIEXPORT jboolean JNICALL
Java_com_securitycore_SecurityCoreModule_isRootedNative(JNIEnv *, jobject) {
    return is_rooted() ? JNI_TRUE : JNI_FALSE;
}
}
