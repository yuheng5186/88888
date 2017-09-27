//
//  GoodsExchangeCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "GoodsExchangeCell.h"
#import <Masonry.h>

@implementation GoodsExchangeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    
    UIImageView *backImgV = [[UIImageView alloc] init];
    _backImgV = backImgV;
    backImgV.image = [UIImage imageNamed:@"qw_tiyanka"];
    [self.contentView addSubview:backImgV];
    
    UILabel *nameLab = [[UILabel alloc] init];
    _nameLab = nameLab;
    //nameLab.textColor = [UIColor colorFromHex:@"#ffffff"];
    nameLab.text = @"体验卡";
    nameLab.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    [backImgV addSubview:nameLab];
    
    nameLab.hidden = YES;
    
    UILabel *brandLab = [[UILabel alloc] init];
    brandLab.text = @"蔷薇爱车";
    brandLab.font = [UIFont systemFontOfSize:11];
    [backImgV addSubview:brandLab];
    
    UILabel *introLab = [[UILabel alloc] init];
    _introLab = introLab;
    //introLab.textColor = [UIColor colorFromHex:@"#ffffff"];
    introLab.text = @"免费扫码洗车次";
    introLab.textColor = [UIColor colorFromHex:@"#ffffff"];
    introLab.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    [backImgV addSubview:introLab];
    
    UILabel *scoreLab = [[UILabel alloc] init];
    _scoreLab = scoreLab;
    scoreLab.text = @"1000积分";
    scoreLab.textColor = [UIColor colorFromHex:@"#ffffff"];
    scoreLab.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    [backImgV addSubview:scoreLab];
    
    [backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(22.5*Main_Screen_Height/667);
        make.right.equalTo(self.contentView).mas_offset(-22.5*Main_Screen_Height/667);
    }];
//    
//    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backImgV).mas_offset(22*Main_Screen_Height/667);
//        make.top.equalTo(backImgV).mas_offset(21*Main_Screen_Height/667);
//    }];
    
//    [brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(nameLab);
//        make.leading.equalTo(nameLab.mas_trailing).mas_offset(5*Main_Screen_Height/667);
//    }];
    
//    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(nameLab);
//        make.top.equalTo(nameLab.mas_bottom).mas_offset(10*Main_Screen_Height/667);
//    }];
//    
//    [scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backImgV).mas_offset(22*Main_Screen_Height/667);
//        make.bottom.equalTo(backImgV).mas_offset(-18*Main_Screen_Height/667);
//    }];
    
    
    [scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImgV.mas_right).mas_offset(-12*Main_Screen_Height/667);
        make.bottom.equalTo(backImgV).mas_offset(-20*Main_Screen_Height/667);
    }];

    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(scoreLab.mas_top).mas_offset(-1*Main_Screen_Height/667);
        make.right.equalTo(backImgV.mas_right).mas_offset(-12*Main_Screen_Height/667);
    }];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
