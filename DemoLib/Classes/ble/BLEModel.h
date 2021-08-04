//
//  BLEModel.h
//  AppProject
//
//  Created by 朱信磊 on 2018/1/15.
//  Copyright © 2018年 com.bandou.app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEModel : NSObject<NSCoding>
//@property (strong,nonatomic)CBPeripheral* peripheral;   //外设

@property (strong,nonatomic)NSString *uuid;     //外设UUID
@property (strong,nonatomic)NSString *name;     //外设名称
@property (strong,nonatomic)NSString *state;    //外设连接状态(断开，正在连接，已经连接)
@property (assign,nonatomic)BOOL      isConnect; //是否已连接
@property (strong,nonatomic)NSString *isAvailable; //是否可用
//rssi
@property (strong,nonatomic)NSNumber *RSSI;         //信号强度

+(NSArray*)getBundle;

@end
