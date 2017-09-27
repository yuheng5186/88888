//
//  Card.h
//  CarWashing
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : JSONModel

@property (nonatomic)NSInteger UseLevel;
@property (nonatomic ,copy)NSString *Description;
@property (nonatomic ,copy)NSString *Img;
@property (nonatomic ,copy)NSString *ExpiredTimes;
@property (nonatomic ,copy)id <Optional> CardPrice;
@property (nonatomic ,copy)id <Optional> DiscountPrice;
@property (nonatomic ,copy)id <Optional> PaymentPrice;
@property (nonatomic ,copy)NSString *Account_Id;
@property (nonatomic)NSInteger Integralnum;
@property (nonatomic)NSInteger CardType;
@property (nonatomic)NSInteger IsReceive;
@property (nonatomic)NSInteger GetCardType;
@property (nonatomic)NSInteger CardCount;
@property (nonatomic)NSInteger CardQuantity;
@property (nonatomic ,copy)NSString *Area;
@property (nonatomic ,copy)NSString *CardName;
@property (nonatomic ,copy)NSString *CreateTime;
@property (nonatomic ,copy)NSString *CurrentOrNextLevel;
@property (nonatomic)NSInteger ConfigCode;
@property (nonatomic)NSInteger ExpiredDay;

@end
