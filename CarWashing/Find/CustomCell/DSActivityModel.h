//
//  DSActivityModel.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/9.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DSActivityModel : NSObject

// 字典模型转换
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@property (nonatomic,copy) NSString * iconName;
@property (nonatomic,copy) NSString * sayTime;
@property (nonatomic,copy) NSString * titleName;
@property (nonatomic,copy) NSString * sayNumber;
@property (nonatomic,copy) NSString * goodNumber;


@property (nonatomic,assign) CGFloat cellHeight;

@end
