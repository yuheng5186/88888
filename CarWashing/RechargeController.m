//
//  RechargeController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "RechargeController.h"
#import "RechargeCell.h"
#import "RechargeDetailController.h"

@interface RechargeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *rechargeView;

@end

static NSString *id_rechargeCell = @"id_rechargeCell";

@implementation RechargeController

- (void) drawContent
{
    self.statusView.hidden      = YES;
    self.navigationView.hidden  = YES;
    self.contentView.top        = 0;
    self.contentView.height     = self.view.height;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (UITableView *)rechargeView {
    
    if (_rechargeView == nil) {
        UITableView *rechargeView = [[UITableView alloc] initWithFrame:CGRectInset(self.view.bounds, 10*Main_Screen_Height/667, 10*Main_Screen_Height/667) style:UITableViewStyleGrouped];
        _rechargeView = rechargeView;
        [self.view addSubview:_rechargeView];
    }
    return _rechargeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rechargeView.delegate = self;
    self.rechargeView.dataSource = self;
    
    [self.rechargeView registerNib:[UINib nibWithNibName:@"RechargeCell" bundle:nil] forCellReuseIdentifier:id_rechargeCell];
    self.rechargeView.rowHeight = 100;
    self.rechargeView.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:id_rechargeCell forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10*Main_Screen_Height/667;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    
    RechargeDetailController *rechargeDetailVC = [[RechargeDetailController alloc] init];
    rechargeDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeDetailVC animated:YES];
    
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
