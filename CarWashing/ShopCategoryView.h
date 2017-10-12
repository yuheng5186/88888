//
//  ShopCategoryView.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryBlock)(NSInteger);

@interface ShopCategoryView : UIView

@property (nonatomic, copy) CategoryBlock categoryBlock;

@property (nonatomic, assign) CGFloat offsetX;

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;


@end
