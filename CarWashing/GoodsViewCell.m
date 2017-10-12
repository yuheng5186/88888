//
//  GoodsViewCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "GoodsViewCell.h"
#import <Masonry.h>

@implementation GoodsViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    
    
//    UIView *containView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
//    containView.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:containView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImage *backImage = [UIImage imageNamed:@"jingpinduihuan"];
    backImageView.image = backImage;
    [self.contentView addSubview:backImageView];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.text = @"5元洗车券";
    valueLabel.font = [UIFont systemFontOfSize:14];
    [backImageView addSubview:valueLabel];
    
    UILabel *scoreValueLabel = [[UILabel alloc] init];
    scoreValueLabel.textColor = [UIColor whiteColor];
    scoreValueLabel.text = @"500积分兑换";
    scoreValueLabel.font = [UIFont systemFontOfSize:11];
    [backImageView addSubview:scoreValueLabel];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(21);
        make.centerX.equalTo(self.contentView);
    }];
    
    [scoreValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).mas_offset(-21);
        make.centerX.equalTo(self.contentView);
    }];
    
}

@end
