//
//  BusinessPayCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/10.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BusinessPayCell.h"
#import <Masonry.h>

@implementation BusinessPayCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    
    UIButton *payWayBtn = [[UIButton alloc] init];
    payWayBtn.userInteractionEnabled = NO;
//    [payWayBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    _payWayBtn = payWayBtn;
//    [payWayBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
//    [payWayBtn setImage:[UIImage imageNamed:@"xaunzhong"] forState:UIControlStateSelected];
    [self.contentView addSubview:payWayBtn];
    
    [payWayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-12*Main_Screen_Height/667);
        make.width.mas_equalTo(21*Main_Screen_Height/667);
        make.height.mas_equalTo(21*Main_Screen_Height/667);
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
