//
//  CYCardTableViewCell.m
//  CarWashing
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CYCardTableViewCell.h"

@implementation CYCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius=10;
    self.backView.clipsToBounds=NO;
    self.backView.layer.shadowColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor ;//shadowColor阴影颜色
    self.backView.layer.shadowOffset = CGSizeMake(0,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.backView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.backView.layer.shadowRadius = 4;//阴影半径，默认3
}

-(void)configCell:(CardBag*)model
{
    if (model.Type ==1) {
        self.typeLabel.text = @"购买卡";
        self.typeImageView.image=[UIImage imageNamed:@"kabao_ka"];
        self.leftNumLabel.text = [NSString stringWithFormat:@"洗车卡(%ld)",model.Counts];
    }else if (model.Type ==2) {
        self.typeLabel.text = @"赠送卡";
        self.typeImageView.image=[UIImage imageNamed:@"kabao_ka"];
        self.leftNumLabel.text = [NSString stringWithFormat:@"洗车卡(%ld)",model.Counts];
    }else if (model.Type ==3) {
        self.typeLabel.text = @"领取卡";
        self.typeImageView.image=[UIImage imageNamed:@"kabao_kaa"];
        self.leftNumLabel.text = [NSString stringWithFormat:@"洗车卡(%ld)",model.Counts];
    }
   
}

@end
