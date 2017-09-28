//
//  DelayPayCell.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/4.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DelayPayCellPushVCDelegate <NSObject>

- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated;

@end

@interface DelayPayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UILabel *washTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property(nonatomic ,copy)NSString *SerMerChant;

@property(nonatomic ,copy)NSString *Jprice;
@property(nonatomic ,copy)NSString *Xprice;

@property(nonatomic ,copy)NSString *SCode;
@property(nonatomic ,copy)NSString *MCode;
@property(nonatomic ,copy)NSString *OrderCode;


@property (nonatomic, weak) id<DelayPayCellPushVCDelegate> delegate;


@end
