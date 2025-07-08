package com.securitycore

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule

class SecurityCoreModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    companion object {
        private const val MODULE_NAME = "SecurityCore"
        init {
            System.loadLibrary("SecurityCoreJNI")
        }
    }

    override fun getName(): String = MODULE_NAME

    // ========== Android Security Functions ==========

    @ReactMethod
    fun runAdvancedChecks(promise: Promise) {
        try {
            val result = runAdvancedChecksNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectDebugger(promise: Promise) {
        try {
            val result = detectDebuggerNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectFridaThread(promise: Promise) {
        try {
            val result = detectFridaThreadNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectMemoryMaps(promise: Promise) {
        try {
            val result = detectMemoryMapsNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun checkProcessName(promise: Promise) {
        try {
            val result = checkProcessNameNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun verifyIntegrity(promise: Promise) {
        try {
            val result = verifyIntegrityNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun isRooted(promise: Promise) {
        try {
            val result = isRootedNative()
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    // ========== iOS Security Functions (for compatibility) ==========

    @ReactMethod
    fun runIOSAntiFrida(promise: Promise) {
        try {
            // On Android, iOS functions return false
            promise.resolve(false)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun runIOSSecurityChecks(promise: Promise) {
        try {
            // On Android, iOS functions return false
            promise.resolve(false)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectFridaLibraries(promise: Promise) {
        try {
            // On Android, iOS functions return false
            promise.resolve(false)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectFridaEnv(promise: Promise) {
        try {
            // On Android, iOS functions return false
            promise.resolve(false)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectFridaFiles(promise: Promise) {
        try {
            // On Android, iOS functions return false
            promise.resolve(false)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectFridaSymbols(promise: Promise) {
        try {
            // On Android, iOS functions return false
            promise.resolve(false)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun detectCodeInjection(promise: Promise) {
        try {
            // On Android, iOS functions return false
            promise.resolve(false)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    // ========== Utility Functions ==========

    @ReactMethod
    fun xorDecode(encoded: String, key: Int, promise: Promise) {
        try {
            val result = xorDecodeNative(encoded, key.toChar())
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    @ReactMethod
    fun crc32(data: ReadableArray, promise: Promise) {
        try {
            val bytes = ByteArray(data.size())
            for (i in 0 until data.size()) {
                bytes[i] = data.getInt(i).toByte()
            }
            val result = crc32Native(bytes)
            promise.resolve(result)
        } catch (e: Exception) {
            promise.reject("ERROR", e.message)
        }
    }

    // ========== Native Functions ==========

    private external fun runAdvancedChecksNative(): Boolean
    private external fun detectDebuggerNative(): Boolean
    private external fun detectFridaThreadNative(): Boolean
    private external fun detectMemoryMapsNative(): Boolean
    private external fun checkProcessNameNative(): Boolean
    private external fun verifyIntegrityNative(): Boolean
    private external fun xorDecodeNative(encoded: String, key: Char): String
    private external fun crc32Native(data: ByteArray): Int
    private external fun isRootedNative(): Boolean
}
