//
//  MemberView.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/27.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberView : UIView
@property (weak, nonatomic) IBOutlet UIView *topContainView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainView;

@property (weak, nonatomic) IBOutlet UIButton *increaseButton;

@property (weak, nonatomic) IBOutlet UIButton *ernScoreButton;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *UserImgView;
@property (weak, nonatomic) IBOutlet UIImageView *signLabel;

@property (weak, nonatomic) IBOutlet UIButton *LevelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ScoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *fontOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontTwoLabel;

@property (weak, nonatomic) IBOutlet UILabel *fontThreeView;
@property (weak, nonatomic) IBOutlet UILabel *fontFourLabel;

+ (instancetype)memberView;

@end
