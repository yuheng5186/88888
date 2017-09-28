//
//  OrderDetailController.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"

@interface OrderDetailController : BaseController

@property (nonatomic,assign) NSInteger MerCode;

@property (nonatomic,copy) NSString *MerChantService;

@property (copy, nonatomic)  NSString *ShijiPrice;
@property (copy, nonatomic)  NSString *Jprice;
@property (copy, nonatomic)  NSString *youhuiprice;
@property (copy, nonatomic)  NSString *shijiPrice1;
@property (copy, nonatomic)  NSString *orderid;
@property (copy, nonatomic)  NSString *ordertime;
@property (copy, nonatomic)  NSString *paymethod;

@end
