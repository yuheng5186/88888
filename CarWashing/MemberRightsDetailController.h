//
//  MemberRightsDetailController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/22.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"

@interface MemberRightsDetailController : BaseController

@property(nonatomic,copy)NSString *ConfigCode;
@property(nonatomic,copy)NSString *nextUseLevel;
@property(nonatomic,copy)NSString *currentUseLevel;


@property(nonatomic,copy)NSDictionary *nextdic;

@end
