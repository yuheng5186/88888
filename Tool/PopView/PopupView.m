//
//  PopupView.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/9.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "PopupView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationDrop.h"

@implementation PopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        _innerView.layer.cornerRadius = 10;
        [self addSubview:_innerView];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"每日签到都可以获得10积分哦"];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:13.0]
         
                              range:NSMakeRange(2, 2)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(9, 4)];
        _contentLabel.textColor       = [UIColor colorFromHex:@"#999999"];
        _contentLabel.attributedText  = AttributedStr;
        
        UITapGestureRecognizer  *tapShopGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShopButtonClick:)];
        [_innerView addGestureRecognizer:tapShopGesture];
        
    }
    return self;
}

- (void) tapShopButtonClick:(id)sender {
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
    
}
+ (instancetype)defaultPopupView{
    
    //    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 195, 210)];
    
    PopupView *popView  = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width*230/375, Main_Screen_Height*164/667)];
//    popView.layer.cornerRadius  = 5;
    //    popView.backgroundColor = [UIColor whiteColor];
    //    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    label.text      = @"恭喜您签到成功";
    //    label.textColor = [UIColor blackColor];
    //    [popView addSubview:label];
    
    
    
    return popView;
}

@end
