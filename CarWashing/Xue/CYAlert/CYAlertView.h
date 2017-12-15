//
//  CYAlertView.h
//  CarWashing
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAlertView : UIView
@property (nonatomic,strong) UIView  * backView;
@property (nonatomic,strong) UIView  * whiteView;
@property (nonatomic,strong) UIButton  * cancelButton;
@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, copy) NSString * detailStr;
-(void)showView;
@end
