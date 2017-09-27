//
//  MemberView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/27.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MemberView.h"
#import "UIView+AutoSizeToDevice.h"

@implementation MemberView


+ (instancetype)memberView {
    return [[NSBundle mainBundle] loadNibNamed:@"MemberView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.dg_viewAutoSizeToDevice = YES;
    
    self.UserImgView.layer.masksToBounds = YES;
    self.UserImgView.layer.cornerRadius = 26*Main_Screen_Height/667;
    
    self.topContainView.backgroundColor = [UIColor colorFromHex:@"#0161a1"];
    
    self.bottomContainView.backgroundColor = [UIColor colorFromHex:@"#084E7E"];
    
    //self.increaseButton.backgroundColor = [UIColor colorFromHex:@"ff9041"];
    self.increaseButton.layer.cornerRadius = 10*Main_Screen_Height/667;
    self.increaseButton.layer.borderWidth = 1;
    self.increaseButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //self.ernScoreButton.backgroundColor = [UIColor colorFromHex:@"ff9041"];
    self.ernScoreButton.layer.cornerRadius = 10*Main_Screen_Height/667;
    self.ernScoreButton.layer.borderWidth = 1;
    self.ernScoreButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (Main_Screen_Height == 736) {
        self.signLabel.centerY                   = self.UserImgView.centerY +Main_Screen_Height*25/667;
        self.signLabel.centerX                   = self.UserImgView.centerX +Main_Screen_Width*25/667;
    }
    
    NSString *phoneNum = @"11111111111";
    NSString *phoneText = [phoneNum stringByReplacingOccurrencesOfString:[phoneNum substringWithRange:NSMakeRange(3, 4)] withString:@"****"];
    self.phoneLabel.text = phoneText;
    
}





@end
