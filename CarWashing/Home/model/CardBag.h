//
//  CardBag.h
//  CarWashing
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardBag : JSONModel

@property(nonatomic,copy)NSString *Account_Id;
@property(nonatomic,copy)NSString *CardCode;
@property(nonatomic)NSInteger CardUseState;
@property(nonatomic,copy)NSString *Area;
@property(nonatomic)NSInteger CardCount;
@property(nonatomic)NSInteger UsedCount;
@property(nonatomic,copy)NSString *CardName;
@property(nonatomic,copy)NSDecimalNumber *CardPrice;
@property(nonatomic)NSInteger ConfigCode;
@property(nonatomic,copy)NSString *Description;
@property(nonatomic,copy)NSString *ExpStartDates;
@property(nonatomic,copy)NSString *ExpEndDates;
@property(nonatomic)NSInteger GetCardType;
@property(nonatomic)NSInteger Integralnum;
@property(nonatomic)NSInteger CardType;
@property(nonatomic)NSInteger UseLevel;
//卡包列表
@property(nonatomic,assign)NSInteger Type;
@property(nonatomic,assign)NSInteger Counts;
@end
