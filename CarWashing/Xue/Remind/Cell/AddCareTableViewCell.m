//
//  AddCareTableViewCell.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "AddCareTableViewCell.h"

@implementation AddCareTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    _mainTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 180, 30)];
//    _mainTitleLabel.backgroundColor = [UIColor grayColor];
    _mainTitleLabel.text = @"一二三四五六";
    _mainTitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_mainTitleLabel];
    
    _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 150, 30)];
    _subTitleLabel.text = @"一二三四五六";
    _subTitleLabel.font = [UIFont systemFontOfSize:15];
    _subTitleLabel.textColor = [UIColor colorFromHex:@"999999"];
    [self.contentView addSubview:_subTitleLabel];
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
