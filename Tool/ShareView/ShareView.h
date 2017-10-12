//
//  ShareView.h
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView
@property (nonatomic , copy) NSString *url;
@property (nonatomic ,strong) NSString *imagename;
@property (nonatomic ,strong) NSString *titlename;
@property (nonatomic ,strong) NSString *desc;
@property (weak, nonatomic) IBOutlet UIButton *sinaBten;
@property (weak, nonatomic) IBOutlet UIButton *qZoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *pyqBtn;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
- (IBAction)sinaShare;
- (IBAction)qZoneShare;
- (IBAction)qqShare;
- (IBAction)weixinShare;
- (IBAction)pyqShare;

@end
