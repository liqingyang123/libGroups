//
//  BLEModel.m
//  AppProject
//
//  Created by 朱信磊 on 2018/1/15.
//  Copyright © 2018年 com.bandou.app. All rights reserved.
//

#import "BLEModel.h"

@implementation BLEModel
/**
 *  将某个对象写入文件时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeBool:self.isConnect forKey:@"isConnect"];
    [encoder encodeObject:self.isAvailable forKey:@"isAvailable"];
    [encoder encodeObject:self.RSSI forKey:@"RSSI"];
}

/**
 *  从文件中解析对象时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        // 读取文件的内容
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.isConnect = [decoder decodeBoolForKey:@"isConnect"];
        self.isAvailable = [decoder decodeObjectForKey:@"isAvailable"];
        self.RSSI = [decoder decodeObjectForKey:@"RSSI"];
    }
    return self;
}
@end
