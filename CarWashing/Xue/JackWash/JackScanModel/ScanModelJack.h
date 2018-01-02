//
//  ScanModelJack.h
//  CarWashing
//
//  Created by Wuxinglin on 2018/1/2.
//  Copyright © 2018年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanModelJack : NSObject
@property(copy,nonatomic)NSString *DeviceCode;              //设备编号
@property(copy,nonatomic)NSString *DeviceName;              //设备名称
@property(copy,nonatomic)NSString *ServiceItems;            //服务项目
@property(copy,nonatomic)NSString *CardName;                //卡片名
@property(assign)double OriginalAmt;                        //原价
@property(assign)double Amt;                                //实际支付金额
@property(assign)double DiscountPrice;                      //优惠力度价格
@property(assign)NSInteger RemainCount;                     //剩余次数
@property(assign)NSInteger CardType;                        //卡片类型
@property(assign)NSInteger IntegralNum;                     //获得积分数
@property(assign)NSInteger ScanCodeState;                   //是否需要支付
@end
