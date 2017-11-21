//
//  AddInSurenceViewController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInSurenceViewController : UIViewController
@property(strong,nonatomic)UIImageView * fakeNavigation;
@property(copy,nonatomic)NSString *webTypeString;           //修改或者新加入
@property(copy,nonatomic)NSString *getID;

@property(copy,nonatomic)NSString *dateMuSting;                 //上次年检时间
@property(copy,nonatomic)NSString *companyNameMuString;         //保险公司名字

//判断从哪里进来
@property(copy,nonatomic)NSString *whereString;

@end
