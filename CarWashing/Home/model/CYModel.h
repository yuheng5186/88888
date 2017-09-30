//
//  CYModel.h
//  CarWashing
//
//  Created by apple on 2017/9/29.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CYModel : JSONModel
@property (nonatomic,copy)NSString * Account_Id;
@property (nonatomic,copy)NSString * Amt;
@property (nonatomic,copy)NSString * CardName;
@property (nonatomic,copy)NSString * CardType;
@property (nonatomic,copy)NSString * DeviceCode;
@property (nonatomic,copy)NSString * DeviceName;
@property (nonatomic,copy)NSString * DiscountPrice;
@property (nonatomic,copy)NSString * IntegralNum;
@property (nonatomic,copy)NSString * OriginalAmt;
@property (nonatomic,copy)NSString * RemainCount;
@property (nonatomic,copy)NSString * ScanCodeState;
@property (nonatomic,copy)NSString * ServiceItems;
@end
