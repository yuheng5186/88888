//
//  DSAboutController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSAboutController.h"
#import "DSAgreementController.h"

@interface DSAboutController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation DSAboutController

- (void)drawNavigation {
    
    [self drawTitle:@"关于金顶"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self craeteSubView];
}

- (void) craeteSubView {
    self.view.backgroundColor           = [UIColor whiteColor];
    
    self.scrollView                         = [[UIScrollView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.size.width, self.contentView.size.height)];
    self.scrollView.backgroundColor         = [UIColor whiteColor];
    self.scrollView.contentSize             = CGSizeMake(self.contentView.size.width, self.contentView.size.height*1.2);
    [self.scrollView flashScrollIndicators];
    self.scrollView.contentInset     = UIEdgeInsetsMake(0, 0, 60, 0);
    self.scrollView.directionalLockEnabled  = YES;
    [self.view addSubview:self.scrollView];

    self.contentView.backgroundColor    = [UIColor whiteColor];
    
    UIView *upView                  = [UIUtil drawLineInView:self.scrollView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*200/667) color:[UIColor colorFromHex:@"#e5e5e5"]];
    upView.backgroundColor          = [UIColor whiteColor];
    upView.top                      = 0;
    
    
    UIImage *appImage              = [UIImage imageNamed:@"denglu_icon"];
    UIImageView *appImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(0, 0, appImage.size.width, appImage.size.height) imageName:@"denglu_icon"];
    appImageView.top               = Main_Screen_Height*50/667;
    appImageView.centerX           = upView.centerX;
    
    NSDictionary *infoDic           = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion            = [infoDic objectForKey: @"CFBundleShortVersionString"];
    NSString *string                = [NSString stringWithFormat: @"%@ %@",NSLocalizedString (@"V", nil), appVersion];
    
    
    NSString *showName              = [NSString stringWithFormat:@"金顶洗车%@",string];
    UIFont *showNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*16/667];
    UILabel *showNameLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:showName font:showNameFont] font:showNameFont text:showName isCenter:NO];
    showNameLabel.textColor         = [UIColor colorFromHex:@"#8B8B8B"];
    showNameLabel.top               = appImageView.bottom +Main_Screen_Height*15/667;
    showNameLabel.centerX           = appImageView.centerX;
    
    NSString *contentName               = @"    金顶汽车服务APP平台由上海专业技术团队研发，采用SoLoMo+O2O相结合的商业模式，利用物联网、二维码、牌照识别、无线路由、云计算等先进技术，通过手机、微信以及APP，实现一机在手，车主可洗车，商户可搭载商品，实现无现金时代人们消费行为和消费习惯，注重用户体验，通过价值交互提升商户的企业核心价值和竞争优势，为顾客提供方便、快捷的汽车服务体验。\n此平台的诞生将彻底改变传统汽车服务市场格局，颠覆了行业内自主经营模式，强强联合，利用移动互联网特点，将线上与线下相融合，完美打造指尖上的爱车管家式服务。\n项目优势：\n①免费的平台和设备\n②专业的一站式车主服务平台\n③多维营销需求“零”等待\n④“大数据”助推业主普惠客户\n\nSLOGAN:指尖上的爱车管家";
    UIFont *contentNameFont             = [UIFont systemFontOfSize:Main_Screen_Height*16/667];
    UILabel *contentNameLabel           = [UIUtil drawLabelInView:self.scrollView frame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*20/375, Main_Screen_Height*400/667) font:contentNameFont text:contentName isCenter:NO];
    contentNameLabel.textColor          = [UIColor colorFromHex:@"#999999"];
//    contentNameLabel.backgroundColor    = [UIColor redColor];
    contentNameLabel.numberOfLines      = 0;
    contentNameLabel.top                = showNameLabel.bottom +Main_Screen_Height*10/667;
    contentNameLabel.centerX            = appImageView.centerX;
    
//    NSString *serviceProtocolName              = @"金顶洗车服务协议";
//    UIFont *serviceProtocolNameFont            = [UIFont boldSystemFontOfSize:16];
//    UILabel *serviceProtocolNameLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:serviceProtocolName font:serviceProtocolNameFont] font:serviceProtocolNameFont text:serviceProtocolName isCenter:NO];
//    serviceProtocolNameLabel.textColor         = [UIColor colorFromHex:@"#3868ce"];
//    serviceProtocolNameLabel.top               = contentNameLabel.bottom +Main_Screen_Height*100/667;
//    serviceProtocolNameLabel.centerX           = appImageView.centerX;
    
    UIButton *updateRuleButton          = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width*320/375, Main_Screen_Height*30/667)];
    [updateRuleButton setTitleColor:[UIColor colorFromHex:@"#0161a1"] forState:UIControlStateNormal];
    NSMutableAttributedString *title    = [[NSMutableAttributedString alloc] initWithString:@"金顶洗车服务协议"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:titleRange];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHex:@"3869ce"] range:NSMakeRange(0, 8)];
    [updateRuleButton setAttributedTitle:title forState:UIControlStateNormal];
    [updateRuleButton setBackgroundColor:[UIColor clearColor]];
    [updateRuleButton.titleLabel setFont:[UIFont systemFontOfSize:14*Main_Screen_Height/667]];
    [updateRuleButton addTarget:self action:@selector(agreeButtonByClick:) forControlEvents:UIControlEventTouchUpInside];
    updateRuleButton.top              = contentNameLabel.bottom +Main_Screen_Height*50/667;
    updateRuleButton.centerX          = appImageView.centerX;
    [self.scrollView addSubview:updateRuleButton];
    
    
    
    
    NSString *copyrightlName              = @"Copyright2017金顶汽车服务版权所有  鲁ICP备17040309号";
    UIFont *copyrightlNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *copyrightlNameLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:copyrightlName font:copyrightlNameFont] font:copyrightlNameFont text:copyrightlName isCenter:NO];
    copyrightlNameLabel.textColor         = [UIColor colorFromHex:@"#999999"];
    copyrightlNameLabel.top               = updateRuleButton.bottom +Main_Screen_Height*5/667;
    copyrightlNameLabel.centerX           = appImageView.centerX;
    
}
- (void) agreeButtonByClick:(id)sender {
    
    DSAgreementController *agreeController      = [[DSAgreementController alloc]init];
    agreeController.hidesBottomBarWhenPushed    = YES;
    [self.navigationController pushViewController:agreeController animated:YES];
    
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
