//
//  DiscountDetailView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DiscountDetailView.h"

@implementation DiscountDetailView


+ (instancetype)discountDetailView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"DiscountDetailView" owner:nil options:nil].lastObject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
