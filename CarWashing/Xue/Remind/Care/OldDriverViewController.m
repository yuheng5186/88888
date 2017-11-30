//
//  OldDriverViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/15.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "OldDriverViewController.h"
#import <WebKit/WebKit.h>

@interface OldDriverViewController ()
@property(strong,nonatomic)UIImageView *fakeNavigation;
@property(strong,nonatomic)UIScrollView *showWebView;
@end

@implementation OldDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fakeNavigation];
    [self.view addSubview:self.showWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
-(UIImageView *)fakeNavigation{
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
//        _fakeNavigation.image = [UIImage imageNamed:@"ijanbiantiao"];
        _fakeNavigation.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
        _fakeNavigation.userInteractionEnabled = YES;
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"保养经验";
        fakeTitle.font = [UIFont systemFontOfSize:18 weight:18];
        fakeTitle.textColor = [UIColor whiteColor];
        fakeTitle.textAlignment = NSTextAlignmentCenter;
        [_fakeNavigation addSubview:fakeTitle];
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 32, 19, 19)];
        backImageView.image = [UIImage imageNamed:@"icon_titlebar_arrow"];
        backImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_fakeNavigation addSubview:backImageView];
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 66)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_fakeNavigation addSubview:backButton];
    }
    return _fakeNavigation;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIScrollView *)showWebView{
    if (!_showWebView) {
        _showWebView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 66, Main_Screen_Width, Main_Screen_Height-66)];
        _showWebView.showsVerticalScrollIndicator = NO;
        _showWebView.contentSize = CGSizeMake(Main_Screen_Width, 1000);
        UIImageView *imageViewInSide = [[UIImageView alloc]initWithFrame:CGRectMake(0, 66, Main_Screen_Width, Main_Screen_Height)];
        imageViewInSide.image = [UIImage imageNamed:@"保养小知识轻轻松松做保养"];
        imageViewInSide.contentMode = UIViewContentModeScaleAspectFill;
        [_showWebView addSubview:imageViewInSide];
    }
    return _showWebView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
