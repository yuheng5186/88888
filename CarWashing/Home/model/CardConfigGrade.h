//
//  CardConfigGrade.h
//  CarWashing
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardConfigGrade : JSONModel

@property(nonatomic,copy)NSString *Account_Id;
@property(nonatomic,copy)NSString *Area;
@property(nonatomic)NSInteger CardCount;
@property(nonatomic,copy)NSString *CardName;
@property(nonatomic)NSInteger CardQuantity;
@property (nonatomic ,copy)id <Optional> CardPrice;
@property (nonatomic ,copy)id <Optional> DiscountPrice;
@property (nonatomic ,copy)id <Optional> PaymentPrice;
@property(nonatomic)NSInteger CardType;
@property(nonatomic)NSInteger ConfigCode;
@property(nonatomic,copy)NSString *CreateTime;
@property(nonatomic)NSInteger CurrentOrNextLevel;
@property(nonatomic,copy)NSString *Description;
@property(nonatomic)NSInteger ExpiredDay;
@property(nonatomic,copy)NSString *ExpiredTimes;
@property(nonatomic)NSInteger GetCardType;
@property(nonatomic,copy)NSString *Img;
@property(nonatomic)NSInteger Integralnum;
@property(nonatomic)NSInteger IsReceive;
@property(nonatomic)NSInteger UseLevel;

@end
