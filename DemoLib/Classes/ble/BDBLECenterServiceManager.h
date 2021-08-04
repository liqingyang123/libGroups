//
//  BDBluetoothManager.h
//  AppProject
//
//  Created by 朱信磊 on 2018/1/15.
//  Copyright © 2018年 com.bandou.app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEModel.h"
typedef NS_ENUM(NSUInteger, BleConnectStatus) {
    BleConnectStatus_NOConnect,   //未连接
    BleConnectStatus_Connect,     //已连接
};


@protocol BDBLEDataProcessDelegate <NSObject>
// 不想进一步封装也是可以的，BDBLECenterServiceManager提供的方法也是可以直接完成 发送和接收处理数据的
// 这里将发送数据和接收数据又封装成了一个 BDBluetoothDataProcess 类，方便统一管理
// 发送数据是主动的，直接调用外设发送方法即可；接收数据是被动的，是在外设获取数据的代理方法中实现的
// 所以 BDBluetoothDataProcess 类中，发送数据好办；接收数据则需要成为 BDBLECenterServiceManager 的代理
- (void)readDataProcess:(CBCharacteristic *)characteristic;
@end


typedef void (^blackscanPeriperalInfos)(NSMutableArray *pinfos);                        //扫描外设的回调
typedef void (^blacksdisPeriperalInfos)(int status);                                    //断开外设的回调
typedef void (^blacksValueForCharacteristic)(CBCharacteristic *characteristic);         


@interface BDBLECenterServiceManager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>    //中心管理协议、外设协议

@property (nonatomic, assign, readonly, getter=isOff)BOOL State;        //中心设备蓝牙打开状态

@property (nonatomic, assign) BOOL isReconnection;    //是否重连

@property (nonatomic, weak) id<BDBLEDataProcessDelegate>Delegate;

//单例
+ (BDBLECenterServiceManager *)sharedBLECenterServer;

//连接状态
@property(nonatomic,assign) BleConnectStatus  mystatus;

//停止扫描
- (void)stop;

//中心设备扫描外设的方法
-(void)scanDevices:(blackscanPeriperalInfos)blackPeriperalInfos;

//从中心设备连接外设的方法
-(void)connectPeripheral:(BLEModel*)periperalInfo;

//中心设备断开外设的方法
-(void)DisconnectPeripheral:(blacksdisPeriperalInfos)blacksdisP;

//写数据
-(void)writeData:(blacksValueForCharacteristic)characteristic withByte:(NSData *)adata;

@end
