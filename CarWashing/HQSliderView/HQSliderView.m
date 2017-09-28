//
//  HQSliderView.m
//  Unicare
//
//  Created by  on 16/10/9.
//  Copyright © 2016年 . All rights reserved.
//

#import "HQSliderView.h"
#import "UIView+HQCategory.h"

#define SCREEN_WIDTH      [UIScreen mainScreen].bounds.size.width


@interface HQSliderView ()

/** 滑块 */
@property (nonatomic, weak) UIView *sliderView;
/** 滑块宽度 */
@property (nonatomic, assign) CGFloat sliderWidth;
/** 临时按钮(用来记录哪个按钮为选中状态) */
@property (nonatomic, weak) UIButton *tempBtn;

@end

@implementation HQSliderView


- (void)layoutSubviews
{
    CGFloat y = 0;
    CGFloat w = SCREEN_WIDTH / self.titleArr.count;
    CGFloat h = self.h;
    
    self.sliderWidth = Main_Screen_Width*60/375;
    
    for (int i = 0; i < self.titleArr.count; i++) {
        
        CGFloat x = w * i;
        
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        
        NSString *string    = self.titleArr[i];
        if (string.length == 2) {
            
            self.sliderWidth = Main_Screen_Width*40/375;

        }else if (string.length == 4){
        
            self.sliderWidth = Main_Screen_Width*60/375;

        }
        
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        button.frame = CGRectMake(x, y, w, h);
        [self addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(didClickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (button.tag == 0) {
            
            button.selected = YES;
            _tempBtn = button;
        }
    
        /** 创建分割线 */
//        UIView *carve = [[UIView alloc] init];
//        carve.backgroundColor = [UIColor lightGrayColor];
//        carve.frame = CGRectMake(w * (i + 1), 12, 1, h - (12 * 2));
//        [self addSubview:carve];
    }
    
    /** 创建滑块 */
    UIView *sliderView = [[UIView alloc] init];
    self.sliderView = sliderView;
    sliderView.backgroundColor = [UIColor colorFromHex:@"#febb02"];
    
    /** 滑块高度 */
    CGFloat sliderHeight = 2.f;
    
    sliderView.frame = CGRectMake(SCREEN_WIDTH/3/2 - _sliderWidth / 2, self.bounds.size.height - sliderHeight, self.sliderWidth, sliderHeight);
    
    [self addSubview:sliderView];
    
//    UIView *carve = [[UIView alloc] init];
//    carve.backgroundColor = [UIColor lightGrayColor];
//    carve.frame = CGRectMake(0, h - 1, SCREEN_WIDTH, 1);
//    [self addSubview:carve];
}

- (void)didClickMenuButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(sliderView:didClickMenuButton:)]) {
        [self.delegate sliderView:self didClickMenuButton:button];
    }
    
    /** 当重复点击按钮时,直接返回,什么都不做 */
    if (button == _tempBtn) {
        return;
    }
    
    if (_tempBtn == button) {
        
        button.selected = YES;
        
    } else if (_tempBtn != button) {
        
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
    }
    
    /** 设置滑块滚动 */
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.x = (SCREEN_WIDTH/3/2 - _sliderWidth / 2) + button.tag * SCREEN_WIDTH / self.titleArr.count;
    }];
}

@end
