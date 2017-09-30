//
//  SuccessPayCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/4.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "SuccessPayCell.h"
#import "OrderCommentController.h"
#import "UIView+AutoSizeToDevice.h"

@implementation SuccessPayCell

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
    [self.stateButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)clickCommentButton:(UIButton *)button {
    
   
    
    if ([self.delegate respondsToSelector:@selector(pushController:animated:)]) {
        
        OrderCommentController *starCommentVC = [[OrderCommentController alloc] init];
        starCommentVC.hidesBottomBarWhenPushed = YES;
        
        starCommentVC.orderid = self.orderid;
        starCommentVC.SerMerCode = self.SerMerCode;
        starCommentVC.SerCode = self.SerCode;
        
        [self.delegate pushController:starCommentVC animated:YES];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
