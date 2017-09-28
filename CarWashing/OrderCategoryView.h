//
//  OrderCategoryView.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryBlock)(NSInteger);

@interface OrderCategoryView : UIView

@property (nonatomic, copy) CategoryBlock categoryBlock;


@property (nonatomic, assign) CGFloat offsetX;


@end
