//
//  UIColor+Additions.h
//  VehicleInfoDetector
//
//  Created by 李进辉 on 2/18/16.
//  Copyright © 2016 Continental Intelligent Transportation System Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *) defaultBackgroundColor;

+ (UIColor *) customWhiteColor;

+ (UIColor *) lightWhiteColor;

+ (UIColor *) tarBarBackgroundColor;

+ (UIColor *) accountHeaderBackgroundColor;

+ (UIColor *) logoutTitleColor;

+ (UIColor *) feedbackTitleColor;

+ (UIColor *) layerBorderColor;

+ (UIColor *) placeholderColor;

+ (UIColor *) tarBarTitleColor;

+ (UIColor *) blackTitleColor;

+ (UIColor *) darkestGrayTitleColor;

+ (UIColor *) darkGrayTitleColor;

+ (UIColor *) lightGrayTitleColor;

+ (UIColor *) smallBlueTitleColor;

+ (UIColor *) smallTitleColor;

+ (UIColor *) largeTitleColor;

+ (UIColor *) pageControlCurrentIndicatorColor;

+ (UIColor *) pageControlIndicatorColor;

+ (UIColor *) textFieldBackgroundColor;

+ (UIColor *) separatorBackgroundColor;

+ (UIColor *) detailTextLabelColor;

+ (UIColor *) tableViewSeparatorLineColor;

+ (UIColor *) quireBackgroundColor;

+ (UIColor *) dropdownListBackgroundColor;

+ (UIColor *) dropdownListTitleColor;

+ (UIColor *) warningRedColor;

+ (UIColor *) handledGrayColor;

+ (UIColor *) contentGrayColor;

+ (UIColor *) solangGrayColor;

+ (UIColor *) buttonBackgroundGrayColor;

+ (UIColor *) buttonOrangeColor;

+ (UIColor *) containerBackgroundColor;

+ (UIColor *) maintenanceBackgroundColor;

+ (UIColor *) maintenanceButtonTitleColor;

+ (UIColor *) diagnosticHeaderBackgroundGradientBeginColor;

+ (UIColor *) diagnosticHeaderBackgroundGradientEndColor;

+ (UIColor *) diagnosticHeaderPromptColor;

+ (UIColor *) diagnosticComponentsBackgroundColor;

+ (UIColor *) diagnosingInProgressLabelColor;

+ (UIColor *) diagnosticComponentCircleBackgroundColor;

+ (UIColor *) diagnosticComponentAppointButtonBackgroundColor;

+ (UIColor *) diagnosticFaultNumberBadgeColor;

+ (UIColor *) diagnosticFaultsBackgroundColor;

+ (UIColor *) colorFromHex: (NSString *) hex;

+ (UIColor *) colorFromHex: (NSString *) hex alpha: (CGFloat) alpha;

@end
