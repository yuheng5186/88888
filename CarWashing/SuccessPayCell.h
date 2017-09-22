//
//  SuccessPayCell.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/4.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushVCDelegate <NSObject>

- (void)pushController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@interface SuccessPayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UILabel *washTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property(nonatomic ,copy)NSString *SerMerCode;
@property(nonatomic ,copy)NSString *SerCode;
@property(nonatomic ,copy)NSString *orderid;



//代理
@property (nonatomic, weak) id<PushVCDelegate> delegate;

@end
