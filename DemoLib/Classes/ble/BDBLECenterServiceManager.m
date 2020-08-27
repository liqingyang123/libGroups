//
//  BDBluetoothManager.m
//  AppProject
//
//  Created by 朱信磊 on 2018/1/15.
//  Copyright © 2018年 com.bandou.app. All rights reserved.
//

#import "BDBLECenterServiceManager.h"
#import "BLENotificationKeys.h"
#import "NSData+ConvertData.h"
@interface BDBLECenterServiceManager(){
    blackscanPeriperalInfos     _blackPeriperalInfos;
    blacksdisPeriperalInfos     _blacksdisP;
    int BLERSSI;                    //信号
    int BLERSSILowNum;              //低信号计数器
}
@property (nonatomic, strong)CBCentralManager       *centralManager;        //中心管理
@property (nonatomic, strong)CBPeripheral           *discoveredPeripheral;  //当前连接的外设
@property (nonatomic, strong)NSMutableArray         *periperalInfos;        //存储外设及信息
@property (nonatomic, strong)NSMutableDictionary    *periperalDic;          //存储外设
@property (nonatomic, strong)CBCharacteristic       *selectCharacteristc;   //写的特征
@property (nonatomic, strong)CBCharacteristic       *readCharacteristc;     //读的特征

@end

@implementation BDBLECenterServiceManager

//单例
+ (BDBLECenterServiceManager *)sharedBLECenterServer{
    static BDBLECenterServiceManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager initBLE];
    });
    return manager;
}

-(void)initBLE
{
    self.periperalInfos = [NSMutableArray arrayWithCapacity:1];
    self.periperalDic = [NSMutableDictionary dictionaryWithCapacity:1];
    self.isReconnection = YES;
    BLERSSILowNum = 0;
}

//扫描设备（供外部调用）
-(void)scanDevices:(blackscanPeriperalInfos)blackPeriperalInfos
{   // 扫描到外设后的 回调block
    _blackPeriperalInfos = blackPeriperalInfos;
    [self.periperalInfos removeAllObjects];
    [self.periperalDic removeAllObjects];
    //如果中心管理对象为nil
    if (self.centralManager == nil) {
        //中心管理对象初始化后，会立即回调执行 监听蓝牙状态改变方法
        //如果蓝牙没打开，系统会自动提示是否打开蓝牙
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.centralManager.delegate = self;
    }else{
        //开始扫描
        [self scan];
    }
}

//扫描设备
- (void)scan
{
    //扫描之前先停止上一次的扫描行为；
    [self stop];
    NSLog(@"扫描");
    [self.periperalInfos removeAllObjects];
    [self.periperalDic removeAllObjects];
    
    //扫描服务
    [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    [self performSelector:@selector(scanTimeout) withObject:nil afterDelay:30.0f];
}

//扫描超时调用的方法
- (void) scanTimeout
{
    [self stop];
    _blackPeriperalInfos(self.periperalInfos);
}


//停止扫描
- (void)stop{
    [self.centralManager stopScan];
}


//从中心设备连接外设的方法
-(void)connectPeripheral:(BLEModel*)periperalInfo{
    CBPeripheral *peripheral = [self.periperalDic objectForKey:periperalInfo.uuid];
    if (peripheral == nil) {
        return;
    }
    [self stop];
    self.isReconnection = YES;
    //当前没有连接外设，直接连接外设
    if (self.discoveredPeripheral == nil || self.mystatus != BleConnectStatus_Connect) {
        [self.centralManager connectPeripheral:peripheral options:nil];
        self.discoveredPeripheral = peripheral;
    }else{
        //如果当前中心设备已连接外设，则断开已连接外设，连接当前指定的外设
        [self autoReconnectDisconnectPeripheral:^(int status) {
            if (status == 1) {
                self.discoveredPeripheral = peripheral;
                [self.centralManager connectPeripheral:self.discoveredPeripheral options:nil];
            }
        }];
    }
}
//中心设备断开当前外设，连接其他外设
-(void)autoReconnectDisconnectPeripheral:(blacksdisPeriperalInfos)blacksdisP
{
    // 断开外设回调 block，会在断开连接方法中执行
    _blacksdisP = blacksdisP;
    // 断开外设
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

//中心设备断开外设的方法
-(void)DisconnectPeripheral:(blacksdisPeriperalInfos)blacksdisP
{
    self.isReconnection = NO;
    _blacksdisP = blacksdisP;
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}


#pragma mark - CBCenterManagerDelegate
//中心设备 蓝牙状态改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        _State = YES;
        //断开连接
        [[NSNotificationCenter defaultCenter] postNotificationName:VDBlueToothDisconnectNotification object:nil];
        self.mystatus = BleConnectStatus_NOConnect;
        return;
    }
    _State = NO;
    //开始扫描
    [self scan];
}

