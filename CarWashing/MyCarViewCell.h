//
//  MyCarViewCell.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/31.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *manuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CarImageV;
@property (weak, nonatomic) IBOutlet UILabel *defaulLabel;


@end
