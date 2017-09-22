//
//  RechargeCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "RechargeCell.h"
#import <Masonry.h>

@implementation RechargeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.CardnameLabel.textColor = [UIColor blackColor];
//    self.tagLabel.font = [UIFont systemFontOfSize:11*Main_Screen_Height/667];
//    self.CardnameLabel.font = [UIFont boldSystemFontOfSize:20*Main_Screen_Height/667];
//    self.CarddesLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
//    self.CardTimeLabel.font = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
//    self.CardTimeLabel.textColor = [UIColor colorFromHex:@"#999999"];
    
    
    self.CardTimeLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
    self.CardnameLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
    self.CardTimeLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    self.CardnameLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    
    [self.CardTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundImgV).mas_offset(-12*Main_Screen_Height/667);
        make.bottom.equalTo(self.backgroundImgV).mas_offset(-15*Main_Screen_Height/667);
    }];
    
    [self.CardnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.CardTimeLabel.mas_top).mas_offset(-5*Main_Screen_Height/667);
        make.right.equalTo(self.backgroundImgV).mas_offset(-12*Main_Screen_Height/667);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
