//
//  RechargeDetailController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "RechargeDetailController.h"
#import <Masonry.h>

@interface RechargeDetailController ()

@property (nonatomic,weak) UIView *containView;
@property (nonatomic, weak) UILabel *washCarLabel;
@property (nonatomic, weak) UILabel *validityLabel;
@property (nonatomic, weak) UILabel *timesLabel;
@property (nonatomic, weak) UILabel *noticeLabel;
@property (nonatomic, weak) UILabel *noticeLabelOne;
@property (nonatomic, weak) UILabel *noticeLabeTwo;
@property (nonatomic, weak) UILabel *noticeLabelThree;
@property (nonatomic, weak) UILabel *noticeLabelFour;
@property (nonatomic, weak) UILabel *noticeLabelFive;
@property (nonatomic, weak) UILabel *leaveWashLabel;
@property (nonatomic, weak) UILabel *leaveTimesLabel;


@property (nonatomic, weak) UIView  *titleView;

@end

@implementation RechargeDetailController


- (void)drawNavigation {
    
    [self drawTitle:@"充值卡详情"];
}


- (void) drawContent
{
//    self.statusView.backgroundColor     = [UIColor grayColor];
//    self.navigationView.backgroundColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)setupUI {
    
    self.washCarLabel.text = self.card.CardName;
    self.validityLabel.text = [NSString stringWithFormat:@"有效期至%@",self.card.ExpEndDates];
    self.timesLabel.text = [NSString stringWithFormat:@"免费洗车次数%ld次",self.card.CardCount];
    
    self.leaveWashLabel.text = [NSString stringWithFormat:@"%@剩余",self.card.CardName];
    self.leaveTimesLabel.text = [NSString stringWithFormat:@"免费洗车剩余%ld次",self.card.CardCount - self.card.UsedCount];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorFromHex:@"#f0f0f0"];
    [self.containView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor colorFromHex:@"#f0f0f0"];
    [self.containView addSubview:lineView2];
    
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = [UIColor colorFromHex:@"#f0f0f0"];
    [self.containView addSubview:lineView3];
    
    [self.washCarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView).mas_offset(20*Main_Screen_Height/667);
        make.left.equalTo(self.containView).mas_offset(10*Main_Screen_Height/667);
    }];
    
    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(self.washCarLabel.mas_bottom).mas_offset(15*Main_Screen_Height/667);
    }];
    
    [self.validityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timesLabel);
        make.right.equalTo(self.containView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timesLabel.mas_bottom).mas_offset(20*Main_Screen_Height/667);
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(10*Main_Screen_Height/667);
    }];
    
    [self.leaveWashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(lineView1.mas_bottom).mas_offset(20*Main_Screen_Height/667);
    }];
    
    [self.leaveTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(self.leaveWashLabel.mas_bottom).mas_offset(15*Main_Screen_Height/667);
    }];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leaveTimesLabel.mas_bottom).mas_offset(20*Main_Screen_Height/667);
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(10*Main_Screen_Height/667);
    }];
    
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(lineView2.mas_bottom).mas_offset(20*Main_Screen_Height/667);
    }];
    
    [self.noticeLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(self.noticeLabel.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.right.equalTo(self.containView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [self.noticeLabeTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(self.noticeLabelOne.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.right.equalTo(self.containView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [self.noticeLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(self.noticeLabeTwo.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.right.equalTo(self.containView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [self.noticeLabelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(self.noticeLabelThree.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.right.equalTo(self.containView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [self.noticeLabelFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.washCarLabel);
        make.top.equalTo(self.noticeLabelFour.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.right.equalTo(self.containView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noticeLabelFive.mas_bottom).mas_offset(20*Main_Screen_Height/667);
        make.left.right.equalTo(self.containView);
        make.bottom.equalTo(self.containView);
    }];
    
}

- (UIView *)containView {
    
    if (!_containView) {
        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height)];
        containView.backgroundColor = [UIColor whiteColor];
        _containView = containView;
        [self.view addSubview:_containView];
    }
    return _containView;
}

- (UILabel *)washCarLabel {
    
    if (!_washCarLabel) {
        UILabel *washCarLabel = [[UILabel alloc] init];
        washCarLabel.text = self.card.CardName;
        washCarLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        washCarLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        _washCarLabel = washCarLabel;
        [self.containView addSubview:_washCarLabel];
    }
    return _washCarLabel;
}

- (UILabel *)validityLabel {
    
    if (!_validityLabel) {
        
        UILabel *validityLabel = [[UILabel alloc] init];
        validityLabel.text = [NSString stringWithFormat:@"有效期至%@",self.card.ExpEndDates];
        validityLabel.textColor = [UIColor colorFromHex:@"#999999"];
        validityLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        _validityLabel = validityLabel;
        [self.containView addSubview:_validityLabel];
    }
    return _validityLabel;
}


- (UILabel *)timesLabel {
    
    if (!_timesLabel) {
        UILabel *timesLabel = [[UILabel alloc] init];
        timesLabel.text = [NSString stringWithFormat:@"免费洗车次数%ld次",self.card.CardCount];
        timesLabel.textColor = [UIColor colorFromHex:@"#999999"];
        timesLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        _timesLabel = timesLabel;
        [self.containView addSubview:_timesLabel];
    }
    return _timesLabel;
}

- (UILabel *)noticeLabel {
    
    if (!_noticeLabel) {
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.text = @"使用须知";
        noticeLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        noticeLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        _noticeLabel = noticeLabel;
        [self.containView addSubview:_noticeLabel];
    }
    return _noticeLabel;
}


- (UILabel *)noticeLabelOne {
    
    if (!_noticeLabelOne) {
        UILabel *noticeLabelOne = [[UILabel alloc] init];
        noticeLabelOne.text = @"1. 下载金顶洗车APP，通过扫码可直接启动洗车机；";
        noticeLabelOne.numberOfLines = 0;
        noticeLabelOne.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelOne.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        _noticeLabelOne = noticeLabelOne;
        [self.containView addSubview:_noticeLabelOne];
    }
    return _noticeLabelOne;
}

- (UILabel *)noticeLabeTwo {
    
    if (!_noticeLabeTwo) {
        UILabel *noticeLabelTwo = [[UILabel alloc] init];
        noticeLabelTwo.text = @"2. 整个洗车过程请遵照洗车提示和工作人员引导；";
        noticeLabelTwo.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelTwo.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        _noticeLabeTwo = noticeLabelTwo;
        [self.containView addSubview:_noticeLabeTwo];
    }
    return _noticeLabeTwo;
}


- (UILabel *)noticeLabelThree {
    
    if (!_noticeLabelThree) {
        
        UILabel *noticeLabelThree = [[UILabel alloc] init];
        noticeLabelThree.text = @"3. 此卡请在有效期内使用，不退卡、不转让、不挂失；";
        noticeLabelThree.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelThree.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        noticeLabelThree.numberOfLines = 0;
        _noticeLabelThree = noticeLabelThree;
        [self.containView addSubview:_noticeLabelThree];
    }
    
    return _noticeLabelThree;
}


- (UILabel *)noticeLabelFour {
    
    if (!_noticeLabelFour) {
        
        UILabel *noticeLabelFour = [[UILabel alloc] init];
        noticeLabelFour.text = @"4. 启动前请确保外置天线、反光镜已经收起，车窗等处于关闭、全车处于隔水状态，自行改装外饰确保不妨碍洗车；";
        noticeLabelFour.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelFour.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        noticeLabelFour.numberOfLines = 0;
        _noticeLabelFour = noticeLabelFour;
        [self.containView addSubview:_noticeLabelFour];
    }
    
    return _noticeLabelFour;
}


- (UILabel *)noticeLabelFive {
    
    if (!_noticeLabelFive) {
        
        UILabel *noticeLabelFive = [[UILabel alloc] init];
        noticeLabelFive.text = @"5. 请不要在洗车过程中随意上下车，若出现问题或者故障可咨询工作人员或拨打客服电话进行咨询";
        noticeLabelFive.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelFive.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        noticeLabelFive.numberOfLines = 0;
        _noticeLabelFive = noticeLabelFive;
        [self.containView addSubview:_noticeLabelFive];
    }
    
    return _noticeLabelFive;
}


- (UILabel *)leaveWashLabel {
    
    if (!_leaveWashLabel) {
        
        UILabel *leaveWashLabel = [[UILabel alloc] init];
        leaveWashLabel.text = @"";
        leaveWashLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        leaveWashLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        _leaveWashLabel = leaveWashLabel;
        [self.containView addSubview:_leaveWashLabel];
    }
    
    return _leaveWashLabel;
}


- (UILabel *)leaveTimesLabel {
    
    if (!_leaveTimesLabel) {
        
        UILabel *leaveTimesLabel = [[UILabel alloc] init];
        leaveTimesLabel.text = @"";
        leaveTimesLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        leaveTimesLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        _leaveTimesLabel = leaveTimesLabel;
        [self.containView addSubview:_leaveTimesLabel];
    }
    
    return _leaveTimesLabel;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
