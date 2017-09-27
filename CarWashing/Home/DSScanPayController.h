//
//  DSScanPayController.h
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/9/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"

@interface DSScanPayController : BaseController

@property(nonatomic ,copy)NSString *SerMerChant;
@property(nonatomic ,copy)NSString *SerProject;

@property(nonatomic ,copy)NSString *Jprice;
@property(nonatomic ,copy)NSString *Xprice;

@property(nonatomic ,copy)NSString *DeviceCode;

@property(nonatomic,copy)NSString *RemainCount;
@property(nonatomic,copy)NSString *CardType;
@property(nonatomic,copy)NSString *CardName;
@property(nonatomic,copy)NSString *IntegralNum;

@end
