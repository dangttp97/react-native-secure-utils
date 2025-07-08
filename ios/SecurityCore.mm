#import "SecurityCore.h"
#import <React/RCTLog.h>

// Import C++ library
extern "C" {
    #include "SecurityCore.h"
}

@implementation SecurityCore

RCT_EXPORT_MODULE()

// ========== Android Security Functions ==========

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

RCT_EXPORT_METHOD(detectDebugger:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_debugger();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(detectFridaThread:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_frida_thread();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(detectMemoryMaps:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_memory_maps();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(checkProcessName:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = check_process_name();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(verifyIntegrity:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = verify_integrity();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

// ========== iOS Security Functions ==========

RCT_EXPORT_METHOD(runIOSAntiFrida:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = run_ios_anti_frida();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(runIOSSecurityChecks:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = run_ios_security_checks();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(detectFridaLibraries:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_frida_libraries();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(detectFridaEnv:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_frida_env();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(detectFridaFiles:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_frida_files();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(detectFridaSymbols:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_frida_symbols();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(detectCodeInjection:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = detect_code_injection();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(isRooted:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        bool result = is_rooted();
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

// ========== Utility Functions ==========

RCT_EXPORT_METHOD(xorDecode:(NSString *)encoded
                  key:(char)key
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        const char* result = xor_decode([encoded UTF8String], key);
        resolve(@(result ? @(result) : @""));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(crc32:(NSArray *)data
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        // Convert NSArray to unsigned char array
        NSInteger length = [data count];
        unsigned char *bytes = malloc(length);
        
        for (NSInteger i = 0; i < length; i++) {
            bytes[i] = [[data objectAtIndex:i] unsignedCharValue];
        }
        
        unsigned int result = crc32(bytes, length);
        free(bytes);
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(startSelfHeal:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        start_self_heal();
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"ERROR", exception.reason, nil);
    }
}

// ========== Module Configuration ==========

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

@end
