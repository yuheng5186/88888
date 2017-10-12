//
//  ScoreGetController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/27.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ScoreGetController.h"
#import <Masonry.h>

@interface ScoreGetController ()

@end

@implementation ScoreGetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    
    UILabel *signLab = [[UILabel alloc] init];
    signLab.text = @"APP签到";
    signLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    signLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:signLab];
    
    UILabel *signIntroLab = [[UILabel alloc] init];
    signIntroLab.textColor = [UIColor colorFromHex:@"#999999"];
    signIntroLab.font = [UIFont systemFontOfSize:13];
    signIntroLab.numberOfLines = 0;
    signIntroLab.text = @"1、金顶会员在: '我的-每日签到'中签到获得积分,每人每天仅可签到一次";
    [self.view addSubview:signIntroLab];
    
    UILabel *shareLab = [[UILabel alloc] init];
    shareLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    shareLab.font = [UIFont systemFontOfSize:16];
    shareLab.text = @"分享";
    [self.view addSubview:shareLab];
    
    UILabel *shareOneLab = [[UILabel alloc] init];
    shareOneLab.textColor = [UIColor colorFromHex:@"#999999"];
    shareOneLab.font = [UIFont systemFontOfSize:13];
    shareLab.numberOfLines = 0;
    shareOneLab.text = @"1、分享商品好友点击您分享的链接下单成功,并完成该订单将获得丰厚的积分奖励";
    [self.view addSubview:shareOneLab];
    
    UILabel *shareTwoLab = [[UILabel alloc] init];
    shareTwoLab.textColor = [UIColor colorFromHex:@"#999999"];
    shareTwoLab.font = [UIFont systemFontOfSize:13];
    shareTwoLab.text = @"2、分享活动内容即可获得积分奖励";
    [self.view addSubview:shareTwoLab];
    
    UILabel *recommendLab = [[UILabel alloc] init];
    recommendLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    recommendLab.font = [UIFont systemFontOfSize:16];
    recommendLab.text = @"推荐APP";
    [self.view addSubview:recommendLab];
    
    UILabel *recommendOneLab = [[UILabel alloc] init];
    recommendOneLab.textColor = [UIColor colorFromHex:@"#999999"];
    recommendOneLab.font = [UIFont systemFontOfSize:13];
    recommendOneLab.numberOfLines = 0;
    recommendOneLab.text = @"1、推荐好友下载金顶APP,每注册完成一个好友即可获得积分奖励";
    [self.view addSubview:recommendOneLab];
    
    UILabel *scoreBackLab = [[UILabel alloc] init];
    scoreBackLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    scoreBackLab.font = [UIFont systemFontOfSize:16];
    scoreBackLab.text = @"评论返积分";
    [self.view addSubview:scoreBackLab];
    
    UILabel *scoreOneLab = [[UILabel alloc] init];
    scoreOneLab.textColor = [UIColor colorFromHex:@"#999999"];
    scoreOneLab.font = [UIFont systemFontOfSize:13];
    scoreOneLab.numberOfLines = 0;
    scoreOneLab.text = @"1、使用商品评论功能,我们将在您评论后,给予丰厚的积分奖励";
    [self.view addSubview:scoreOneLab];
    
    
    //约束
    [signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(10);
        make.top.equalTo(self.view).mas_offset(25);
    }];
    
    [signIntroLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(signLab.mas_bottom).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
    [shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(signIntroLab.mas_bottom).mas_offset(25);
    }];
    
    [shareOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(shareLab.mas_bottom).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
    [shareTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(shareOneLab.mas_bottom).mas_offset(15);
    }];
    
    [recommendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(shareTwoLab.mas_bottom).mas_offset(25);
    }];
    
    [recommendOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(recommendLab.mas_bottom).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
    [scoreBackLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(recommendOneLab.mas_bottom).mas_offset(25);
    }];
    
    [scoreOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signLab);
        make.top.equalTo(scoreBackLab.mas_bottom).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
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
