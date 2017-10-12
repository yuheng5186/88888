//
//  SalerListViewCell.h
//  商家
//
//  Created by 时建鹏 on 2017/7/18.
//  Copyright © 2017年 mm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalerListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopAdressLabel;

@property (weak, nonatomic) IBOutlet UILabel *freeTestLabel;

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeShopLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIView *separateLine;

@property (weak, nonatomic) IBOutlet UIImageView *starView;

@property (weak, nonatomic) IBOutlet UILabel *ScoreLabel;

@end
