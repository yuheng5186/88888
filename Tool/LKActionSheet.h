//
//  LKActionSheet.h
//  Super
//
//  Created by wyf on 15/9/22.
//  Copyright © 2015年 wyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKActionSheet;

@protocol LKActionSheetDelegate <NSObject>

- (void)actionSheet:(LKActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface LKActionSheet : UIView
- (instancetype)initWithTitle:(NSString *)title delegate:(id<LKActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (void)showInView:(UIView *)view;

@end
