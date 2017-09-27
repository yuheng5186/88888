//
//  AppDelegate.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/18.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


+ (AppDelegate *) sharedInstance;



@property (strong, nonatomic) User *currentUser;

@property float autoSizeScaleX;
@property float autoSizeScaleY;

@end

