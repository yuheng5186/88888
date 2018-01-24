//
//  HomeAdCell.m
//  CarWashing
//
//  Created by Wuxinglin on 2018/1/16.
//  Copyright © 2018年 DS. All rights reserved.
//

#import "HomeAdCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HTTPDefine.h"

@implementation HomeAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModelValue:(HomeAdModel *)model{
    self.homeAdLabel.text = [NSString stringWithFormat:@"%@",model.Title];
    [self.homeAdImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHTTPImg,model.ImgUrl]]];
}

@end
