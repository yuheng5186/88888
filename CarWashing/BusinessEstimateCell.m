//
//  BusinessEstimateCell.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/4.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BusinessEstimateCell.h"
#import "HTTPDefine.h"
#import "UIImageView+WebCache.h"
@implementation BusinessEstimateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commentLabel.textColor = [UIColor colorFromHex:@"#999999"];
    
    self.dateLabel.textColor = [UIColor colorFromHex:@"#999999"];
    self.timeLabel.textColor = [UIColor colorFromHex:@"#999999"];
}
-(void)setModel:(QWMerComListModel *)model{
    _model=model;
    NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,model.FromuserImg];
    NSURL *url=[NSURL URLWithString:ImageURL];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"huiyuantou"]];
    self.phoneLabel.text=model.FromuserName;
     [self.userScoreLabel setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@xing",[[NSString stringWithFormat:@"%d",model.Score] substringToIndex:1]]]];
    self.commentLabel.text=model.CommentContent;
    self.dateLabel.text=model.CommentDate;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
