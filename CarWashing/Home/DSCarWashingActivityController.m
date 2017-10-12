//
//  DSCarWashingActivityController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/8.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSCarWashingActivityController.h"
#import "UIWindow+YzdHUD.h"
#import <Masonry.h>

@interface DSCarWashingActivityController ()

@end

@implementation DSCarWashingActivityController

- (void) drawNavigation {

    [self drawTitle:@"新用户奖励"];
}

- (void) drawContent {
    self.contentView.top        = self.navigationView.bottom;
    self.contentView.height     = self.view.height;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubView];
}
- (void) createSubView {
    
    UIImageView *backImgV = [[UIImageView alloc] init];
    backImgV.image = [UIImage imageNamed:@"bg_card"];
    [self.view addSubview:backImgV];
    
    UIButton *getBtn = [UIUtil drawDefaultButton:self.view title:@"立即领取" target:self action:@selector(getCardButtonClick:)];
    
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containView];
    
    [backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(64 + 25*Main_Screen_Height/667);
        make.left.equalTo(self.view).mas_offset(37.5*Main_Screen_Height/667);
        make.right.equalTo(self.view).mas_offset(-37.5*Main_Screen_Height/667);
        make.height.mas_equalTo(192*Main_Screen_Height/667);
    }];
    
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgV.mas_bottom).mas_offset(50*Main_Screen_Height/667);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(351*Main_Screen_Height/667);
        make.height.mas_equalTo(49*Main_Screen_Height/667);
    }];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getBtn.mas_bottom).mas_offset(30*Main_Screen_Height/667);
        make.width.mas_equalTo(Main_Screen_Width);
        make.height.mas_equalTo(200*Main_Screen_Height/667);
    }];
    
    //
    UILabel *cardLab = [[UILabel alloc] init];
    cardLab.text = @"体验卡";
    cardLab.font = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
    [backImgV addSubview:cardLab];
    
    UILabel *brandLab = [[UILabel alloc] init];
    brandLab.text = @"金顶洗车";
    brandLab.font = [UIFont systemFontOfSize:11*Main_Screen_Height/667];
    [backImgV addSubview:brandLab];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.text = @"扫码洗车服务中使用";
    introLab.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
    [backImgV addSubview:introLab];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.text = @"有效期：2017.8.10-2017.10.8";
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.textColor = [UIColor colorFromHex:@"#999999"];
    [backImgV addSubview:timeLab];
    
    [cardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgV).mas_offset(20*Main_Screen_Height/667);
        make.left.equalTo(backImgV).mas_offset(20*Main_Screen_Height/667);
    }];
    
    [brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardLab);
        make.leading.equalTo(cardLab.mas_trailing).mas_offset(5*Main_Screen_Height/667);
    }];
    
    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(cardLab);
        make.top.equalTo(cardLab.mas_bottom).mas_offset(10*Main_Screen_Height/667);
    }];
    
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImgV).mas_offset(-18*Main_Screen_Height/667);
        make.leading.equalTo(cardLab);
    }];
    
    
    
    //
    UILabel *noticeLab = [[UILabel alloc] init];
    noticeLab.text = @"使用须知";
    noticeLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    noticeLab.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    [containView addSubview:noticeLab];
    
    UILabel *noticeLab1 = [[UILabel alloc] init];
    noticeLab1.text = @"1、本代金券由金顶洗车APP开发，仅限金顶洗车店和与金顶合作商家使用";
    noticeLab1.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLab1.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLab1.numberOfLines = 0;
    [containView addSubview:noticeLab1];
    
    UILabel *noticeLab2 = [[UILabel alloc] init];
    noticeLab2.text = @"2、如果使用代金券购买服务时发生退服务行为，代金券不予退还";
    noticeLab2.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLab2.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    [containView addSubview:noticeLab2];
    
    UILabel *noticeLab3 = [[UILabel alloc] init];
    noticeLab3.text = @"3、有任何问题，可咨询金顶客服";
    noticeLab3.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLab3.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    [containView addSubview:noticeLab3];
    
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView).mas_offset(20*Main_Screen_Height/667);
        make.left.equalTo(containView).mas_offset(12*Main_Screen_Height/667);
    }];
    
    [noticeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLab);
        make.top.equalTo(noticeLab.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.right.equalTo(containView).mas_offset(-12*Main_Screen_Height/667);
    }];
    
    [noticeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLab1.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.leading.equalTo(noticeLab1);
        make.right.equalTo(containView).mas_offset(-12*Main_Screen_Height/667);
    }];
    
    [noticeLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLab2.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.leading.equalTo(noticeLab2);
        make.right.equalTo(containView).mas_offset(-12*Main_Screen_Height/667);
    }];
    
    
}
- (void) getCardButtonClick:(id)sender {
    
    [self.view.window showHUDWithText:@"恭喜您领取成功，已经放入您的卡券中" Type:ShowPhotoYes Enabled:YES];

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