#pragma mark 在扫描的时候发现外设时调用此方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    //根据扫描到的外设 uuid ，获取外设字典中的外设
    CBPeripheral *dicPeripheral = [self.periperalDic objectForKey:[peripheral.identifier UUIDString]];
    //过滤掉已经添加的外设，根据外设name过滤掉不符合外设
    if (dicPeripheral || !peripheral.name || [peripheral.name isEqualToString:@""]) {
        return;
    }
   
    BLEModel *bleModel = [[BLEModel alloc] init];
    bleModel.uuid = [peripheral.identifier UUIDString];
    //保存在本地的所有设备昵称
    NSDictionary *nameDic = [[NSUserDefaults standardUserDefaults] objectForKey:kNickNameDic];
    NSString *peripheralNameStr = [nameDic objectForKey:bleModel.uuid];
    if (peripheralNameStr.length <= 0 || !peripheralNameStr) {
        peripheralNameStr = peripheral.name;
    }
    bleModel.name = peripheralNameStr;
    //外设状态
    switch (peripheral.state) {
        case CBPeripheralStateDisconnected:
            bleModel.state = @"断开";    //断开
            break;
        case CBPeripheralStateConnecting:
            bleModel.state = @"正在连接";   //正在连接
            break;
        case CBPeripheralStateConnected:
            bleModel.state = @"已经连接";    //已经连接
            break;
        default:
            break;
    }
    
    if (RSSI) {
        bleModel.RSSI = RSSI;
    }
    NSString *discoveredUUID;
    if (self.discoveredPeripheral) {  //如果当前连接的外设不为nil，则获取uuid
        discoveredUUID = [self.discoveredPeripheral.identifier UUIDString];
    }
    // 扫描到了当前连接的设备或之前连接的设备，则重新连接一下（因为断开连接，self.isReconnection不会清空）
    if (self.isReconnection && [discoveredUUID isEqualToString:[peripheral.identifier UUIDString]]) {
        if ([self respondsToSelector:@selector(reconnection)]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reconnection) object:nil];
            [self performSelector:@selector(reconnection) withObject:nil afterDelay:1.0f];
        }
    }
    //保存外设
    [self.periperalDic setObject:peripheral forKey:[peripheral.identifier UUIDString]];
    //保存外设信息
    [self.periperalInfos addObject:bleModel];
    _blackPeriperalInfos(self.periperalInfos);
    
    //取消超时定时器
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scanTimeout) object:nil];
}

#pragma mark 设备中心连接外设成功时调用此方法
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    //已连接外设，所以在这里可以停止扫描了
    [self stop];
    self.discoveredPeripheral = peripheral;
    peripheral.delegate = self;
    //扫描外设服务
    [peripheral discoverServices:nil];
}

#pragma mark 连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //连接失败走这个方法
    [self cleanup];
}
#pragma mark 外设断开连接
//设备断开后会调用此方法
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    self.mystatus = BleConnectStatus_NOConnect;
    //发送断开连接通知
    [[NSNotificationCenter defaultCenter] postNotificationName:VDBlueToothDisconnectNotification object:nil];
    //断开后回调
    if (_blacksdisP) {
        _blacksdisP(1);
    }
}
#pragma mark - CBPeripheral Delegate  外设协议
#pragma mark 发现外设可用的服务时调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        [self cleanup];
        return;
    }
    //获取每个服务的特征值
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

#pragma mark 获取外设每个服务的特征值时调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        [self cleanup];
        return;
    }
    //指定uuid接受特征值
    for (CBCharacteristic *characteristic in service.characteristics) {
        //FF01 写特征值 （硬件定义好的）
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]]) {
            self.selectCharacteristc=characteristic;
            self.mystatus = BleConnectStatus_Connect;
        } //FF02(硬件定义好的）
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]])
        {
            //接收 特征值 通知
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.readCharacteristc=characteristic;
            self.mystatus = BleConnectStatus_Connect;
            //连接外设成功，发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:VDBlueToothConnectNotification object:peripheral];
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    BLERSSI = [RSSI intValue];
}

//外设向app发送特征值时调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        return;
    }
//    if (characteristic == self.readCharacteristc) {
        [self blueToothAction:characteristic];
//    }
    /*
    每个页面注册观察者，就可以读取外设返回数据了
    NSData *value = characteristic.value;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:value,@"value", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readResponseData" object:nil userInfo:dic];
    */
}
//处理接受到的特征值
-(void)blueToothAction:(CBCharacteristic *)characteristic
{
    if (self.Delegate && [self.Delegate respondsToSelector:@selector(readDataProcess:)]) {
        [self.Delegate readDataProcess:characteristic];
    }
}

//写数据
-(void)writeData:(blacksValueForCharacteristic)characteristic withByte:(NSData *)adata{
    BDLog(@"发送值=%@",[NSData convertDataToHexStr:adata]);
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected || self.mystatus != BleConnectStatus_Connect)
    { return; }
    if ([self.discoveredPeripheral respondsToSelector:@selector(readRSSI)]) {
        [self.discoveredPeripheral performSelector:@selector(readRSSI) withObject:nil afterDelay:2.0f];
    }
    //信号低，就返回
    if (BLERSSI < -88.0f) {
        BLERSSILowNum++;
        if (BLERSSILowNum % 3 == 0) {
            //信号太低，发送通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:VdBlueToothRSSILowNotification object:nil];
            BLERSSILowNum = 0;
            return;
        }
        
        if ([self respondsToSelector:@selector(clearedBleRssiLow)]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearedBleRssiLow) object:nil];
            [self performSelector:@selector(clearedBleRssiLow) withObject:nil afterDelay:30.0f];
        }
    }
    [self.discoveredPeripheral writeValue:adata forCharacteristic:self.selectCharacteristc type:CBCharacteristicWriteWithResponse];
}

- (void)clearedBleRssiLow{
    BLERSSILowNum = 0;
}
//当外设接到特征值时调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        return;
    }
}

- (void)reconnection{
    if (self.discoveredPeripheral) {
        [self.centralManager connectPeripheral:self.discoveredPeripheral options:nil];
    }
}

- (void)cleanup
{
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected){
        return;
    }
    //判断是否已经订阅特征
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics){
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@""]]) {    //指定订阅特征值的uuid，没有订阅这段可注视掉
                        if (characteristic.isNotifying) {
                            //停止接收特征通知
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            //断开与外设连接
                            [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
                            return;
                        }
                    }
                }
            }
        }
    }
    //断开与外设连接
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}
@end
