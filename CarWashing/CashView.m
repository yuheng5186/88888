//
//  CashView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CashView.h"

@implementation CashView


+ (instancetype)cashView{
    return [[NSBundle mainBundle] loadNibNamed:@"CashView" owner:nil options:nil].firstObject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
