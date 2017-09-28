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
    
////    self.CardnameLabel.textColor = [UIColor blackColor];
////    self.tagLabel.font = [UIFont systemFontOfSize:11*Main_Screen_Height/667];
////    self.CardnameLabel.font = [UIFont boldSystemFontOfSize:20*Main_Screen_Height/667];
////    self.CarddesLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
////    self.CardTimeLabel.font = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
////    self.CardTimeLabel.textColor = [UIColor colorFromHex:@"#999999"];
//    
//    
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
//-(void)configCell:(CardBag*)cell
//{
//    self.CardnameLabel.text = cell.CardName;
//    if ([cell.CardName isEqualToString:@"年卡"]) {
//        if (cell.CardUseState ==1) {//使用中
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_nianka"];
//        }else  if (cell.CardUseState ==2) {//已使用
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_nianka"];
//        }else  if (cell.CardUseState ==3) {//已过期
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_nianka"];
//        }
//    }else if ([cell.CardName isEqualToString:@"次卡"]){
//        if (cell.CardUseState ==1) {//使用中
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_cika"];
//        }else  if (cell.CardUseState ==2) {//已使用
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_cika"];
//        }else  if (cell.CardUseState ==3) {//已过期
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_cika"];
//        }
//    }else if ([cell.CardName isEqualToString:@"体验卡"]){
//        if (cell.CardUseState ==1) {//使用中
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_tiyanka"];
//        }else  if (cell.CardUseState ==2) {//已使用
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_tiyanka"];
//        }else  if (cell.CardUseState ==3) {//已过期
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_tiyanka"];
//        }
//    }else if ([cell.CardName isEqualToString:@"月卡"]){
//        if (cell.CardUseState ==1) {//使用中
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_yueka"];
//        }else  if (cell.CardUseState ==2) {//已使用
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_yueka"];
//        }else  if (cell.CardUseState ==3) {//已过期
//            self.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_yueka"];
//        }
//    }
//    
//    
//    self.CarddesLabel.text = [NSString stringWithFormat:@"免费洗车%ld次",cell.CardCount];
//    self.CardTimeLabel.text = [NSString stringWithFormat:@"截止日期：%@",cell.ExpEndDates];
//}


@end
