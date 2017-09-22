//
//  PopHelpView.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopHelpView : UIView

@property (strong, nonatomic) IBOutlet PopHelpView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *helpTitleLabel;
@property (nonatomic, weak)UIViewController *parentVC;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic,strong) NSString  *titleLabel;
@property (nonatomic,strong) NSString  *contentShowLabel;


+ (instancetype)defaultPopHelpView:(NSString *)string;
- (id)initWithFrame:(CGRect)frame string:(NSString *)string;
@end
