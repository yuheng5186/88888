//
//  HQSliderView.h
//  Unicare
//
//  Created by on 16/10/9.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQSliderView;

@protocol HQSliderViewDelegate <NSObject>

- (void)sliderView:(HQSliderView *)sliderView didClickMenuButton:(UIButton *)button;

@end

@interface HQSliderView : UIView

@property (nonatomic, weak) id <HQSliderViewDelegate> delegate;

/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;

@end
