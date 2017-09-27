//
//  DSCompleteWashingController.m
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/8/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSCompleteWashingController.h"
#import "DSScanController.h"
#import "DSScanQRCodeController.h"

@interface DSCompleteWashingController ()

@end

@implementation DSCompleteWashingController

- (void) drawNavigation {
    
    [self drawTitle:@"洗车结束"];
    [self drawBackButtonWithAction:@selector(backButtonClick:)];
}

- (void) backButtonClick:(id)sender {
        
    self.tabBarController.selectedIndex = 0;
    
    NSArray     *array  = self.navigationController.viewControllers;
    NSArray *a = [NSArray arrayWithObject:array[0]];
    
    
    
    if(array.count == 4)
    {
        
        self.navigationController.viewControllers = a;
        
    }
    else
    {
        NSArray     *array1 = [NSArray arrayWithObject:array[0]];
        self.navigationController.viewControllers = array1;
    }
    
}
- (void) drawContent {
    
    self.contentView.top                = self.navigationView.bottom;
    self.contentView.height             = self.view.height;
    self.contentView.backgroundColor    = [UIColor colorFromHex:@"#fafafa"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubView];
    
}

- (void) createSubView {
    
    UIView *titleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*80/667) color:[UIColor whiteColor]];
    titleView.top                      = Main_Screen_Height*10/667;
    titleView.centerX                  = Main_Screen_Width/2;
    
    
    NSString   *titleString     = @"精洗";
    
    UIFont     *titleFont       = [UIFont systemFontOfSize:18];
    UILabel *titleLabel         = [UIUtil drawLabelInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:titleFont text:titleString isCenter:NO];
    titleLabel.text             = titleString;
    titleLabel.textColor        = [UIColor colorFromHex:@"#ff525a"];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.centerX          = Main_Screen_Width/4 -Main_Screen_Width*20/375;;
    titleLabel.top              = Main_Screen_Height*16/667;
    
    NSString   *modeString     = @"洗车模式";
    
    UIFont     *modeFont       = [UIFont systemFontOfSize:12];
    UILabel *modeLabel         = [UIUtil drawLabelInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:modeFont text:modeString isCenter:NO];
    modeLabel.text             = modeString;
    modeLabel.textColor        = [UIColor colorFromHex:@"#868686"];
    modeLabel.textAlignment    = NSTextAlignmentCenter;
    modeLabel.centerX          = titleLabel.centerX;
    modeLabel.top              = titleLabel.bottom+Main_Screen_Height*10/667;
    
    
    
    NSString   *scoreString     = [NSString stringWithFormat:@"+%d积分",10];
    UILabel *scoreLabel         = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667)];
    scoreLabel.textColor        = [UIColor colorFromHex:@"#ff525a"];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:scoreString];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange([scoreString length]-2, 2)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHex:@"#4a4a4a"] range:NSMakeRange([scoreString length]-2, 2)];
    
    scoreLabel.attributedText   = AttributedStr;
    scoreLabel.textAlignment    = NSTextAlignmentCenter;
    scoreLabel.centerX          = Main_Screen_Width/2;
    scoreLabel.top              = Main_Screen_Height*16/667;
    [titleView addSubview:scoreLabel];
    
    
    NSString   *scoreTextString     = @"积分奖励";
    
    UIFont     *scoreTextFont       = [UIFont systemFontOfSize:12];
    UILabel *scoreTextLabel         = [UIUtil drawLabelInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:scoreTextFont text:scoreTextString isCenter:NO];
    scoreTextLabel.text             = scoreTextString;
    scoreTextLabel.textColor        = [UIColor colorFromHex:@"#868686"];
    scoreTextLabel.textAlignment    = NSTextAlignmentCenter;
    scoreTextLabel.centerX          = scoreLabel.centerX;
    scoreTextLabel.top              = scoreLabel.bottom+Main_Screen_Height*10/667;
    
    
    
    NSString   *timeNumString     = @"5分钟";
    
    UILabel *timeNumLabel         = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667)];
    timeNumLabel.textColor        = [UIColor colorFromHex:@"#ff525a"];
    
    NSMutableAttributedString *AttributedStrTime = [[NSMutableAttributedString alloc]initWithString:timeNumString];
    [AttributedStrTime addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange([timeNumString length]-2, 2)];
    [AttributedStrTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHex:@"#4a4a4a"] range:NSMakeRange([timeNumString length]-2, 2)];
    
    timeNumLabel.attributedText   = AttributedStrTime;
    
    timeNumLabel.textAlignment    = NSTextAlignmentCenter;
    timeNumLabel.centerX          = Main_Screen_Width*3/4 +Main_Screen_Width*20/375;;
    timeNumLabel.top              = Main_Screen_Height*16/667;
    
    [titleView addSubview:timeNumLabel];
    
    
    NSString   *timeString     = @"洗车时间";
    
    UIFont     *timeFont       = [UIFont systemFontOfSize:12];
    UILabel *timeLabel         = [UIUtil drawLabelInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:timeFont text:timeString isCenter:NO];
    timeLabel.text             = timeString;
    timeLabel.textColor        = [UIColor colorFromHex:@"#868686"];
    timeLabel.textAlignment    = NSTextAlignmentCenter;
    timeLabel.centerX          = timeNumLabel.centerX;
    timeLabel.top              = timeNumLabel.bottom+Main_Screen_Height*10/667;
    
    
    UIView *middleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*60/667) color:[UIColor whiteColor]];
    middleView.top                      = titleView.bottom +Main_Screen_Height*10/667;
    middleView.centerX                  = Main_Screen_Width/2;
    
    NSString   *string            = @"支付方式";
    UIFont     *Font              = [UIFont systemFontOfSize:15];
    UILabel *washingLabel         = [UIUtil drawLabelInView:middleView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:Font text:string isCenter:NO];
    washingLabel.text             = string;
    washingLabel.textColor        = [UIColor colorFromHex:@"#4a4a4a"];
    washingLabel.textAlignment    = NSTextAlignmentCenter;
    washingLabel.left             = Main_Screen_Height*12/375;
    washingLabel.top              = Main_Screen_Height*20/667;
    
    
    
    NSString   *timeStr     = @"月卡抵扣";
    
    UIFont     *timeStrFont       = [UIFont systemFontOfSize:12];
    UILabel *timeStrLabel         = [UIUtil drawLabelInView:middleView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:timeStrFont text:timeStr isCenter:NO];
    timeStrLabel.text             = timeStr;
    timeStrLabel.textColor        = [UIColor colorFromHex:@"#868686"];
    timeStrLabel.textAlignment    = NSTextAlignmentCenter;
    timeStrLabel.right            = Main_Screen_Width -Main_Screen_Width*12/375;
    timeStrLabel.centerY          = washingLabel.centerY;
    
    
    
    UIView *downView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*60/667) color:[UIColor whiteColor]];
    downView.top                      = middleView.bottom +Main_Screen_Height*10/667;
    downView.centerX                  = Main_Screen_Width/2;
    
    NSString   *scardString            = @"我的卡券";
    UIFont     *cardFont              = [UIFont systemFontOfSize:15];
    UILabel *cardLabel         = [UIUtil drawLabelInView:downView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:cardFont text:scardString isCenter:NO];
    cardLabel.text             = scardString;
    cardLabel.textColor        = [UIColor colorFromHex:@"#4a4a4a"];
    cardLabel.textAlignment    = NSTextAlignmentCenter;
    cardLabel.left             = Main_Screen_Height*12/375;
    cardLabel.top              = Main_Screen_Height*20/667;
    
    
    
    NSString   *timeStr2     = @"剩余5次";
    
    UIFont     *timeStrFont2       = [UIFont systemFontOfSize:15];
    UILabel *timeStrLabel2         = [UIUtil drawLabelInView:downView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) font:timeStrFont2 text:timeStr2 isCenter:NO];
    timeStrLabel2.text             = timeStr2;
    timeStrLabel2.textColor        = [UIColor colorFromHex:@"#ff525a"];
    timeStrLabel2.textAlignment    = NSTextAlignmentCenter;
    timeStrLabel2.right            = Main_Screen_Width -Main_Screen_Width*12/375;
    timeStrLabel2.top              = Main_Screen_Height*20/667;
    
    
    UIButton    *adButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    adButton.frame              = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*100/667);
    adButton.backgroundColor    = [UIColor redColor];
    [adButton setBackgroundImage:[UIImage imageNamed:@"guanggao11"] forState:UIControlStateNormal];
    [adButton addTarget:self action:@selector(adButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    adButton.bottom        = self.view.height -Main_Screen_Height*80/667;
    
    if (Main_Screen_Height == 568) {
        adButton.bottom        = self.contentView.height -Main_Screen_Height*85/667;
    }
    if (Main_Screen_Height == 667) {
        adButton.bottom        = self.contentView.height -Main_Screen_Height*75/667;
    }
    if (Main_Screen_Height == 736) {
        adButton.bottom        = self.contentView.height -Main_Screen_Height*70/667;
    }
    
    adButton.centerX       = titleView.size.width/2;
    [self.contentView addSubview:adButton];
    
    
    UIButton    *adPageButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    adPageButton.frame              = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*100/667);
    adPageButton.backgroundColor    = [UIColor redColor];
    [adPageButton setBackgroundImage:[UIImage imageNamed:@"guanggaotu1"] forState:UIControlStateNormal];
    [adPageButton addTarget:self action:@selector(adPageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    adPageButton.bottom        = adButton.top -Main_Screen_Height*10/667;
    adPageButton.centerX       = titleView.size.width/2;
    [self.contentView addSubview:adPageButton];
    
}

- (void) adButtonClick:(id)sender {
    
    
}

- (void) adPageButtonClick:(id)sender {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
