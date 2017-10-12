//
//  ActivityListCell.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ActivityListCell.h"
#import "DSActivityModel.h"
#import "DSCarClubDetailController.h"
#import "UIView+AutoSizeToDevice.h"
@implementation ActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dg_viewAutoSizeToDevice = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DSActivityModel *)model {

    NSString * name = [NSString stringWithFormat:@"rank_%@",model.iconName];
    
    self.activityImageView.image = [UIImage imageNamed:name];
    self.activityTitleLabel.text    = model.titleName;
    self.activityTimeLabel.text     = model.sayTime;
    self.sayNumberLabel.text=model.sayNumber;
    self.goodNumberLabel.text=model.goodNumber;
}
#pragma mark - 懒加载
- (UIImageView *)activityImageView{
    if (_activityImageView == nil) {
        UIImageView * iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        _activityImageView = iconImageView;
    }
    return _activityImageView;
}

- (UILabel *)activityTitleLabel{
    if (_activityTitleLabel == nil) {
        UILabel * nickNameLabel = [[UILabel alloc] init];
        nickNameLabel.textColor = [UIColor orangeColor];
        nickNameLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:nickNameLabel];
        _activityTitleLabel = nickNameLabel;
    }
    return _activityTitleLabel;
}

- (UILabel *)activityTimeLabel{
    if (_activityTimeLabel == nil) {
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:contentLabel];
        _activityTimeLabel = contentLabel;
    }
    return _activityTimeLabel;
}

- (UILabel *) sayNumberLabel {
    if (_sayNumberLabel == nil) {
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:contentLabel];
        _sayNumberLabel = contentLabel;
    }
    return _sayNumberLabel;
}

- (UILabel *) goodNumberLabel {
    if (_goodNumberLabel == nil) {
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:contentLabel];
        _goodNumberLabel = contentLabel;
    }
    return _goodNumberLabel;
}

//- (IBAction)goodButtonClick:(id)sender {
//    UIButton *button = (UIButton *)sender;
//    if (button.selected == NO) {
//        [self.goodButton setImage:[UIImage imageNamed:@"xiaohongshou"] forState:UIControlStateNormal];
////        self.goodNumberLabel.text                     = @"1289";
////        [self.view showInfo:@"点赞成功!" autoHidden:YES];
//    }else {
//        [self.goodButton setImage:[UIImage imageNamed:@"huodongxiangqingzan"] forState:UIControlStateNormal];
////        self.goodNumberLabel.text                     = @"1288";
////        [self.view showInfo:@"取消点赞!" autoHidden:YES];
//        
//    }
//    button.selected = !button.selected;
//}

- (IBAction)sayButtonClick:(id)sender {
    

}


@end
