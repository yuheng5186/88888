//
//  BlackLoadingView.m
//  Links
//
//  Created by zeppo on 14-5-16.
//  Copyright (c) 2015年 zhengpeng. All rights reserved.
//

#import "BlackLoadingView.h"

@interface BlackLoadingView ()
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) UILabel *loadingLabel;
@end

@implementation BlackLoadingView

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.center = CGPointMake(self.width/2, 35);
        _activityIndicatorView.backgroundColor = [UIColor clearColor];
        [_activityIndicatorView startAnimating];
    }
    return _activityIndicatorView;
}

- (UILabel *)loadingLabel
{
    if (!_loadingLabel) {
        _loadingLabel = [UIUtil getLabelWithFrame:CGRectMake(0, 65, self.width, 20) font:[UIFont systemFontOfSize:14] text:NSLocalizedString(@"Waiting", nil) isCenter:YES color:[UIColor colorWithHex:0xcccccc alpha:1]];
        
    }
    return _loadingLabel;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 100, 100);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        self.layer.cornerRadius = 6;
        [self addSubview:self.activityIndicatorView];
        [self addSubview:self.loadingLabel];
    }
    return self;
}

@end
