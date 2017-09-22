//
//  DSSettingController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSSettingController.h"
#import "DSPasswordController.h"
#import "DSAboutController.h"
#import "DSFeedbackController.h"
#import "DSGetScoreController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"

#import "UdStorage.h"


@interface DSSettingController ()<UITableViewDelegate,UITableViewDataSource,LKAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DSSettingController

- (void)drawNavigation {
    
    [self drawTitle:@"设置"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubView];
}

- (void) createSubView {

    UIView *upView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*180/667) color:[UIColor colorFromHex:@"#e5e5e5"]];
    upView.top                      = 0;
    
    UIImage *appImage              = [UIImage imageNamed:@"denglu_icon"];
    UIImageView *appImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(0, 0, appImage.size.width, appImage.size.height) imageName:@"denglu_icon"];
    appImageView.top               = Main_Screen_Height*30/667;
    appImageView.centerX           = upView.centerX;
    
    NSString *showName              = @"分享蔷薇爱车，让您的好友可以下载蔷薇客户端";
    UIFont *showNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*13/667];
    UILabel *showNameLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:showName font:showNameFont] font:showNameFont text:showName isCenter:NO];
    showNameLabel.textColor         = [UIColor colorFromHex:@"#999999"];
    showNameLabel.top               = appImageView.bottom +Main_Screen_Height*10/667;
    showNameLabel.centerX           = appImageView.centerX;
    
    upView.height                   = showNameLabel.bottom +Main_Screen_Height*20/667;
    
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height*150/667) style:UITableViewStyleGrouped];
    self.tableView.top              = upView.bottom;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.scrollEnabled    = NO;
    self.tableView.backgroundColor  = [UIColor clearColor];
//    self.tableView.tableFooterView  = [UIView new];
    [self.contentView addSubview:self.tableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIButton *logoutButton      = [UIUtil drawDefaultButton:self.contentView title:@"退出当前帐号" target:self action:@selector(logoutButtonClick:)];
    logoutButton.top           = self.tableView.bottom;
    logoutButton.centerX       = upView.centerX;
    
    
    
}
- (void) logoutButtonClick:(id)sender {
    
    LKAlertView *alartView      = [[LKAlertView alloc]initWithTitle:@"提示" message:@"是否退出当前账户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
    alartView.tag               = 110;
    [alartView show];

}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
//
//-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
//
//{
//    return 0.01f;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 2;
//            break;
//        case 2:
//            return 1;
//            break;
//        default:
//            break;
//    }
    return 2;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*Main_Screen_Height/667;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.backgroundColor    = [UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor    = [UIColor blackColor];
    cell.textLabel.font         = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        cell.textLabel.text     = @"关于蔷薇";

    }else if (indexPath.row == 1){
    
//        cell.textLabel.text     = @"关于蔷薇";
        cell.textLabel.text     = @"给我评分";


    }else {
    
        cell.textLabel.text     = @"给我评分";
    }
    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            cell.textLabel.text     = @"密码管理";
//        }else{
////            cell.textLabel.text     = @"清除缓存";
//        }
//    }else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            cell.textLabel.text     = @"关于蔷薇";
//        }else {
//            cell.textLabel.text     = @"意见反馈";
//        }
//        
//    }else{
//        cell.textLabel.text     = @"给我评分";
//
//    }
    

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
//        DSPasswordController *passwordController        = [[DSPasswordController alloc]init];
//        passwordController.hidesBottomBarWhenPushed      = YES;
//        [self.navigationController pushViewController:passwordController animated:YES];
        DSAboutController *aboutController             = [[DSAboutController alloc]init];
        aboutController.hidesBottomBarWhenPushed        = YES;
        [self.navigationController pushViewController:aboutController animated:YES];
        
    }else if (indexPath.row == 1){
    

        NSString *str = [NSString stringWithFormat:  @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1284053624&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else {
    
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/qq/id451108668?mt=12"]];

    }
    
    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            
//            DSPasswordController *passwordController        = [[DSPasswordController alloc]init];
//            passwordController.hidesBottomBarWhenPushed      = YES;
//            [self.navigationController pushViewController:passwordController animated:YES];
//            
//        }else{
//            LKAlertView *alartView      = [[LKAlertView alloc]initWithTitle:@"提示框" message:@"目前缓存8M，您确定清空缓存么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
//            alartView.tag               = 111;
//            [alartView show];
//        }
//    }else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            
//            DSAboutController *aboutController             = [[DSAboutController alloc]init];
//            aboutController.hidesBottomBarWhenPushed        = YES;
//            [self.navigationController pushViewController:aboutController animated:YES];
//            
//        }else {
//            
//            DSFeedbackController *feedbackController        = [[DSFeedbackController alloc]init];
//            feedbackController.hidesBottomBarWhenPushed     = YES;
//            [self.navigationController pushViewController:feedbackController animated:YES];
//        }
//        
//    }else{
////        
////        DSGetScoreController *getScore                      = [[DSGetScoreController alloc]init];
////        getScore.hidesBottomBarWhenPushed                   = YES;
////        [self.navigationController pushViewController:getScore animated:YES];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/qq/id451108668?mt=12"]];

//    }
}

#pragma mark ---LKAlertViewDelegate---
- (void)alertView:(LKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 110) {
        if (buttonIndex == 0) {
            
        }else{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"Account_Id"];
                [defaults setValue:@NO forKey:@"firstRun"];
                [defaults synchronize];
            
        
            
                LoginViewController *loginControl = [[LoginViewController alloc]init];
                UINavigationController *nav         = [[UINavigationController alloc]initWithRootViewController:loginControl];
                nav.navigationBar.hidden      = YES;
            
            
            
                self.view.window.rootViewController      = nav;


            
        }
    }else{
    
        if (buttonIndex == 0) {
            
        }else{
            
            
        }
    }

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
