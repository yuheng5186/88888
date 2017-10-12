//
//  PhoneHelper.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "PhoneHelper.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation PhoneHelper

+ (void) dial:(NSString *) phoneNumber
{
    NSString *URLString		= [@"tel://" stringByAppendingString:phoneNumber];
    NSURL *URL				= [NSURL URLWithString: URLString];
    
//    return [[UIApplication sharedApplication] openURL: URL];
    return [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}

+ (NSString *) carrierName
{
    CTTelephonyNetworkInfo *phoneInfo   = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *phoneCarrier             = [phoneInfo subscriberCellularProvider];
    
    return [phoneCarrier carrierName];
}


@end
