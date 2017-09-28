//
//  ActivityListCell.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sayNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *sayButton;





@end
