//
//  DSInputCodeController.h
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/8/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSInteger, TFInputViewShowType){
    TFInputViewShowTypeSingleLine,      //单行
    TFInputViewShowTypeMultiLine,       //多行
    TFInputViewShowTypeBorder,          //边框
    TFInputViewShowTypeNoGapAndBorder,   //cell无间隙且带边框
    TFInputViewShowTypeSercetInput,     //密码输入
    TFInputViewShowTypeBecomeFirstResponder     //一进页面就弹出输入
};

@interface DSInputCodeController : BaseController

@property (nonatomic, assign) TFInputViewShowType showType;

@end
