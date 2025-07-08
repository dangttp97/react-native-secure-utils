#import <React/RCTBridgeModule.h>

@interface SecurityCore : NSObject <RCTBridgeModule>

// ========== Android Security Functions ==========
- (void)runAdvancedChecks:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject;

- (void)detectDebugger:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject;

- (void)detectFridaThread:(RCTPromiseResolveBlock)resolve
                   reject:(RCTPromiseRejectBlock)reject;

- (void)detectMemoryMaps:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject;

- (void)checkProcessName:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject;

- (void)verifyIntegrity:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject;

// ========== iOS Security Functions ==========
- (void)runIOSAntiFrida:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject;

- (void)runIOSSecurityChecks:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject;

- (void)detectFridaLibraries:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject;

- (void)detectFridaEnv:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject;

- (void)detectFridaFiles:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject;

- (void)detectFridaSymbols:(RCTPromiseResolveBlock)resolve
                    reject:(RCTPromiseRejectBlock)reject;

- (void)detectCodeInjection:(RCTPromiseResolveBlock)resolve
                     reject:(RCTPromiseRejectBlock)reject;

// ========== Utility Functions ==========
- (void)xorDecode:(NSString *)encoded
            key:(char)key
         resolve:(RCTPromiseResolveBlock)resolve
          reject:(RCTPromiseRejectBlock)reject;

- (void)crc32:(NSArray *)data
       resolve:(RCTPromiseResolveBlock)resolve
        reject:(RCTPromiseRejectBlock)reject;

- (void)startSelfHeal:(RCTPromiseResolveBlock)resolve
               reject:(RCTPromiseRejectBlock)reject;

// ========== Unified Root/Jailbreak Detection ==========
- (void)isRooted:(RCTPromiseResolveBlock)resolve
           reject:(RCTPromiseRejectBlock)reject;

@end
