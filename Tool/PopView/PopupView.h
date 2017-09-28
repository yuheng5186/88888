//
//  PopupView.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/9.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView
@property (strong, nonatomic) IBOutlet PopupView *innerView;

@property (nonatomic, weak)UIViewController *parentVC;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)defaultPopupView;

@end
