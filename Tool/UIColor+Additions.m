//
//  UIColor+Additions.m
//  VehicleInfoDetector
//
//  Created by 李进辉 on 2/18/16.
//  Copyright © 2016 Continental Intelligent Transportation System Inc,. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *) defaultBackgroundColor
{
    return [UIColor colorFromHex: @"#E7E6EB"];
}

+ (UIColor *) customWhiteColor
{
    return [UIColor colorFromHex: @"#FFFFFF"];
}

+ (UIColor *) lightWhiteColor
{
    return [UIColor colorFromHex: @"#CDCDCD"];
}

+ (UIColor *) tarBarBackgroundColor
{
    return [UIColor colorFromHex: @"#141416"];
}

+ (UIColor *) accountHeaderBackgroundColor
{
    return [UIColor colorFromHex: @"#F9F8FB"];
}

+ (UIColor *) logoutTitleColor
{
    return [UIColor colorFromHex: @"#0076FF"];
}

+ (UIColor *) feedbackTitleColor
{
    return [UIColor colorFromHex: @"#242424"];
}

+ (UIColor *) layerBorderColor
{
    return [UIColor colorFromHex: @"#D1D1D1"];
}

+ (UIColor *) placeholderColor
{
    return [UIColor colorFromHex: @"#A5A5A5"];
}

+ (UIColor *) tarBarTitleColor
{
    return [UIColor colorFromHex: @"#4199FF"];
}

+ (UIColor *) blackTitleColor
{
    return [UIColor colorFromHex: @"#000000"];
}

+ (UIColor *) darkestGrayTitleColor
{
    return [UIColor colorFromHex: @"#DEDCEB"];
}

+ (UIColor *) darkGrayTitleColor
{
    return [UIColor colorFromHex: @"#EAE9F5"];
}

+ (UIColor *) lightGrayTitleColor
{
    return [UIColor colorFromHex: @"#F9F8FE"];
}

+ (UIColor *) smallBlueTitleColor
{
    return [UIColor colorFromHex: @"#0071FF"];
}

+ (UIColor *) smallTitleColor
{
    return [UIColor colorFromHex: @"#6D6D6D"];
}

+ (UIColor *) largeTitleColor
{
    return [UIColor colorFromHex: @"#0E0E0E"];
}

+ (UIColor *) pageControlCurrentIndicatorColor
{
    return [UIColor colorFromHex: @"#797B81"];
}

+ (UIColor *) pageControlIndicatorColor
{
    return [UIColor colorFromHex: @"#A7A7A7"];
}

+ (UIColor *) textFieldBackgroundColor
{
    return [UIColor colorFromHex: @"#F9F9F9"];
}

+ (UIColor *) separatorBackgroundColor
{
    return [UIColor colorFromHex: @"#EFEEF5"];
}

+ (UIColor *) detailTextLabelColor
{
    return [UIColor colorFromHex: @"#707070"];
}

+ (UIColor *) tableViewSeparatorLineColor
{
    return [UIColor colorFromHex: @"#EEEDF5"];
}

+ (UIColor *) quireBackgroundColor
{
    return [UIColor colorFromHex: @"#CFCFCF"];
}

+ (UIColor *) dropdownListBackgroundColor
{
    return [UIColor colorFromHex: @"#F5F5F5"];
}

+ (UIColor *) dropdownListTitleColor
{
    return [UIColor colorFromHex: @"#FF6F00"];
}

+ (UIColor *) warningRedColor
{
    return [UIColor colorFromHex: @"#F2542F"];
}

+ (UIColor *) handledGrayColor
{
    return [UIColor colorFromHex: @"#919191"];
}

+ (UIColor *) contentGrayColor
{
    return [UIColor colorFromHex: @"#5B5B5B"];
}

+ (UIColor *) solangGrayColor
{
    return [UIColor colorFromHex: @"#5D5D5D"];
}

+ (UIColor *) buttonBackgroundGrayColor
{
    return [UIColor colorFromHex: @"#D0D0D0"];
}

+ (UIColor *) buttonOrangeColor
{
    return [UIColor colorFromHex: @"#FCAD00"];
}

+ (UIColor *) containerBackgroundColor
{
    return [UIColor colorFromHex: @"#979797"];
}

+ (UIColor *) maintenanceBackgroundColor
{
    return [UIColor colorFromHex: @"#D8D8D8"];
}

+ (UIColor *) maintenanceButtonTitleColor
{
    return [UIColor colorFromHex: @"#4A4A4A"];
}

+ (UIColor *) diagnosticHeaderBackgroundGradientBeginColor
{
    return [UIColor colorFromHex: @"#FFB700"];
}

+ (UIColor *) diagnosticHeaderBackgroundGradientEndColor
{
    return [UIColor colorFromHex: @"#FCD763"];
}

+ (UIColor *) diagnosticHeaderPromptColor
{
    return [UIColor colorFromHex: @"#F19107"];
}

+ (UIColor *) diagnosticComponentsBackgroundColor
{
    return [UIColor colorFromHex: @"#111112"];
}

+ (UIColor *) diagnosingInProgressLabelColor
{
    return [UIColor colorFromHex: @"#4D4D4D"];
}

+ (UIColor *) diagnosticComponentCircleBackgroundColor
{
    return [UIColor colorFromHex: @"#242328"];
}

+ (UIColor *) diagnosticComponentAppointButtonBackgroundColor
{
    return [UIColor colorFromHex: @"#FFB500"];
}

+ (UIColor *) diagnosticFaultNumberBadgeColor
{
    return [UIColor colorFromHex: @"#E11A15"];
}

+ (UIColor *) diagnosticFaultsBackgroundColor
{
    return [UIColor colorFromHex: @"#1C1C1C"];
}

+ (UIColor *) colorFromHex: (NSString *) hex
{
    return [UIColor colorFromHex: hex alpha: 1.0f];
}

+ (UIColor *) colorFromHex: (NSString *) hex alpha: (CGFloat) alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


@end
