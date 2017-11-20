//
//  RemindViewTableViewCell.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "RemindViewTableViewCell.h"

@implementation RemindViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setUp{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //小灰条
    UIView *speatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-24, 90)];
    speatorView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.contentView addSubview:speatorView];
    
    //大白条
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, Main_Screen_Width-24, 75)];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.clipsToBounds = YES;
    baseView.layer.cornerRadius = 7;
    [self.contentView addSubview:baseView];
    
    
    
    _smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 26, 24, 18)];
//    _smallImageView.backgroundColor = [UIColor grayColor];
    [baseView addSubview:_smallImageView];
    
    _bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 13, 200, 18)];
//    _bigLabel.backgroundColor = [UIColor grayColor];
    _bigLabel.text = @"驾驶证换证提醒";
    _bigLabel.font = [UIFont systemFontOfSize:18];
    _bigLabel.textColor = [UIColor colorFromHex:@"4a4a4a"];
    [baseView addSubview:_bigLabel];
    
    _shortLabel = [[UILabel alloc]initWithFrame:CGRectMake(69, 44, 200, 18)];
//    _shortLabel.backgroundColor = [UIColor grayColor];
//    _shortLabel.text = self.settenString;
    _shortLabel.font = [UIFont systemFontOfSize:15];
    _shortLabel.textColor = [UIColor colorFromHex:@"909090"];
    [baseView addSubview:_shortLabel];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-50, 30, 7, 13)];
    leftImage.image = [UIImage imageNamed:@"jiantou"];
    [baseView addSubview:leftImage];
    
}

@end
