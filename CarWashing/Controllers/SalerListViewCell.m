//
//  SalerListViewCell.m
//  商家
//
//  Created by 时建鹏 on 2017/7/18.
//  Copyright © 2017年 mm. All rights reserved.
//

#import "SalerListViewCell.h"

@interface SalerListViewCell ()



@end

@implementation SalerListViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}


- (void)setupUI {
    
    self.shopAdressLabel.textColor = [UIColor colorFromHex:@"#999999"];
    self.separateLine.backgroundColor = [UIColor colorFromHex:@"#e6e6e6"];
    
    self.freeTestLabel.layer.cornerRadius = 7.5*Main_Screen_Height/667;
    self.freeTestLabel.clipsToBounds = YES;
    self.freeTestLabel.backgroundColor = [UIColor colorFromHex:@"#517ab6"];
    self.qualityLabel.layer.cornerRadius = 7.5*Main_Screen_Height/667;
    self.qualityLabel.clipsToBounds = YES;
    self.qualityLabel.backgroundColor = [UIColor colorFromHex:@"#f85460"];
    
    self.typeShopLabel.textColor = [UIColor colorFromHex:@"#868686"];
    self.distanceLabel.textColor = [UIColor colorFromHex:@"#868686"];
    self.ScoreLabel.textColor = [UIColor colorFromHex:@"#868686"];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
