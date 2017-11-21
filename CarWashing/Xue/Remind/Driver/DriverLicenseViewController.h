//
//  DriverLicenseViewController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverLicenseViewController : UIViewController
@property(strong,nonatomic)UIImageView *fakeNavigation;
@property(strong,nonatomic)UIView *addView;
@property(strong,nonatomic)UIView *afterView;
//afterView中的属性
@property(strong,nonatomic)UILabel *carNoLabel;
@property(strong,nonatomic)UILabel *carCareTimeLabel;

//首页进来
@property(copy,nonatomic)NSString *getRemindType;
@property(copy,nonatomic)NSString *getID;

@property(copy,nonatomic)NSString *wayGetHere;
@end
