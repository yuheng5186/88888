//
//  DSNavigationViewController.m
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/9/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSNavigationViewController.h"

@interface DSNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation DSNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)initialize
{
    
    UIBarButtonItem *barbutitem=[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *attrdic=[NSMutableDictionary dictionary];
    attrdic[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrdic[NSFontAttributeName]=[UIFont systemFontOfSize:18 weight:10];
    [barbutitem setTintColor:[UIColor whiteColor]];
    //设置模型的字体颜色用富文本
    [barbutitem setTitleTextAttributes:attrdic forState:UIControlStateNormal];
    UINavigationBar *bar=[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    [bar setBackgroundImage:[UIImage imageNamed:@"ijanbiantiao"] forBarMetrics:UIBarMetricsDefault];
    [bar setTintColor:[UIColor whiteColor]];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if (self.viewControllers.count != 0)
    //    {
    //        UIBarButtonItem *barbut=[UIBarButtonItem setUibarbutonimgname:@"icon_titlebar_arrow" andhightimg:@"icon_titlebar_arrow" Target:self action:@selector(backpop) forControlEvents:UIControlEventTouchUpInside];
    //
    //        [super pushViewController:viewController animated:animated];
    //         self.navigationItem.leftBarButtonItem = barbut;
    //    }
    [super pushViewController:viewController animated:animated];
}
-(void)backpop
{
    if (self.navigationController.viewControllers.count>1) {
        [self popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)backroot
{
    [self popToRootViewControllerAnimated:YES];
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
