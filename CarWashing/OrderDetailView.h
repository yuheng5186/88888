//
//  OrderDetailView.h
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *MerChantImgV;
@property (weak, nonatomic) IBOutlet UILabel *MerChantType;
@property (weak, nonatomic) IBOutlet UILabel *MerChantAdress;
@property (weak, nonatomic) IBOutlet UILabel *MerChantName;

@property (weak, nonatomic) IBOutlet UILabel *MerChantService;
@property (weak, nonatomic) IBOutlet UILabel *ShijiPrice;
@property (weak, nonatomic) IBOutlet UILabel *Jprice;
@property (weak, nonatomic) IBOutlet UILabel *youhuiprice;
@property (weak, nonatomic) IBOutlet UILabel *shijiPrice1;
@property (weak, nonatomic) IBOutlet UILabel *orderid;
@property (weak, nonatomic) IBOutlet UILabel *ordertime;
@property (weak, nonatomic) IBOutlet UILabel *paymethod;

+ (instancetype)orderDetailView;

@end
