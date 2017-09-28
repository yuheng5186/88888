//
//  Record.h
//  CarWashing
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface adverListModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *ImgUrl,*Url;
@end
@interface Record : JSONModel

@property (nonatomic,copy) NSArray <adverListModel *>*adverList;
@property (nonatomic,copy) NSArray <Record *>*recList;

@end
@interface Recordinfo : JSONModel
@property (nonatomic,copy) NSString *Account_Id;
@property (nonatomic,copy) NSString *Area;
@property (nonatomic,copy) NSString *UniqueNumber; //(订单号或是卡片编码)1时对应卡片编号2时对应订单号
@property (nonatomic,copy) NSString *RightDes;//右边描述
@property (nonatomic,copy) NSString *MiddleDes;//当返回类型ShowType为2时返回卡次数或是金额
@property (nonatomic,copy) NSString *BottomDes;//下边描述
@property (nonatomic,copy) NSString *CreateDate;//创建时间
@property (nonatomic,copy) NSString *ConsumerDescrip;//消费描述
@property(nonatomic)NSInteger ShowType; //类型(1.优惠活动;2.消费记录)

@property(nonatomic)NSInteger ConsumptionType; //1.线下门店支付;2.自动扫码洗车;3.自动扫码洗车支付;4.购买洗车卡(当返回类型为2时用到)
@property(nonatomic)NSInteger IntegralNumber;
@property(nonatomic)NSInteger PayMathod; //1.微信支付;2支付宝支付;3.洗车卡抵扣
@end
