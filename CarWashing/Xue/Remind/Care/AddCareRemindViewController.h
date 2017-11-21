//
//  AddCareRemindViewController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/10.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCareRemindViewController : UIViewController
@property(strong,nonatomic)UIImageView * fakeNavigation;
@property(copy,nonatomic)NSString *typeString;
@property(copy,nonatomic)NSString *getID;

@property(copy,nonatomic)NSString *subMuSting;
@property(copy,nonatomic)NSString *dateMuSting;
@property(copy,nonatomic)NSString *sendSerHowLongStr;

//判断从哪里进来
@property(copy,nonatomic)NSString *whereString;

@end
