//
//  LKAlertView.m
//  Super
//
//  Created by wyf on 15/9/21.
//  Copyright © 2015年 wyf. All rights reserved.
//

#import "LKAlertView.h"
#import "AppDelegate.h"
@interface LKAlertView ()
@property (nonatomic,assign) id <LKAlertViewDelegate> delegate;
@property (nonatomic,strong) UIButton *blackButton;
@end

@implementation LKAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id <LKAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    //一个按钮：cancelButtonTitle有值
    //两个按钮：cancelButtonTitle、otherButtonTitles有值
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        self.frame = [AppDelegate sharedInstance].window.bounds;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        UIButton *button = [UIUtil drawButtonInView:self frame:self.bounds iconName:@"" target:self action:@selector(clickHide)];
        self.blackButton = button;
        button.backgroundColor = [UIColor blackColor];
        
        button.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            button.alpha = 0.3;
        }];
        
        float alertViewWidth = self.width*0.76;
        
        UILabel *messageLabel = [UIUtil getLabelMutiLineWithFrame:CGRectMake(0, 0, alertViewWidth-18*2, 0) font:[UIFont systemFontOfSize:18] text:message isCenter:NO color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
        float height = 26*2+messageLabel.height+46;
        
        UILabel *titleLabel;
        if (title.length > 0) {
            titleLabel = [UIUtil getLabelMutiLineWithFrame:CGRectMake(0, 0, alertViewWidth-18*2, 0) font:[UIFont boldSystemFontOfSize:20] text:title isCenter:YES color:[UIColor blackColor]];
            
            height += titleLabel.height+10;
        }
        
        
        UIView *whiteView = [UIUtil drawLineInView:self frame:CGRectMake((self.width-alertViewWidth)/2, (self.height-height)/2, alertViewWidth, height) color:[UIColor whiteColor]];
        whiteView.userInteractionEnabled = YES;
        whiteView.layer.cornerRadius = 10;
        
        if (title.length > 0) {
            titleLabel = [UIUtil drawLabelMutiLineInView:whiteView frame:CGRectMake(18, 26, whiteView.width-18*2, 0) font:[UIFont boldSystemFontOfSize:20] text:title isCenter:YES color:[UIColor blackColor]];

            messageLabel = [UIUtil drawLabelMutiLineInView:whiteView frame:CGRectMake(18, titleLabel.bottom+10, whiteView.width-18*2, 0) font:[UIFont systemFontOfSize:18] text:message isCenter:NO color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
            
        } else {
            messageLabel = [UIUtil drawLabelMutiLineInView:whiteView frame:CGRectMake(18, 26, whiteView.width-18*2, 0) font:[UIFont systemFontOfSize:18] text:message isCenter:NO color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];

        }
        messageLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *line = [UIUtil drawLineInView:whiteView frame:CGRectMake(18, messageLabel.bottom+26, whiteView.width-18*2, [UIUtil lineWidth]) color:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
        
        if (otherButtonTitles.length > 0) {
            button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, line.bottom, whiteView.width/2, 46) text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] target:self action:@selector(clickCancelButton)];
//            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
            button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(whiteView.width/2, line.bottom, whiteView.width/2, 46) text:otherButtonTitles font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHex:0x115D91 alpha:1.0] target:self action:@selector(clickOtherButton)];
//            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
            [UIUtil drawLineInView:whiteView frame:CGRectMake(whiteView.width/2, line.bottom+(46-30)/2, [UIUtil lineWidth], 30) color:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
        } else {
            button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, line.bottom, whiteView.width, 46) text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHex:0x115D91 alpha:1.0] target:self action:@selector(clickCancelButton)];
