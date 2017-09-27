//
//  UIView+Frame.h
//  Links
//
//  Created by zhengpeng on 14-4-8.
//  Copyright (c) 2015年 zhengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (void) setHeight: (CGFloat) height;

- (CGFloat) left;

- (CGFloat) right;

- (CGFloat) top;

- (CGFloat) bottom;

- (CGSize) size;

- (CGFloat) width;

- (CGFloat) height;

- (CGFloat) centerX;

- (CGFloat) centerY;

- (void) setLeft: (CGFloat) left;

- (void) setRight: (CGFloat) right;

- (void)setBottom:(CGFloat) bottom;

- (void) setSize: (CGSize) size;

- (void) setTop: (CGFloat) top;

- (void) setWidth: (CGFloat) width;

- (void) setOrigin: (CGPoint) point;

- (void) setCenterX:(CGFloat) centerX;

- (void) setCenterY: (CGFloat) centerY;

- (void) setAddTop:(CGFloat) top;

- (void) setAddLeft: (CGFloat) left;

- (void) removeAllSubviews;

@end
