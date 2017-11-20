//
//  RemindViewTableViewCell.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindViewTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *smallImageView;
@property(strong,nonatomic)UILabel *bigLabel;
@property(strong,nonatomic)UILabel *shortLabel;

@property(copy,nonatomic)NSString *settenString;

@end
