//
//  WayToUpGradeCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/16.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "WayToUpGradeCell.h"
#import <Masonry.h>

@implementation WayToUpGradeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    
    UIImageView *iconV = [[UIImageView alloc] init];
    _iconV = iconV;
    [self.contentView addSubview:iconV];
    
    UILabel *waysLab = [[UILabel alloc] init];
    _waysLab = waysLab;
    waysLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    waysLab.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    [self.contentView addSubview:waysLab];
    
    UILabel *wayToLab = [[UILabel alloc] init];
    _wayToLab = wayToLab;
    wayToLab.textColor = [UIColor colorFromHex:@"#999999"];
    wayToLab.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
    [self.contentView addSubview:wayToLab];
    
    UILabel *valuesLab = [[UILabel alloc] init];
    _valuesLab = valuesLab;
    valuesLab.textColor = [UIColor colorFromHex:@"#ff525a"];
    valuesLab.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    [self.contentView addSubview:valuesLab];
    
    UIButton *goButton = [[UIButton alloc] init];
    _goButton = goButton;
    [goButton setTitle:@"去完成" forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goButton.titleLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
    goButton.backgroundColor = [UIColor colorFromHex:@"#0161a1"];
    goButton.layer.cornerRadius = 2*Main_Screen_Height/667;
    [self.contentView addSubview:goButton];
    
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(12*Main_Screen_Height/667);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(24*Main_Screen_Height/667);
    }];
    
    [waysLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(20*Main_Screen_Height/667);
        make.leading.equalTo(iconV.mas_trailing).mas_offset(23*Main_Screen_Height/667);
    }];
    
    [wayToLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(waysLab.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.leading.equalTo(waysLab);
    }];
    
    
    [valuesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-12*Main_Screen_Height/667);
        make.top.equalTo(self.contentView).mas_offset(20*Main_Screen_Height/667);
    }];
    
    [goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-12*Main_Screen_Height/667);
        make.top.equalTo(valuesLab.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.width.mas_equalTo(60*Main_Screen_Height/667);
        make.height.mas_equalTo(23*Main_Screen_Height/667);
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
