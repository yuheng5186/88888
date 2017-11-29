//
//  MemberRightCell.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MemberRightCell.h"

@implementation MemberRightCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}


-(void)setUpUI{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    self.titleLabel.text = @"精品专区";
    [self.contentView addSubview:self.titleLabel];
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
