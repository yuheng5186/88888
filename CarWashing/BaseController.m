//
//  BaseController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/19.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"

#import "BlackLoadingView.h"
#define DefaultBtnTag 9001
#define DefaultNavLeftBtnTag 9002
#define DefaultNavRightBtnTag 9003
#define DefaultNavTitleLblTag 9004
#import "LoginViewController.h"
@interface BaseController ()

@property (nonatomic,strong) UIView *blackLoadingView;
@property (nonatomic,strong) UIImageView *tipImageView;
//
@end

@implementation BaseController

- (void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)statusView
{
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        _statusView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView  = [[UIImageView alloc]initWithFrame:_statusView.frame];
        imageView.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
//        imageView.image     = [UIImage imageNamed:@"ijanbiantiao"];
        [_statusView addSubview:imageView];
    }
    return _statusView;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
        _navigationView.backgroundColor = self.statusView.backgroundColor;
        _navigationView.userInteractionEnabled = YES;
        UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
//        imageView.image     = [UIImage imageNamed:@"ijanbiantiao"];
        imageView.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
        [_navigationView addSubview:imageView];
        
        if (self.navigationController.viewControllers.count > 1)
        {
            UIButton *button = [self drawBackButtonWithAction:@selector(clickBack)];
            button.tag = DefaultBtnTag;
        }
    }
    return _navigationView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        float contentViewTop = 64;
        float contentViewHeight;
        if (self.hidesBottomBarWhenPushed) {
            contentViewHeight = Main_Screen_Height-self.statusView.frame.size.height-self.navigationView.frame.size.height;
        } else {
            contentViewHeight = Main_Screen_Height-self.statusView.frame.size.height-self.navigationView.frame.size.height-self.tabBarController.tabBar.frame.size.height;
        }
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewTop, self.view.frame.size.width, contentViewHeight)];
        _contentView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        _contentView.userInteractionEnabled = YES;
        //        [UIUtil drawLineInView:_contentView frame:CGRectMake(0, 0, 0, 0) color:[UIColor clearColor]];
    }
    return _contentView;
}

- (UIView *)blackLoadingView
{
    if (!_blackLoadingView) {
        _blackLoadingView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _blackLoadingView.backgroundColor = [UIColor clearColor];
        
        //        BlackLoadingView *loadingView = [[BlackLoadingView alloc] init];
        //        loadingView.center = CGPointMake(_blackLoadingView.width/2, _blackLoadingView.height/2);
        //        [_blackLoadingView addSubview:loadingView];
    }
    return _blackLoadingView;
}

- (void)loadWithData:(id)data {
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.statusView];
    [self.view addSubview:self.navigationView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass: LoginViewController.class])
        {
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

        }
    }
    
    
    [self drawNavigation];
    [self drawContent];
}

- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawNavigation{
    //派生类需重写
}

- (void)drawContent
{
    //派生类需重写
}

- (UIButton *)drawBackButtonWithAction:(SEL)action
{
    [[self.navigationView viewWithTag:DefaultBtnTag] removeFromSuperview];
    float imageWidth = [UIImage imageNamed:@"icon_titlebar_arrow"].size.width;
    UIButton *button =  [UIUtil drawButtonInView:self.navigationView frame:CGRectMake(0, 0, 50, self.navigationView.frame.size.height) iconName:@"icon_titlebar_arrow" target:self action:action];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, button.frame.size.width-10*2-imageWidth);
    return button;
}


- (UILabel *)drawTitle:(NSString *)title
{
    UIColor *color = [UIColor colorWithHex:0xffffff alpha:1.0];//[UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
    
    return [self drawTitle: title Color: color];
}

- (UILabel *)drawTitle:(NSString *)title Color: (UIColor *) color
{
    [[self.navigationView viewWithTag:DefaultNavTitleLblTag] removeFromSuperview];
    UILabel *lbl = [UIUtil drawLabelInView:self.navigationView frame:CGRectMake(self.navigationView.frame.size.width/5, 0, self.navigationView.frame.size.width*3/5, self.navigationView.frame.size.height) font:[UIFont boldSystemFontOfSize:18] text:title isCenter:YES color: color];
    lbl.tag = DefaultNavTitleLblTag;
    return lbl;
}

