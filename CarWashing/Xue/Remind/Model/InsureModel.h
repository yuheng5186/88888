//
//  InsureModel.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsureModel : NSObject
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *IsSetUp;
@property(nonatomic,copy)NSString *Province;
@property(nonatomic,copy)NSString *PlateNumber;

@property(nonatomic,copy)NSString *ExpirationDate;          //到期时间
@property(nonatomic,copy)NSString *InsuranceCompany;


@end