//
//  ShareWeChatController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/23.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetTabBarDelegate <NSObject>

- (void)setTabBarIsHide:(UIViewController *)VC;

@end

@interface ShareWeChatController : UIViewController

@property (nonatomic, weak) id<SetTabBarDelegate> delegate;

@end
