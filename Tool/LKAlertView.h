//
//  LKAlertView.h
//  Super
//
//  Created by wyf on 15/9/21.
//  Copyright © 2015年 wyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKAlertView;

@protocol LKAlertViewDelegate <NSObject>

- (void)alertView:(LKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface LKAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id <LKAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (instancetype)initWithTitle:(NSString *)title messageTextAlignmentLeft:(NSString *)textAlignmentLeftmessage delegate:(id <LKAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)show;
@end
