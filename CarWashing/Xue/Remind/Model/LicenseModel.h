//
//  LicenseModel.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LicenseModel : NSObject
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *IsSetUp;
@property(nonatomic,copy)NSString *Province;
@property(nonatomic,copy)NSString *PlateNumber;

@property(nonatomic,copy)NSString *QuasiDriveType;              //驾照
@property(nonatomic,copy)NSString *IDNumber;                    //驾照号码
@property(nonatomic,copy)NSString *ExpirationDate;              //过期时间

@end
