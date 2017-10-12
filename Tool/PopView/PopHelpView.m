//
//  PopHelpView.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "PopHelpView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationDrop.h"

@implementation PopHelpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame string:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _helpView.frame = frame;
        _helpView.layer.cornerRadius = 10;
        [self addSubview:_helpView];
        
        _helpTitleLabel.text          = string;
        _contentLabel.textColor       = [UIColor colorFromHex:@"#999999"];
        _contentLabel.text            = @"在金顶洗车的自动洗车机上都有对应的二维码，只需用手机扫码，便可以启动机器";
        
        UITapGestureRecognizer  *tapShopGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShopButtonClick:)];
        [_helpView addGestureRecognizer:tapShopGesture];
        
    }
    return self;
}

- (void) tapShopButtonClick:(id)sender {
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
    
}
+ (instancetype)defaultPopHelpView:(NSString *)string{
    
    //    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 195, 210)];
    
    PopHelpView *popView  = [[PopHelpView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width*340/375, Main_Screen_Height*246/667) string:string];
    //    popView.layer.cornerRadius  = 5;
    //    popView.backgroundColor = [UIColor whiteColor];
    //    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    label.text      = @"恭喜您签到成功";
    //    label.textColor = [UIColor blackColor];
    //    [popView addSubview:label];
    
    
    
    return popView;
}
@end
