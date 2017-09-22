//
//  CarTicketView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CarTicketView.h"
#import "UIView+AutoSizeToDevice.h"
#import <Masonry.h>


@implementation CarTicketView

+ (instancetype)carTicketView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"CarTicketView" owner:nil options:nil].lastObject;
}



- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.dg_viewAutoSizeToDevice = YES;
    self.ScoreLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
    self.CardName.textColor = [UIColor colorFromHex:@"#ffffff"];
    self.ScoreLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    self.CardName.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    
    [self.ScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.BackImgV.mas_right).mas_offset(-12*Main_Screen_Height/667);
        make.bottom.equalTo(self.BackImgV).mas_offset(-20*Main_Screen_Height/667);
    }];
    
    [self.CardName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ScoreLabel.mas_top).mas_offset(-1*Main_Screen_Height/667);
        make.right.equalTo(self.BackImgV.mas_right).mas_offset(-12*Main_Screen_Height/667);
    }];
    
    
}

@end
