//
//  UIView+BFSToastInfo.h
//  BIFService
//
//  Created by wyf on 15/12/4.
//  Copyright (c) 2015年 wyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BFSToastInfo)
- (void)hideLoadWithAnimated:(BOOL)animated;
- (void)showLoadWithAnimated:(BOOL)animated;
- (void)showLoadingActivity:(BOOL)activity;
- (void)showInfo:(NSString *)info;
- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset;
- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font;
- (void)showInfo:(NSString *)info activity:(BOOL)activity;
@end
