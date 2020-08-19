//
//  BDConst.h
//  ePayProject
//
//  Created by 朱信磊 on 2017/11/28.
//  Copyright © 2017年 com.bandou.app.epay. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - 短信验证码类型
typedef NSString MsgType;
extern MsgType  *const  MsgTypeLogin;
extern MsgType  *const  MsgTypeRegister;
extern MsgType  *const  MsgTypePay;
extern MsgType  *const  MsgTypeTrans;
extern MsgType  *const  MsgTypeChangeMobile;

#pragma mark - 记录类型
typedef NSString RecordType;
extern  RecordType  *const  RecordTypeCook;         //做饭记录
extern  RecordType  *const  RecordTypeCheck;        //检测记录
extern  RecordType  *const  RecordTypeClear;        //净化记录
extern  RecordType  *const  RecordTypeChangeAir;    //换气记录
extern  RecordType  *const  RecordTypeWashing;      //清洗记录
extern  RecordType  *const  RecordTypeDisinfect;    //消毒记录
extern  RecordType  *const  RecordTypeAll;          //所有记录


#pragma mark - 开关状态
typedef NSString OpenStatus;
extern  OpenStatus  *const  OpenStatusOpen;         //开
extern  OpenStatus  *const  OpenStatusClose;        //关


#pragma mark - 设备系统状态
typedef NSInteger DeviceSystemStatus;
extern  DeviceSystemStatus  const  DeviceSystemStatusNormal;  //正常
extern  DeviceSystemStatus  const  DeviceSystemStatusError;  //故障


#pragma mark - 报修类型
typedef NSInteger  RepairType;
extern  RepairType      const  RepairTypeYYJ;      //油烟机问题
extern  RepairType      const  RepairTypeRQZ;      //燃气灶问题
extern  RepairType      const  RepairTypeXDG;      //消毒柜问题
extern  RepairType      const  RepairTypeOther;    //其它问题

#pragma mark - 报修处理结果
typedef NSInteger RepairStatus;
extern  RepairStatus   const   RepairStatusNoDeal; //未处理
extern  RepairStatus   const   RepairStatusDealing;//处理中
extern  RepairStatus   const  RepairStatusOver;   //已处理


#pragma mark - cell 身份ID
typedef NSString CellType;
extern CellType  *const  Identity1;
extern CellType  *const  Identity2;
extern CellType  *const  Identity3;
extern CellType  *const  Identity4;
extern CellType  *const  Identity5;



