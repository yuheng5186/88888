//
//  OrderDetailView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "OrderDetailView.h"

@implementation OrderDetailView

- (IBAction)GotoMerChant:(id)sender {
}

+ (instancetype)orderDetailView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"OrderDetailView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (void)setupUI {
    
}

@end
