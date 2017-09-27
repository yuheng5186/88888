//
//  TicketCashView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/31.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "TicketCashView.h"

@implementation TicketCashView


+ (instancetype)ticketCashView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"TicketCashView" owner:nil options:nil].lastObject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
