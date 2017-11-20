//
//  ChooseTableViewController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/13.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTableViewController : UIViewController
//1.声明闭包传string
@property(nonatomic,copy)void (^deliverBlock)(NSString * blockLicenseTypeString);
@end
