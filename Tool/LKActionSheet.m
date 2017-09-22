//
//  LKActionSheet.m
//  Super
//
//  Created by wyf on 15/9/22.
//  Copyright © 2015年 wyf. All rights reserved.
//

#import "LKActionSheet.h"
#import "AppDelegate.h"

@interface LKActionSheet ()
@property (nonatomic,assign) id <LKActionSheetDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *mutableArray;
@property (nonatomic,strong) UIButton *blackButton;
@property (nonatomic,strong) UIView *actionWhiteView;
@property (nonatomic,strong) UIView *cancelWhiteView;

@end

@implementation LKActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LKActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    //cancelButtonTitle有值
    //destructiveButtonTitle有值 或者 otherButtonTitles有值
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        self.frame = [AppDelegate sharedInstance].window.bounds;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        UIButton *button = [UIUtil drawButtonInView:self frame:self.bounds iconName:@"" target:self action:@selector(clickHide)];
        self.blackButton = button;
        button.backgroundColor = [UIColor blackColor];
        
        if (destructiveButtonTitle.length > 0) {
            
            if (title.length > 0) {
                float height = 32+46;
                
                UIView *whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height+32+46+10, self.width-10*2, 46) color:[UIColor whiteColor]];
                self.cancelWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;
                
                button = [UIUtil drawButtonInView:whiteView frame:whiteView.bounds text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] target:self action:@selector(clickCancelButton:)];
                button.tag = 1;
//                [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                
                whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height, self.width-10*2, height) color:[UIColor whiteColor]];
                self.actionWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;
                whiteView.clipsToBounds = YES;
                
                [UIUtil drawLineInView:whiteView frame:CGRectMake(0, 0, whiteView.width, 32) color:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]];
                
                [UIUtil drawLabelInView:whiteView frame:CGRectMake(0, 0, whiteView.width, 32) font:[UIFont systemFontOfSize:14] text:title isCenter:YES color:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1]];
                
                button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, 32, whiteView.width, 46) text:destructiveButtonTitle font:[UIFont systemFontOfSize:20] color:[UIColor colorFromHex:@"#0161a1"] target:self action:@selector(clickDestructiveButton)];
//                [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                
                self.blackButton.alpha = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.blackButton.alpha = 0.3;
                    self.cancelWhiteView.top = self.height-10-46;
                    self.actionWhiteView.top = self.height-10-46-10-height;
                }];
                
                
            } else {
                float height = 46;
                
                UIView *whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height+46+10, self.width-10*2, 46) color:[UIColor whiteColor]];
                self.cancelWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;
                
                button = [UIUtil drawButtonInView:whiteView frame:whiteView.bounds text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] target:self action:@selector(clickCancelButton:)];
                button.tag = 1;
//                [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                
                whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height, self.width-10*2, height) color:[UIColor whiteColor]];
                self.actionWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;

                button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, 0, whiteView.width, 46) text:destructiveButtonTitle font:[UIFont systemFontOfSize:20] color:[UIColor colorFromHex:@"#0161a1"] target:self action:@selector(clickDestructiveButton)];
//                [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                
                self.blackButton.alpha = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.blackButton.alpha = 0.3;
                    self.cancelWhiteView.top = self.height-10-46;
                    self.actionWhiteView.top = self.height-10-46-10-height;
                }];
            }

            
        } else {
            
            NSMutableArray *mutableArray = [NSMutableArray array];
            [mutableArray addObject:otherButtonTitles];
            
            NSString *buttonTitle;
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);
            
            while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
                [mutableArray addObject:buttonTitle];
            }
            
            va_end(argumentList);

            if (title.length > 0) {
                float height = 32+mutableArray.count*46;
                
                UIView *whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height+32+mutableArray.count*46+10, self.width-10*2, 46) color:[UIColor whiteColor]];
                self.cancelWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;
                
                button = [UIUtil drawButtonInView:whiteView frame:whiteView.bounds text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] target:self action:@selector(clickCancelButton:)];
                button.tag = mutableArray.count;
//                [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                
                whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height, self.width-10*2, height) color:[UIColor whiteColor]];
                self.actionWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;
                whiteView.clipsToBounds = YES;
                
                [UIUtil drawLineInView:whiteView frame:CGRectMake(0, 0, whiteView.width, 32) color:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]];
                
                [UIUtil drawLabelInView:whiteView frame:CGRectMake(0, 0, whiteView.width, 32) font:[UIFont systemFontOfSize:14] text:title isCenter:YES color:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1]];
                
                
                for (int i = 0; i < mutableArray.count; i++) {
                    if (i != 0) {
                        [UIUtil drawLineInView:whiteView frame:CGRectMake(18, 32+i*46, whiteView.width-18*2, [UIUtil lineWidth]) color:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
                    }
                    button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, 32+i*46, whiteView.width, 46) text:mutableArray[i] font:[UIFont systemFontOfSize:20] color:[UIColor colorFromHex:@"#0161a1"] target:self action:@selector(clickOtherButton:)];
                    button.tag = i;
//                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                }
                
                self.blackButton.alpha = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.blackButton.alpha = 0.3;
                    self.cancelWhiteView.top = self.height-10-46;
                    self.actionWhiteView.top = self.height-10-46-10-height;
                }];

                
                
            } else {
                float height = mutableArray.count*46;
                
                UIView *whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height+mutableArray.count*46+10, self.width-10*2, 46) color:[UIColor whiteColor]];
                self.cancelWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;
                
                button = [UIUtil drawButtonInView:whiteView frame:whiteView.bounds text:cancelButtonTitle font:[UIFont systemFontOfSize:18] color:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] target:self action:@selector(clickCancelButton:)];
                button.tag = mutableArray.count;
//                [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                
                whiteView = [UIUtil drawLineInView:self frame:CGRectMake(10, self.height, self.width-10*2, height) color:[UIColor whiteColor]];
                self.actionWhiteView = whiteView;
                whiteView.userInteractionEnabled = YES;
                whiteView.layer.cornerRadius = 10;
                
                
                for (int i = 0; i < mutableArray.count; i++) {
                    if (i != 0) {
                        [UIUtil drawLineInView:whiteView frame:CGRectMake(18, i*46, whiteView.width-18*2, [UIUtil lineWidth]) color:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
                    }
                    button = [UIUtil drawButtonInView:whiteView frame:CGRectMake(0, i*46, whiteView.width, 46) text:mutableArray[i] font:[UIFont systemFontOfSize:20] color:[UIColor colorFromHex:@"#0161a1"] target:self action:@selector(clickOtherButton:)];
                    button.tag = i;
//                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                }
                
                self.blackButton.alpha = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.blackButton.alpha = 0.3;
                    self.cancelWhiteView.top = self.height-10-46;
                    self.actionWhiteView.top = self.height-10-46-10-height;
                }];
            }
            
            
            
        }
        
        
    }
    return self;
}

- (void)clickHide
{
    float height = self.actionWhiteView.height+10+self.cancelWhiteView.height+10;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.blackButton.alpha = 0;
        self.cancelWhiteView.top += height;
        self.actionWhiteView.top += height;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    
}

- (void)clickDestructiveButton
{
    if (self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
    [self clickHide];
}

- (void)clickOtherButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:button.tag];
    }
    [self clickHide];
}


- (void)clickCancelButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:button.tag];
    }
    [self clickHide];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
}


@end
