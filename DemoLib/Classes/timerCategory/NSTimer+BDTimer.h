//
//  NSTimer+BDTimer.h
//  ZXL
//
//  Created by 朱信磊 on 2017/5/9.
//  Copyright © 2017年 朱信磊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBackTimer)(NSTimer *timer);

@interface NSTimer (BDTimer)

/**
 带回调的NSTimer计时方法

 @param seconds 时间间隔
 @param repeats 是否重复
 @param block seconds秒后回调
 @return 返回一个NSTimer对象
 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval) seconds repeats:(BOOL)repeats CallBackTimer:(CallBackTimer)block;
@end
