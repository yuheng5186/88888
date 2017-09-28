//
//  ShareWechatView.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/23.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ShareWechatView.h"

@implementation ShareWechatView

+ (instancetype)shareWechatView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil].lastObject;
}

@end