//            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        }
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title messageTextAlignmentLeft:(NSString *)textAlignmentLeftmessage delegate:(id <LKAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        self.frame = [AppDelegate sharedInstance].window.bounds;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        UIButton *button = [UIUtil drawButtonInView:self frame:self.bounds iconName:@"" target:self action:@selector(clickHide)];
        self.blackButton = button;
        button.backgroundColor = [UIColor blackColor];
        
        button.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            button.alpha = 0.3;
        }];
        
        float alertViewWidth = self.width*0.76;
        
        UILabel *messageLabel = [UIUtil getLabelMutiLineWithFrame:CGRectMake(0, 0, alertViewWidth-18*2, 0) font:[UIFont systemFontOfSize:18] text:textAlignmentLeftmessage isCenter:NO color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
        float height = 26*2+messageLabel.height+46;
        
        UILabel *titleLabel;
        if (title.length > 0) {
            titleLabel = [UIUtil getLabelMutiLineWithFrame:CGRectMake(0, 0, alertViewWidth-18*2, 0) font:[UIFont boldSystemFontOfSize:20] text:title isCenter:YES color:[UIColor blackColor]];
            
            height += titleLabel.height+10;
        }
        
        
        UIView *whiteView = [UIUtil drawLineInView:self frame:CGRectMake((self.width-alertViewWidth)/2, (self.height-height)/2, alertViewWidth, height) color:[UIColor whiteColor]];
        whiteView.userInteractionEnabled = YES;
        whiteView.layer.cornerRadius = 10;
        
        if (title.length > 0) {
            titleLabel = [UIUtil drawLabelMutiLineInView:whiteView frame:CGRectMake(18, 26, whiteView.width-18*2, 0) font:[UIFont boldSystemFontOfSize:20] text:title isCenter:YES color:[UIColor blackColor]];
            
            messageLabel = [UIUtil drawLabelMutiLineInView:whiteView frame:CGRectMake(18, titleLabel.bottom+10, whiteView.width-18*2, 0) font:[UIFont systemFontOfSize:18] text:textAlignmentLeftmessage isCenter:NO color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
            
        } else {
            messageLabel = [UIUtil drawLabelMutiLineInView:whiteView frame:CGRectMake(18, 26, whiteView.width-18*2, 0) font:[UIFont systemFontOfSize:18] text:textAlignmentLeftmessage isCenter:NO color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
            
        }
        messageLabel.textAlignment = NSTextAlignmentLeft;
        
        UIView *line = [UIUtil drawLineInView:whiteView frame:CGRectMake(18, messageLabel.bottom+26, whiteView.width-18*2, [UIUtil lineWidth]) color:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
        
        if (otherButtonTitles.length > 0) {
            button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, line.bottom, whiteView.width/2, 46) text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] target:self action:@selector(clickCancelButton)];
            //            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
            button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(whiteView.width/2, line.bottom, whiteView.width/2, 46) text:otherButtonTitles font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHex:0x115D91 alpha:1.0] target:self action:@selector(clickOtherButton)];
            //            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
            [UIUtil drawLineInView:whiteView frame:CGRectMake(whiteView.width/2, line.bottom+(46-30)/2, [UIUtil lineWidth], 30) color:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
        } else {
            button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, line.bottom, whiteView.width, 46) text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHex:0x115D91 alpha:1.0] target:self action:@selector(clickCancelButton)];
            //            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        }
    }
    return self;
    
}
- (void)show
{
    [[AppDelegate sharedInstance].window addSubview:self];
    
}

- (void)clickHide
{
    //点击半透明不消失
}

- (void)clickCancelButton
{
    if (self.delegate)
    {
        if ([self.delegate conformsToProtocol: @protocol (LKAlertViewDelegate)])
        {
            if ([self.delegate respondsToSelector: @selector (alertView:clickedButtonAtIndex:)])
            {
                [self.delegate alertView: self clickedButtonAtIndex: 0];
            }
        }
    }
    
    [self removeFromSuperview];
    
}

- (void)clickOtherButton
{
    if (self.delegate) {
        [self.delegate alertView:self clickedButtonAtIndex:1];
    }
    
    [self removeFromSuperview];
    
}

@end
