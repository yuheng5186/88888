//
//  Order.h
//  CarWashing
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Order : JSONModel

@property(nonatomic,copy)NSString *Account_Id;
@property(nonatomic)NSInteger PageIndex;
@property(nonatomic)NSInteger PageSize;
@property(nonatomic)NSInteger PayState;//(1. 未支付 ;2. 待评价 ;3. 评价完成)

@property(nonatomic,copy)NSString *OrderCode;//订单号
@property(nonatomic,copy)NSString *MerName;

@property(nonatomic)NSInteger MerCode; //商家编号
@property(nonatomic)NSInteger SerCode; //服务编号


@property(nonatomic,copy)NSString *SerName;//服务名称
@property(nonatomic,copy)NSString *OrderDesc;//订单描述

@property(nonatomic)NSInteger PayMethod;//1.微信支付;2支付宝支付

@property(nonatomic)id<Optional>PayableAmount;//应付金额
@property(nonatomic)id<Optional>DeductionAmount;//优惠金额
@property(nonatomic)id<Optional>PaypriceAmount;//实际金额

@property(nonatomic,copy)NSString *PayTimes;//订单描述

@end
