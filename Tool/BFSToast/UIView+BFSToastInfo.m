//
//  UIView+BFSToastInfo.m
//  BIFService
//
//  Created by wyf on 15/12/4.
//  Copyright (c) 2015年 wyf. All rights reserved.
//

#import "UIView+BFSToastInfo.h"
#import "MBProgressHUD.h"

@implementation UIView (BFSToastInfo)
- (void)hideLoadWithAnimated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self animated:animated];
}

- (void)showLoadWithAnimated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
    hud.labelText = NSLocalizedString (@"Loading...", @"Loading...");
}

- (void)showLoadingActivity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = NSLocalizedString (@"Loading...", @"Loading...");;
}

- (void)showInfo:(NSString *)info{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = info;
    
    [hud hide:YES afterDelay:2];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide {
    [self showInfo:info image:icon autoHidden:autoHide interval:1.5];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds{
    [self showInfo:info image:icon autoHidden:autoHide interval:seconds yOffset:0];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide{
    [self showInfo:info image:nil autoHidden:autoHide];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset{
    [self showInfo:info image:nil autoHidden:autoHide interval:1.5 yOffset:yOffset];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds {
    [self showInfo:info image:Nil autoHidden:autoHide interval:seconds];
}

- (void)showInfo:(NSString *)info activity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:activity];
    hud.labelText = [NSString stringWithFormat:@"%@",info];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font
{
    [self showInfo:info image:icon autoHidden:autoHide interval:1.5 yOffset:0 font:font];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds yOffset:(int)yOffset{
    [self showInfo:info image:icon autoHidden:autoHide interval:seconds yOffset:yOffset font:nil];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds yOffset:(int)yOffset font:(UIFont *)font{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    
    [self addSubview:hud];
    
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:icon];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabelFont = hud.labelFont;
    hud.detailsLabelText = info;
    if (yOffset != 0) {
        hud.yOffset = yOffset;
    }
    if (font) {
        hud.labelFont = font;
    }
    
    [hud show:YES];
    if (autoHide) {
        [hud hide:YES afterDelay:(seconds > 0 ? seconds : 1.5)];
    }
}
@end
