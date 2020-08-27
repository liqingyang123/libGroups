#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BDConst.h"
#import "NSTimer+BDTimer.h"
#import "BDBLECenterServiceManager.h"
#import "BLEModel.h"
#import "BLENotificationKeys.h"
#import "NSData+ConvertData.h"

FOUNDATION_EXPORT double DemoLibVersionNumber;
FOUNDATION_EXPORT const unsigned char DemoLibVersionString[];

