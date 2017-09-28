//
//  DSSegmentView.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryBlock)(NSInteger);

@interface DSSegmentView : UIView

@property (nonatomic, copy) CategoryBlock categoryBlock;
@property (nonatomic, assign) CGFloat offsetX;

@end