- (UIButton *)drawLeftTextButton:(NSString *)text action:(SEL)action
{
    [[self.navigationView viewWithTag:DefaultBtnTag] removeFromSuperview];
    float textWidth = [UIUtil textWidth:text font:[UIFont systemFontOfSize:16]];
    UIButton *button = [UIUtil drawButtonInView:self.navigationView frame:CGRectMake(0, 0, textWidth+18, self.navigationView.frame.size.height) text:text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] target:self action:action];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}
- (UIButton *)drawLeftImageButton:(NSString *)imageName action:(SEL)action
{
    [[self.navigationView viewWithTag:DefaultNavLeftBtnTag] removeFromSuperview];
    float imageWidth = [UIImage imageNamed:imageName].size.width;
    UIButton *button =  [UIUtil drawButtonInView:self.navigationView frame:CGRectMake(0, 0, 50, self.navigationView.frame.size.height) iconName:imageName target:self action:action];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width-9*2-imageWidth, 0, 0);
    button.tag = DefaultNavLeftBtnTag;
    return button;
}

- (UIButton *)drawRightImageButton:(NSString *)imageName action:(SEL)action
{
    [[self.navigationView viewWithTag:DefaultNavRightBtnTag] removeFromSuperview];
    float imageWidth = [UIImage imageNamed:imageName].size.width;
    UIButton *button =  [UIUtil drawButtonInView:self.navigationView frame:CGRectMake(self.navigationView.frame.size.width-50, 0, 50, self.navigationView.frame.size.height) iconName:imageName target:self action:action];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width-9*2-imageWidth, 0, 0);
    button.tag = DefaultNavRightBtnTag;
    return button;
}

- (UIButton *)drawRightTextButton:(NSString *)text action:(SEL)action
{
    [[self.navigationView viewWithTag:DefaultNavRightBtnTag] removeFromSuperview];
    float textWidth = [UIUtil textWidth:text font:[UIFont systemFontOfSize:16]];
    UIButton *button = [UIUtil drawButtonInView:self.navigationView frame:CGRectMake(self.navigationView.frame.size.width-9-textWidth-9, 0, textWidth+18, self.navigationView.frame.size.height) text:text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] target:self action:action];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = DefaultNavRightBtnTag;
    return button;
}


- (void)showBlackLoading
{
    self.isSubmitLoading = YES;
    if (!self.blackLoadingView.superview) {
        [self.contentView addSubview:self.blackLoadingView];
    }
}

- (void)hideBlackLoading
{
    self.isSubmitLoading = NO;
    [self.blackLoadingView removeFromSuperview];
}

- (void)showAlert:(NSString *)alert
{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alert delegate:nil cancelButtonTitle: NSLocalizedString (@"Confirm", @"Confirm") otherButtonTitles:nil, nil];
    //    [alertView show];
    
    //    UIAlertController *alertView    = [UIAlertController alertControllerWithTitle:nil message:alert preferredStyle:UIAlertControllerStyleAlert];
    
}

- (void)hideTip
{
    [UIView animateWithDuration:0.2 animations:^(void){
        self.tipImageView.alpha = 0;
    } completion:^(BOOL finished){
        [self.tipImageView removeFromSuperview];
    }];
}

- (void)showTipWithSecond:(int)second tip:(NSString *)tip
{
    if (self.tipImageView) {
        [self.tipImageView removeFromSuperview];
    }
    
    float width = [UIUtil textWidth:tip font:[UIFont systemFontOfSize:12]]+8;
    self.tipImageView = [UIUtil getCustomImgViewWithFrame:CGRectMake((self.contentView.frame.size.width-width)/2, self.contentView.frame.size.height, width, 22.5) imageName:@"GreyStatusBox.png" capInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.contentView addSubview:self.tipImageView];
    
    [UIUtil drawLabelInView:self.tipImageView frame:self.tipImageView.bounds font:[UIFont systemFontOfSize:12] text:tip isCenter:YES color:[UIColor whiteColor]];
    
    [UIView animateWithDuration:0.2 animations:^(void){
        self.tipImageView.top -= 22.5+10;
    } completion:^(BOOL finished){
        [self performSelector:@selector(hideTip) withObject:nil afterDelay:second];
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
