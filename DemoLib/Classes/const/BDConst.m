//
//  BDConst.m
//  ePayProject
//
//  Created by 朱信磊 on 2017/11/28.
//  Copyright © 2017年 com.bandou.app.epay. All rights reserved.
//

#import "BDConst.h"
MsgType  *const  MsgTypeLogin    = @"login";                        //登录密码重置
MsgType  *const  MsgTypeRegister  = @"register";                    //注册验证
MsgType  *const  MsgTypePay = @"pay";                               //支付密码重置
MsgType  *const  MsgTypeTrans = @"trans";                           //支付验证
MsgType  *const  MsgTypeChangeMobile = @"changeMobile";             //更改绑定手机号

RecordType  *const  RecordTypeCook = @"0";         //做饭记录
RecordType  *const  RecordTypeCheck = @"1";        //检测记录
RecordType  *const  RecordTypeClear = @"2";        //净化记录
RecordType  *const  RecordTypeChangeAir = @"3";    //换气记录
RecordType  *const  RecordTypeWashing = @"4";      //清洗记录
RecordType  *const  RecordTypeDisinfect = @"5";    //消毒记录
RecordType  *const  RecordTypeAll = @"6";          //所有记录



OpenStatus  *const  OpenStatusClose = @"0";        //关
OpenStatus  *const  OpenStatusOpen = @"1";         //开

DeviceSystemStatus  const  DeviceSystemStatusNormal = 0;  //正常
DeviceSystemStatus  const  DeviceSystemStatusError = 1;  //故障



RepairType      const  RepairTypeYYJ = 0;
RepairType      const  RepairTypeRQZ = 1;      //燃气灶问题
RepairType      const  RepairTypeXDG = 2;      //消毒柜问题
RepairType      const  RepairTypeOther = 3;    //其它问题



RepairStatus   const   RepairStatusNoDeal = 0; //未处理
RepairStatus   const   RepairStatusDealing = 1;//处理中
RepairStatus    const  RepairStatusOver = 2;


CellType  *const  Identity1 = @"Identity1";
CellType  *const  Identity2 = @"Identity2";
CellType  *const  Identity3 = @"Identity3";
CellType  *const  Identity4 = @"Identity4";
CellType  *const  Identity5 = @"Identity5";            
