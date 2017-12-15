//
//  CYAlertView.m
//  CarWashing
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CYAlertView.h"

@implementation CYAlertView

-(void)showView
{
    self.backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backView.backgroundColor=[UIColor blackColor];
    self.backView.alpha = 0.5;
    [self addSubview:self.backView];
    
    self.whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 337*Main_Screen_Width/375, 314*Main_Screen_Width/375)];
    self.whiteView.backgroundColor = [UIColor clearColor];
    self.whiteView.centerX = self.centerX;
    self.whiteView.centerY = self.centerY;
    [self addSubview:self.whiteView];
    
    UIImageView * imageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.whiteView.frame.size.width, self.whiteView.frame.size.height)];
    imageVIew.image = [UIImage imageNamed:@"shouyetanchuang"];
    [self.whiteView addSubview:imageVIew];
    
//    UIImageView * imageVIew1=[[UIImageView alloc]initWithFrame:CGRectMake(65*Main_Screen_Height/667, 20*Main_Screen_Height/667, 90*Main_Screen_Height/667, 90*Main_Screen_Height/667)];
//    imageVIew1.image = [UIImage imageNamed:@"shouye_tankuang_tu"];
//    [self.whiteView addSubview:imageVIew1];
    
    UILabel * titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120*Main_Screen_Width/375, self.whiteView.frame.size.width, 30*Main_Screen_Width/375)];
    titlelabel.text = @"恭喜您成为金顶洗车会员";
    titlelabel.textColor=[UIColor colorWithRed:255/255.0 green:204/255.0 blue:50/255.0 alpha:1];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font=[UIFont systemFontOfSize:17.0*Main_Screen_Width/375];
    [self.whiteView addSubview:titlelabel];
    
    UILabel * detaillabel = [[UILabel alloc]initWithFrame:CGRectMake(25*Main_Screen_Width/375, 150*Main_Screen_Width/375, 240*Main_Screen_Width/375, 80*Main_Screen_Width/375)];
    detaillabel.text = @"请激活您的洗车卡，点击激活卡券充值，将洗车卡背面激活码输入并点击激活即可使用。洗车请直接扫码。";
    detaillabel.centerX = Main_Screen_Width/2-20*Main_Screen_Width/375;
    detaillabel.numberOfLines=0;
//    detaillabel.backgroundColor = [UIColor redColor];
    detaillabel.textColor=[UIColor colorFromHex:@"#3f3f3f"];
//    detaillabel.textAlignment = NSTextAlignmentCenter;
    detaillabel.font=[UIFont systemFontOfSize:13*Main_Screen_Height/667];
    [self.whiteView addSubview:detaillabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame=CGRectMake(60*Main_Screen_Height/667, self.whiteView.frame.size.height-(62*Main_Screen_Height/667), self.whiteView.frame.size.width-(120*Main_Screen_Height/667), 40*Main_Screen_Height/667);
    self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:18.0*Main_Screen_Height/667];
    [self.cancelButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:204/255.0 blue:50/255.0 alpha:1]];
//    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"shouye_tankuang_anniu"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorFromHex:@"#ffffff"] forState:UIControlStateNormal];
    self.cancelButton.layer.cornerRadius = 20*Main_Screen_Height/667;
    self.cancelButton.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.cancelButton];
   
    
    
}

@end
