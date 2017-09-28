//
//  PhoneHelper.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneHelper : NSObject

+ (NSString *) carrierName;
+ (void) dial:(NSString *) phoneNumber;

@end
