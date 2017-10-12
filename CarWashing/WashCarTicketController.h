//
//  WashCarTicketController.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"
#import "Card.h"

@interface WashCarTicketController : BaseController

@property(nonatomic,strong)Card *card;

@property(nonatomic,copy)NSString *CurrentScore;



@end
