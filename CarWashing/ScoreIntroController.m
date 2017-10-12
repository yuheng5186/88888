//
//  ScoreIntroController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/27.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ScoreIntroController.h"
#import <Masonry.h>

@interface ScoreIntroController ()

@end

@implementation ScoreIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    
    UILabel *rangeLabel = [[UILabel alloc] init];
    rangeLabel.text = @"适用范围";
    rangeLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    rangeLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:rangeLabel];
    
    UILabel *rangeOneLab = [[UILabel alloc] init];
    rangeOneLab.textColor = [UIColor colorFromHex:@"#999999"];
    rangeOneLab.font = [UIFont systemFontOfSize:13];
    rangeOneLab.numberOfLines = 0;
    rangeOneLab.text = @"1、金顶积分仅可在金顶APP使用,如该账号暂停使用,则金顶将取消该用户账号内积分使用相关权限";
    [self.view addSubview:rangeOneLab];
    
    UILabel *rangeTwoLab = [[UILabel alloc] init];
    rangeTwoLab.textColor = [UIColor colorFromHex:@"#999999"];
    rangeTwoLab.font = [UIFont systemFontOfSize:13];
    rangeTwoLab.numberOfLines = 0;
    rangeTwoLab.text = @"2、金顶积分可用于在金顶洗车APP中会员商城中兑换抵扣卷、洗车优惠券等活动";
    [self.view addSubview:rangeTwoLab];
    
    UILabel *rangeThreeLab = [[UILabel alloc] init];
    rangeThreeLab.textColor = [UIColor colorFromHex:@"#999999"];
    rangeThreeLab.font = [UIFont systemFontOfSize:13];
    rangeThreeLab.numberOfLines = 0;
    rangeThreeLab.text = @"3、积分查询: 您可以在我的-金顶会员中查询到您的积分详细情况";
    [self.view addSubview:rangeThreeLab];
    
    
    UILabel *usefulLabel = [[UILabel alloc] init];
    usefulLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    usefulLabel.font = [UIFont systemFontOfSize:16];
    usefulLabel.text = @"积分有效期";
    [self.view addSubview:usefulLabel];
    
    UILabel *usefulOneLab = [[UILabel alloc] init];
    usefulOneLab.textColor = [UIColor colorFromHex:@"#999999"];
    usefulOneLab.font = [UIFont systemFontOfSize:13];
    usefulOneLab.numberOfLines = 0;
    usefulOneLab.text = @"1、用户获得积分但未使用,将在下一个自然年份过期,金顶将定期对过期积分进行作废处理";
    [self.view addSubview:usefulOneLab];
    
    
    //约束
    [rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(10);
        make.top.equalTo(self.view).mas_offset(25);
    }];
    
    [rangeOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(rangeLabel);
        make.top.equalTo(rangeLabel.mas_bottom).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
    [rangeTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(rangeLabel);
        make.top.equalTo(rangeOneLab.mas_bottom).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
    [rangeThreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(rangeLabel);
        make.top.equalTo(rangeTwoLab.mas_bottom).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
    [usefulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(rangeLabel);
        make.top.equalTo(rangeThreeLab.mas_bottom).mas_offset(25);
    }];
    
    [usefulOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(rangeLabel);
        make.top.equalTo(usefulLabel.mas_bottom).mas_offset(15);
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
