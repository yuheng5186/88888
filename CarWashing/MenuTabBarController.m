//
//  MenuTabBarController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/19.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MenuTabBarController.h"

#import "HomeViewController.h"
#import "BusinessViewController.h"
#import "FindViewController.h"
#import "PurchaseViewController.h"
#import "MySettingViewController.h"

#import "LoginViewController.h"
#import "DSScanController.h"
#import "UdStorage.h"
#import "DSStartWashingController.h"
@interface MenuTabBarController ()

@property (nonatomic, strong)     UIImageView *imageView;

@end

@implementation MenuTabBarController


- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    
    UIImage *centerImage = [UIImage imageNamed:@"xiche"];
    
    [self addCenterButtonWithImage:centerImage highlightImage: nil];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationControllers];
    


    BOOL firstRun = [[[NSUserDefaults standardUserDefaults]valueForKey:@"firstRun"] boolValue];

    if (!firstRun) {
//        [self addGuideView];

        [[NSUserDefaults standardUserDefaults]setValue:@YES forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)addGuideView {
    NSString *imageName = @"qw";
    
    UIImage *image = [UIImage imageNamed:imageName];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = self.view.bounds;
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView)];
    [self.imageView addGestureRecognizer:tap];
    
    [self.view addSubview:self.imageView];
}
- (void) dismissGuideView{
    
    [self.imageView removeFromSuperview];
}


//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear: animated];
//    
//    LoginViewController *loginController    = [[LoginViewController alloc]init];
//    UINavigationController *navController   = [[UINavigationController alloc]initWithRootViewController:loginController];
//    navController.navigationBar.hidden      = YES;
//    
//    [self presentViewController:navController animated:YES completion:nil];
//    
//}
- (void) createNavigationControllers
{
    
    
    HomeViewController *homeVC      = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNav.navigationController.navigationBarHidden = YES;
    UITabBarItem *homeTabItem       = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"shouye"] selectedImage:[UIImage imageNamed:@"shouye1"]];
    homeTabItem.tag     = 1;
    homeVC.tabBarItem   = homeTabItem;
    
    BusinessViewController *businessVC      = [[BusinessViewController alloc]init];
    UINavigationController *businessNav = [[UINavigationController alloc]initWithRootViewController:businessVC];
    businessNav.navigationController.navigationBarHidden = YES;
    UITabBarItem *businessTabItem       = [[UITabBarItem alloc]initWithTitle:@"商家" image:[UIImage imageNamed:@"shangjia"] selectedImage:[UIImage imageNamed:@"shangjia1"]];
    businessTabItem.tag     = 2;
    businessVC.tabBarItem   = businessTabItem;
    
    DSScanController *activityVC      = [[DSScanController alloc]init];
    UINavigationController *activityNav = [[UINavigationController alloc]initWithRootViewController:activityVC];
    activityNav.navigationController.navigationBarHidden = YES;
    UITabBarItem *activityTabItem       = [[UITabBarItem alloc]initWithTitle:@"洗车" image:[UIImage imageNamed:@"wode"] selectedImage:[UIImage imageNamed:@"wode"]];
    activityTabItem.tag     = 3;
    activityVC.tabBarItem   = activityTabItem;
    
    PurchaseViewController *purchaseVC      = [[PurchaseViewController alloc]init];
    UINavigationController *purchaseNav = [[UINavigationController alloc]initWithRootViewController:purchaseVC];
    purchaseNav.navigationController.navigationBarHidden = YES;
    UITabBarItem *purchaseTabItem       = [[UITabBarItem alloc]initWithTitle:@"购卡" image:[UIImage imageNamed:@"gouka"] selectedImage:[UIImage imageNamed:@"gouka1"]];
    purchaseTabItem.tag     = 4;
    purchaseVC.tabBarItem   = purchaseTabItem;
    
    MySettingViewController *mySettingVC      = [[MySettingViewController alloc]init];
    UINavigationController *mySettingNav = [[UINavigationController alloc]initWithRootViewController:mySettingVC];
    mySettingNav.navigationController.navigationBarHidden = YES;
//    mySettingNav.navigationBar.hidden    = YES;
    UITabBarItem *mySettingTabItem       = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"wode"] selectedImage:[UIImage imageNamed:@"wode1"]];
    mySettingTabItem.tag     = 5;
    mySettingVC.tabBarItem   = mySettingTabItem;
    
    
    self.viewControllers     = @[homeNav,businessNav,activityNav,purchaseNav,mySettingNav];
    
    //    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake (0, 0, Main_Screen_Width, 49)];
    //    backView.backgroundColor = [UIColor colorWithHex:0x111112 alpha:1.0];
    //    [self.tabBar insertSubview:backView atIndex:0];
    //    self.tabBar.opaque = YES;
    
}

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, 60, 60);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(didSelectRouterAction) forControlEvents:UIControlEventTouchUpInside];
    button.centerX = Main_Screen_Width/2;
    button.centerY = 5;
    [self.tabBar addSubview:button];
}
- (void)didSelectRouterAction {
    
           self.selectedViewController = self.viewControllers[2];
   
}

@end
