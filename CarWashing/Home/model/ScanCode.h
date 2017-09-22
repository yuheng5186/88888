//
//  ScanCode.h
//  CarWashing
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ScanCode : JSONModel

@property (nonatomic,copy) NSString *Account_Id;
@property (nonatomic,copy) NSString *DeviceCode;
@property (nonatomic,copy) NSString *DeviceName;
@property (nonatomic,copy) NSString *ServiceItems;
@property (nonatomic,copy) id <Optional> OriginalAmt;//原价
@property (nonatomic,copy) id <Optional> Amt;//支付金额
@property (nonatomic,copy) id <Optional> DiscountPrice;//优惠金额
@property (nonatomic) NSInteger ScanCodeState;//(1.需要支付状态,2.扫描成功)
@property (nonatomic) NSInteger RemainCount;
@property (nonatomic) NSInteger CardType;
@property (nonatomic) NSInteger IntegralNum;
@property (nonatomic,copy) NSString *CardName;

@end
