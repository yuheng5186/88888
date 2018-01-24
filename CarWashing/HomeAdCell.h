//
//  HomeAdCell.h
//  CarWashing
//
//  Created by Wuxinglin on 2018/1/16.
//  Copyright © 2018年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeAdModel.h"

@interface HomeAdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeAdImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeAdLabel;
-(void)setModelValue:(HomeAdModel*)model;
@end
