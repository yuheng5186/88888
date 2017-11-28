//
//  AppDelegate.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/18.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuTabBarController.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"
#import "DSGuideViewController.h"
#import "UdStorage.h"
#import "HTTPDefine.h"
//

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

//分享反馈
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"



@interface AppDelegate ()<UITabBarDelegate,WXApiDelegate>
{
    AppDelegate *myDelegate;
}
@property (nonatomic, strong) MenuTabBarController *menuTabBarController;
@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if(Main_Screen_Height > 568)
    {
        myDelegate.autoSizeScaleX = Main_Screen_Width/375;
        myDelegate.autoSizeScaleY = Main_Screen_Height/667;
    }
    else
    {
        myDelegate.autoSizeScaleX = Main_Screen_Width/375;
        myDelegate.autoSizeScaleY = Main_Screen_Height/667;
    }
    
    [IQKeyboardManager sharedManager].enable = YES;
    [AMapServices sharedServices].apiKey = @"f6d2c4b2f6bbe466b2d1b1889783445e";
    
    application.statusBarHidden                     = NO;
    [[UITabBar appearance] setBarTintColor: [UIColor whiteColor]];
    [[UITabBar appearance] setTintColor: [UIColor colorFromHex:@"#febb02"]];
    
    application.statusBarStyle                      = UIStatusBarStyleLightContent;
    application.applicationIconBadgeNumber          = 0;
    
    self.window									= [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    
    if([UdStorage getObjectforKey:Userid])
    {
        
        APPDELEGATE.currentUser = [[User alloc]init];
        
        APPDELEGATE.currentUser.Account_Id = [[UdStorage getObjectforKey:Userid] integerValue];
        APPDELEGATE.currentUser.Level_id = [[UdStorage getObjectforKey:@"Level_id"] integerValue];
        APPDELEGATE.currentUser.UserScore = [[UdStorage getObjectforKey:@"UserScore"] integerValue];
        APPDELEGATE.currentUser.ModifyType = [[UdStorage getObjectforKey:@"ModifyType"] integerValue];
        APPDELEGATE.currentUser.VerCode = [[UdStorage getObjectforKey:@"VerCode"] integerValue];
        APPDELEGATE.currentUser.userName = [UdStorage getObjectforKey:@"Name"];
        APPDELEGATE.currentUser.Accountname = [UdStorage getObjectforKey:@"UserName"];
        APPDELEGATE.currentUser.userImagePath = [UdStorage getObjectforKey:@"Headimg"];
        APPDELEGATE.currentUser.userPhone = [UdStorage getObjectforKey:@"Mobile"];
        APPDELEGATE.currentUser.userSex = [UdStorage getObjectforKey:@"Sex"];
        APPDELEGATE.currentUser.userAge = [UdStorage getObjectforKey:@"Age"];
        APPDELEGATE.currentUser.userhobby = [UdStorage getObjectforKey:@"Hobby"];
        APPDELEGATE.currentUser.usermemo = [UdStorage getObjectforKey:@"Memo"];
        APPDELEGATE.currentUser.useroccupation = [UdStorage getObjectforKey:@"Occupation"];
        
        
        MenuTabBarController *menuTabBarController              = [[MenuTabBarController alloc] init];
       
        self.window.rootViewController  = menuTabBarController;
        
    }
    
    else{
        LoginViewController *loginControl = [[LoginViewController alloc]init];
        UINavigationController *nav         = [[UINavigationController alloc]initWithRootViewController:loginControl];
        self.window.rootViewController      = nav;
        nav.navigationBar.hidden      = YES;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        DSGuideViewController *guideControl = [[DSGuideViewController alloc]init];
        UINavigationController *nav         = [[UINavigationController alloc]initWithRootViewController:guideControl];//为假表示没有文件，没有进入过主页
        self.window.rootViewController      = nav;
        nav.navigationBar.hidden      = YES;
    }
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"setTime"];
    [defaults synchronize];
    
//    LoginViewController *loginControl = [[LoginViewController alloc]init];
//    UINavigationController *nav         = [[UINavigationController alloc]initWithRootViewController:loginControl];
//    nav.navigationBar.hidden      = YES;
//
//    self.window.rootViewController      = nav;
    
//    MenuTabBarController *menuTabBarController	= [[MenuTabBarController alloc] init];
//    self.window.rootViewController				= menuTabBarController;
    [WXApi registerApp:@"wx391fd62749c99d3a"];      //公司
    

    


    return YES;
}

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
  
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]){
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    

    return YES;
    
    
    
}
- (void)onResp:(BaseResp *)resp

{
    NSString *payResoult = [NSString stringWithFormat:@"%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        if([payResoult isEqualToString:@"0"])
        {
            NSNotification * notice = [NSNotification notificationWithName:@"paysuccess" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"支付结果：成功！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            
//            [alertview show];
            
        }
        else if([payResoult isEqualToString:@"-1"])
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"支付失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if([payResoult isEqualToString:@"-2"])
        {
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"用户已经退出支付！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
              UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"取消支付" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"支付失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
        }
        
    }
    
    
    else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        
        
        
        if([payResoult isEqualToString:@"0"])
        {
            
//            UIAlertController *alartView = [UIAlertController alertControllerWithTitle:nil message:@"成功" preferredStyle:(UIAlertControllerStyleAlert)];
//            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [alartView addAction:sureAction];
            
            
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            [alertview show];
            
            //分享成功给后台反馈
            //目前等回台的接口
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadNotice:) name:@"sendShare" object:nil];
            
            
            
            
            
            
        }else if([payResoult isEqualToString:@"-2"])
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"分享已取消" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else
        {
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"分享成功1" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
            
        }
        
    }
}

//-(void)downLoadNotice:(NSNotification*)notice{
//    NSString *typeString = notice.userInfo[@"shareType"];
//    NSLog(@"通知%@",typeString);
//    if ([typeString isEqualToString:@"1"]) {
//        //分享客户端
//        NSLog(@"客户端");
//        NSString *sendCode = notice.userInfo[@"sendCode"];
//        NSDictionary *mulDic = @{
//                                 @"Account_Id":[UdStorage getObjectforKey:Userid],
//                                 @"ShareType":@3,
//                                 @"InvitationCcode":sendCode
//                                 };
//        NSDictionary *params = @{
//                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
//                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
//                                 };
//        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@InviteShare/UserShareSuccess",Khttp] success:^(NSDictionary *dict, BOOL success) {
//            NSLog(@"~~~~~~~~~~~%@",dict);
//        } fail:^(NSError *error) {
//            NSLog(@"%@",error);
//        }];
//        //清楚通知
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendShare" object:nil];
//    }else{
//        //分享小积分
//        NSLog(@"小积分");
//        //清楚通知
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendShare" object:nil];
//    }
//}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
