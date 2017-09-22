

//
//  BusinessDetailCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BusinessDetailCell.h"

@interface BusinessDetailCell ()


@end

@implementation BusinessDetailCell


+ (instancetype)businessDetailCell {
  
    return [[NSBundle mainBundle] loadNibNamed:@"BusinessDetailCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor whiteColor];
    self.stateButton.userInteractionEnabled = NO;
    
    self.clearLabel.textColor = [UIColor colorFromHex:@"#999999"];
    
    self.priceLabel.textColor = [UIColor colorFromHex:@"#ff525a"];
    
    self.originPriceLabel.textColor = [UIColor colorFromHex:@"#868686"];
    
    
//    [self.stateButton setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
//    [self.stateButton setImage:[UIImage imageNamed:@"xaunzhong"] forState:UIControlStateSelected];
    
}


- (IBAction)didClickStateButton:(UIButton *)sender {
    
    if (sender.selected) {
        
        [sender setImage:[UIImage imageNamed:@"xaunzhong"] forState:UIControlStateSelected];
    }
    
    sender.selected = !sender.selected;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
