//
//  BaseController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/19.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController

@property (nonatomic,strong) UIView *statusView;
@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) BOOL isSubmitLoading;

@property (nonatomic, strong) NSString *navTitle;

- (UIButton *)drawBackButtonWithAction:(SEL)action;
- (UILabel *)drawTitle:(NSString *)title;
- (UILabel *)drawTitle:(NSString *)title Color: (UIColor *) color;
- (UIButton *)drawLeftTextButton:(NSString *)text action:(SEL)action;
- (UIButton *)drawLeftImageButton:(NSString *)imageName action:(SEL)action;
- (UIButton *)drawRightTextButton:(NSString *)text action:(SEL)action;
- (UIButton *)drawRightImageButton:(NSString *)imageName action:(SEL)action;
- (void)showBlackLoading;
- (void)hideBlackLoading;
- (void)showAlert:(NSString *)alert;
- (void)showTipWithSecond:(int)second tip:(NSString *)tip;
- (void)drawNavigation;
- (void)drawContent;
- (void)clickBack;

- (void)loadWithData:(id)data;

@end
