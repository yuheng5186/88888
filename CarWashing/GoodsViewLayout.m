//
//  GoodsViewLayout.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "GoodsViewLayout.h"

@implementation GoodsViewLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    CGFloat itemW = 140;
    CGFloat itemH = 80;
    
    self.itemSize = CGSizeMake(itemW, itemH);
    
//    self.minimumInteritemSpacing = 0;
//    self.minimumLineSpacing = 0;
}


@end
