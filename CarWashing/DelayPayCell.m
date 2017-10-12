//
//  DelayPayCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/4.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DelayPayCell.h"
#import "BusinessPayController.h"
#import "UIView+AutoSizeToDevice.h"

@implementation DelayPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dg_viewAutoSizeToDevice = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.orderLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    
    self.washTypeLabel.textColor = [UIColor colorFromHex:@"#3a3a3a"];
    
    self.timesLabel.textColor = [UIColor colorFromHex:@"#999999"];
    
    self.stateLabel.textColor = [UIColor colorFromHex:@"#febb02"];
    
    self.priceLabel.textColor = [UIColor colorFromHex:@"#ff525a"];
    
    
    [self.stateButton setTitleColor:[UIColor colorFromHex:@"#febb02"] forState:UIControlStateNormal];
    self.stateButton.layer.cornerRadius = 12.5*Main_Screen_Height/667;
    self.stateButton.layer.borderWidth = 1;
    self.stateButton.layer.borderColor = [UIColor colorFromHex:@"#febb02"].CGColor;
}


- (IBAction)skipToPay:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(pushVC:animated:)]) {
        
        BusinessPayController *payVC = [[BusinessPayController alloc] init];
        payVC.hidesBottomBarWhenPushed = YES;
        
        payVC.SerMerChant = self.SerMerChant;
        payVC.SerProject = self.washTypeLabel.text;
        payVC.Jprice = self.Jprice;
        payVC.Xprice = self.Xprice;
        payVC.MCode = self.MCode;
        payVC.SCode = self.SCode;
        
        payVC.OrderCode = self.OrderCode;
        
        [self.delegate pushVC:payVC animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
