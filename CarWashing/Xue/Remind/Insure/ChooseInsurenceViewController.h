//
//  ChooseInsurenceViewController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/13.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseInsurenceViewController : UIViewController
@property(nonatomic,copy)void (^deliverBlock)(NSString * sendInsurenceTypeString);
@end
