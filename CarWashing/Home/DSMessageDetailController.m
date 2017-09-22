//
//  DSMessageDetailController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSMessageDetailController.h"

@interface DSMessageDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DSMessageDetailController

@synthesize navTitle;

- (void)drawNavigation {
    
    [self drawTitle:self.navTitle Color:[UIColor blackColor]];
    
}

- (void) drawContent
{
    self.statusView.backgroundColor     = [UIColor grayColor];
    self.navigationView.backgroundColor = [UIColor grayColor];
    
    self.contentView.top                = Main_Screen_Height*44/667;
    self.contentView.height             = self.view.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubView];
}

- (void) createSubView {
    
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height) style:UITableViewStylePlain];
    self.tableView.top              = 0;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    //    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor  = [UIColor whiteColor];
//    self.tableView.scrollEnabled    = NO;
    //    self.tableView.tableFooterView  = [UIView new];
//    self.tableView.contentInset     = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.contentView addSubview:self.tableView];
}
#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30.0f*Main_Screen_Height/667;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    static NSString *headerSectionID    = @"headerSectionID";
    UITableViewHeaderFooterView *headerView     = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
    UILabel  *titleLabel;
    if (headerView == nil) {
        headerView  = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerSectionID];
        titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*Main_Screen_Height/667, 40*Main_Screen_Height/667)];
        titleLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        titleLabel.text = @"2017-7-27 10:53:05";
        titleLabel.centerX  = self.navigationView.centerX +20*Main_Screen_Height/667;
        [headerView addSubview:titleLabel];
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10*Main_Screen_Height/667;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120*Main_Screen_Height/667;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.backgroundColor    = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *titleLabel  = [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, 240*Main_Screen_Height/667, 20*Main_Screen_Height/667) font:[UIFont systemFontOfSize:16] text:@"[免费领取洗车券]领取入口" isCenter:NO];
    titleLabel.top       = 10*Main_Screen_Height/667;
    titleLabel.left      = 10*Main_Screen_Height/667;
    
    UILabel *remindLabel  = [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, 240*Main_Screen_Height/667, 20*Main_Screen_Height/667) font:[UIFont systemFontOfSize:14] text:@"限时领取，即刻领取..." isCenter:NO];
    remindLabel.top       = titleLabel.bottom +Main_Screen_Height*10/667;
    remindLabel.left      = 10*Main_Screen_Height/667;
    
    UIView *lineView      = [UIUtil drawLineInView:cell.contentView frame:CGRectMake(0, 0, 340*Main_Screen_Height/667, 1) color:[UIColor grayColor]];
    lineView.top          = remindLabel.bottom +Main_Screen_Height*10/667;
    lineView.left         = 10*Main_Screen_Height/667;
    
    UILabel *detailLabel  = [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, 240*Main_Screen_Height/667, 20) font:[UIFont systemFontOfSize:14*Main_Screen_Height/667] text:@"查看详情" isCenter:NO];
    detailLabel.top       = lineView.bottom +Main_Screen_Height*10/667;
    detailLabel.left      = 10*Main_Screen_Height/667;
    
    UIImageView *nextImageView      = [UIUtil drawCustomImgViewInView:cell.contentView frame:CGRectMake(0, 0, 30*Main_Screen_Height/667,30*Main_Screen_Height/667) imageName:@"WechatIMG772"];
    nextImageView.right             = Main_Screen_Width -Main_Screen_Width*20/375;
    nextImageView.top               = lineView.bottom +Main_Screen_Height*10/667;
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
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
