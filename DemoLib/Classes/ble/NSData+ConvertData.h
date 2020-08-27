//
//  NSData+ConvertData.h
//  AppProject
//
//  Created by 朱信磊 on 2018/1/15.
//  Copyright © 2018年 com.bandou.app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ConvertData)
/**
 将nsdata 打印出 16进制
 
 @param data <#data description#>
 @return <#return value description#>
 */
+ (NSString *)convertDataToHexStr:(NSData *)data;
@end
