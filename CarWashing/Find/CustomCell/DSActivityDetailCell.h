//
//  DSActivityDetailCell.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSUserModel.h"

@interface DSActivityDetailCell : UITableViewCell

@property (nonatomic, strong) DSUserModel *model;
@property(nonatomic,copy) void (^thumbOnclick)(UIButton *btn);
@end
