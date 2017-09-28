//
//  ProvinceShortController.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/11.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProvinceNameBlock)(NSString *);

@interface ProvinceShortController : UIViewController

@property (nonatomic, copy) ProvinceNameBlock provinceBlock;

@end
