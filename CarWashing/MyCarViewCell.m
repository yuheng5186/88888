//
//  MyCarViewCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/31.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MyCarViewCell.h"
#import "UIView+AutoSizeToDevice.h"

@implementation MyCarViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dg_viewAutoSizeToDevice = YES;
    
//    self.defaultButton.backgroundColor = [UIColor whiteColor];
    self.brandLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    
    self.defaulLabel.backgroundColor = [UIColor colorFromHex:@"#febb02"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
