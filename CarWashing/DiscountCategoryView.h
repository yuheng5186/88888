//
//  DiscountCategoryView.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryBlock)(NSInteger);

@interface DiscountCategoryView : UIView

@property (nonatomic, copy) CategoryBlock categoryBlock;

@property (nonatomic, assign) CGFloat offsetX;

@end
