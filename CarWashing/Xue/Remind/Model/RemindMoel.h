//
//  RemindMoel.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/15.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindMoel : NSObject
@property(copy,nonatomic)NSString *IsSetUp;
@property(copy,nonatomic)NSString *TimeSpans;
@property(nonatomic,copy)NSString *ExpirationDate;
@property(nonatomic,copy)NSString *Province;
@property(nonatomic,copy)NSString *PlateNumber;
@property(nonatomic,copy)NSString *TimeDate;
@property(nonatomic,copy)NSString *MaintenanceFrequency;

@end
