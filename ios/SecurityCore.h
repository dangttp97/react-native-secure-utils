
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNSecurityCoreSpec.h"

@interface SecurityCore : NSObject <NativeSecurityCoreSpec>
#else
#import <React/RCTBridgeModule.h>

@interface SecurityCore : NSObject <RCTBridgeModule>
#endif

@end
