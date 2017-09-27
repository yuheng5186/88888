//
//  CancelPayCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/4.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CancelPayCell.h"
#import "UIView+AutoSizeToDevice.h"

@implementation CancelPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dg_viewAutoSizeToDevice = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.orderLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    
    self.washTypeLabel.textColor = [UIColor colorFromHex:@"#3a3a3a"];
    
    self.timesLabel.textColor = [UIColor colorFromHex:@"#999999"];
    
    self.stateLabel.textColor = [UIColor colorFromHex:@"#868686"];
    
    self.priceLabel.textColor = [UIColor colorFromHex:@"#868686"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
