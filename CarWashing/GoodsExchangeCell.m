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
    
    NSString *titleName              = @"体验卡";
    UIFont *titleNameFont            = [UIFont boldSystemFontOfSize:18];
    UILabel *titleNameLabel          = [UIUtil drawLabelInView:backImgV frame:[UIUtil textRect:titleName font:titleNameFont] font:titleNameFont text:titleName isCenter:NO];
    titleNameLabel.textColor         = [UIColor blackColor];
    _nameLab = titleNameLabel;

    titleNameLabel.top               = Main_Screen_Height*20/667;
    titleNameLabel.left              = Main_Screen_Width*25/375;
    
    NSString *jindingString        = @"金顶洗车";
    UIFont *jindingFont            = [UIFont systemFontOfSize:10];
    UILabel *jindingLabel          = [UIUtil drawLabelInView:backImgV frame:[UIUtil textRect:jindingString font:jindingFont] font:jindingFont text:jindingString isCenter:NO];
    jindingLabel.textColor         = [UIColor blackColor];
    jindingLabel.bottom            = titleNameLabel.bottom;;
    jindingLabel.left              = titleNameLabel.right+Main_Screen_Width*5/375;
    
    
    NSString *priceString        = @"扫码洗车自动抵扣";
    UIFont *priceFont            = [UIFont systemFontOfSize:14];
    UILabel *priceLabel          = [UIUtil drawLabelInView:backImgV frame:[UIUtil textRect:priceString font:priceFont] font:priceFont text:priceString isCenter:NO];
    priceLabel.textColor         = [UIColor blackColor];
    priceLabel.top               = titleNameLabel.bottom +Main_Screen_Height*10/667;
    priceLabel.left              = titleNameLabel.left;
    
    
    nameLab.hidden = YES;
    
    UILabel *brandLab = [[UILabel alloc] init];
    brandLab.text = @"金顶洗车";
    brandLab.font = [UIFont systemFontOfSize:11];
    [backImgV addSubview:brandLab];
    
    UILabel *introLab = [[UILabel alloc] init];
//    _introLab = introLab;
    //introLab.textColor = [UIColor colorFromHex:@"#ffffff"];
    introLab.text = @"扫码洗车自动抵扣";
    introLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    introLab.font = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
    [backImgV addSubview:introLab];
    
    UILabel *scoreLab = [[UILabel alloc] init];
    _scoreLab = scoreLab;
    scoreLab.text = @"1000积分";
    scoreLab.textColor = [UIColor colorFromHex:@"#ff525a"];
    scoreLab.font = [UIFont systemFontOfSize:14];
    [backImgV addSubview:scoreLab];
    
    
//    NSString *dateString        = @"10000积分";
//    UIFont *dateFont            = [UIFont systemFontOfSize:14];
//    UILabel *dateLabel          = [UIUtil drawLabelInView:backImgV frame:[UIUtil textRect:dateString font:dateFont] font:dateFont text:dateString isCenter:NO];
//    dateLabel.textColor         = [UIColor colorFromHex:@"#999999"];
//    _scoreLab = dateLabel;
//
//    dateLabel.bottom            = backImgV.bottom -Main_Screen_Height*20/667;
//    dateLabel.left              = titleNameLabel.left;
    
    
    
    [backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(22.5*Main_Screen_Height/667);
        make.right.equalTo(self.contentView).mas_offset(-22.5*Main_Screen_Height/667);
    }];
    
//    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backImgV).mas_offset(22*Main_Screen_Height/667);
//        make.top.equalTo(backImgV).mas_offset(21*Main_Screen_Height/667);
//    }];
//    
//    [brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(nameLab);
//        make.leading.equalTo(nameLab.mas_trailing).mas_offset(5*Main_Screen_Height/667);
//    }];
//    
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
        make.left.equalTo(titleNameLabel.mas_left);
        make.bottom.equalTo(backImgV).mas_offset(-20*Main_Screen_Height/667);
    }];

//    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(scoreLab.mas_top).mas_offset(-1*Main_Screen_Height/667);
//        make.left.equalTo(backImgV.mas_left).mas_offset(12*Main_Screen_Height/667);
//    }];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
