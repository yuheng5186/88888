//
//  payCardDetailCell.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payCardDetailCell : UITableViewCell

@property (nonatomic, weak) UILabel *useCardLabel;
@property (nonatomic, weak) UILabel *timesCardLabel;
@property (nonatomic, weak) UILabel *brandCardLabel;

-(void)setTimes:(NSString *)string;

@end
