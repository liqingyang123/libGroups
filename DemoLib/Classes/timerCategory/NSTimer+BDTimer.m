//
//  NSTimer+BDTimer.m
//  ZXL
//
//  Created by 朱信磊 on 2017/5/9.
//  Copyright © 2017年 朱信磊. All rights reserved.
//

#import "NSTimer+BDTimer.h"


@implementation NSTimer (BDTimer)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval) seconds repeats:(BOOL)repeats CallBackTimer:(CallBackTimer)block{
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(cusAction:) userInfo:block repeats:repeats];
    return time;
}


+(void)cusAction:(NSTimer *)timer{
    CallBackTimer block = timer.userInfo;
    block(timer);
}
@end
