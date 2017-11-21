//
//  AddDriverLicenseViewController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDriverLicenseViewController : UIViewController
@property(strong,nonatomic)UIImageView * fakeNavigation;
@property(copy,nonatomic)NSString *webTypeString;           //修改或者新加入
@property(copy,nonatomic)NSString *getID;

@property(copy,nonatomic)NSString *dateMuSting;             //到期时间
@property(copy,nonatomic)NSString *licenseTypeString;       //驾照类型
@property(copy,nonatomic)NSString *placeHolderString;       //占位符string

//判断从哪里进来
@property(copy,nonatomic)NSString *whereString;

@end
