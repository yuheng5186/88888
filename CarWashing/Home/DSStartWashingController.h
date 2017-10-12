//
//  DSStartWashingController.h
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/8/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"

@interface DSStartWashingController : BaseController


@property(nonatomic,copy)NSString *RemainCount;//剩余次数
@property(nonatomic,copy)NSString *CardType;//卡片类型
@property(nonatomic,copy)NSString *CardName;//卡片名称
@property(nonatomic,copy)NSString *IntegralNum;//积分数
@property(nonatomic,copy)NSString *paynum;//积分数
@property (nonatomic,assign) int second;


@end
