//
//  AddYearTestViewController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddYearTestViewController : UIViewController
@property(strong,nonatomic)UIView * fakeNavigation;
@property(copy,nonatomic)NSString *webTypeString;           //修改或者新加入
@property(copy,nonatomic)NSString *getID;

@property(copy,nonatomic)NSString *sendButtonTitleString;       //传回button名字
@property(copy,nonatomic)NSString *placeholderString;
@property(copy,nonatomic)NSString *dateMuSting;         //上次年检时间
@property(copy,nonatomic)NSString *yearsMuSting;         //车龄
@property(copy,nonatomic)NSString *carMuSting;         //品牌车系
@property(copy,nonatomic)NSString *sendSerString;         //给后台

//判断从哪里进来
@property(copy,nonatomic)NSString *whereString;


@end
