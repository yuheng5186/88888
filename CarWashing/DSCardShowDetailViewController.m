//
//  DSCardShowDetailViewController.m
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/9/25.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSCardShowDetailViewController.h"
#import "PayPurchaseCardController.h"
#import <Masonry.h>

@interface DSCardShowDetailViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation DSCardShowDetailViewController


- (void) drawNavigation {

    [self drawTitle:[NSString stringWithFormat:@"%@详情",self.choosecard.CardName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubView];

}

- (void) createSubView {

//    self.view.backgroundColor           = [UIColor whiteColor];
    
    self.scrollView                         = [[UIScrollView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.size.width, self.contentView.size.height)];
    self.scrollView.backgroundColor         = [UIColor colorFromHex:@"e5e5e5"];
    self.scrollView.contentSize             = CGSizeMake(self.contentView.size.width, self.contentView.size.height*1.1);
    [self.scrollView flashScrollIndicators];
    self.scrollView.contentInset     = UIEdgeInsetsMake(0, 0, Main_Screen_Height*100/667, 0);
    self.scrollView.directionalLockEnabled  = YES;
    self.scrollView.showsVerticalScrollIndicator  = NO;
    [self.view addSubview:self.scrollView];
    
//    self.contentView.backgroundColor    = [UIColor colorFromHex:@"#fefefe"];
    
    UIImageView *appImageView      = [UIUtil drawCustomImgViewInView:self.scrollView frame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*40/375, Main_Screen_Height*200/667) imageName:@"bg_card"];
    appImageView.top               = Main_Screen_Height*20/667;
    appImageView.centerX           = Main_Screen_Width/2;
    
    
    NSString *dicountString        = [NSString stringWithFormat:@"有效期%ld天",self.choosecard.ExpiredDay];
    UIFont *dicountFont            = [UIFont systemFontOfSize:14];
    UILabel *dicountLabel          = [UIUtil drawLabelInView:appImageView frame:[UIUtil textRect:dicountString font:dicountFont] font:dicountFont text:dicountString isCenter:NO];
    dicountLabel.textColor         = [UIColor colorFromHex:@"#999999"];
    dicountLabel.bottom            = appImageView.bottom -Main_Screen_Height*40/667;
    dicountLabel.left              = Main_Screen_Width*25/375;
    
//    NSString *dateString        = [NSString stringWithFormat:@"免费扫码洗车%ld次",self.choosecard.CardCount];
//    UIFont *dateFont            = [UIFont systemFontOfSize:Main_Screen_Height*15/667];
//    UILabel *dateLabel          = [UIUtil drawLabelInView:appImageView frame:[UIUtil textRect:dateString font:dateFont] font:dateFont text:dateString isCenter:NO];
//    dateLabel.textColor         = [UIColor colorFromHex:@"#ffffff"];
//    dateLabel.bottom            = dicountLabel.top -Main_Screen_Height*0/667;
//    dateLabel.right             = dicountLabel.right;
    
    NSString *titleName              = self.choosecard.CardName;
    UIFont *titleNameFont            = [UIFont boldSystemFontOfSize:18];
    UILabel *titleNameLabel          = [UIUtil drawLabelInView:appImageView frame:[UIUtil textRect:titleName font:titleNameFont] font:titleNameFont text:titleName isCenter:NO];
    titleNameLabel.textColor         = [UIColor blackColor];
    titleNameLabel.top               = Main_Screen_Height*20/667;
    titleNameLabel.left              = Main_Screen_Width*25/375;
    
    
    NSString *jindingString        = @"金顶洗车";
    UIFont *jindingFont            = [UIFont systemFontOfSize:10];
    UILabel *jindingLabel          = [UIUtil drawLabelInView:appImageView frame:[UIUtil textRect:jindingString font:jindingFont] font:jindingFont text:jindingString isCenter:NO];
    jindingLabel.textColor         = [UIColor blackColor];
    jindingLabel.bottom            = titleNameLabel.bottom;;
    jindingLabel.left              = titleNameLabel.right+Main_Screen_Width*5/375;
    
    
    NSString *saomaString        = @"扫码洗车服务中使用";
    UIFont *saomaFont            = [UIFont systemFontOfSize:14];
    UILabel *saomaLabel          = [UIUtil drawLabelInView:appImageView frame:[UIUtil textRect:saomaString font:saomaFont] font:saomaFont text:saomaString isCenter:NO];
    saomaLabel.textColor         = [UIColor blackColor];
    saomaLabel.top               = titleNameLabel.bottom +Main_Screen_Height*10/667;
    saomaLabel.left              = titleNameLabel.left;
    
    
    
    UIView *upView                  = [UIUtil drawLineInView:self.scrollView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*200/667) color:[UIColor colorFromHex:@"#e5e5e5"]];
    upView.backgroundColor          = [UIColor whiteColor];
    upView.top                      = appImageView.bottom +Main_Screen_Height*20/667;

    NSString *servceString              = @"服务内容";
    UIFont *servceFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *servceLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:servceString font:servceFont] font:servceFont text:servceString isCenter:NO];
//    servceLabel.textColor         = [UIColor colorFromHex:@"#999999"];
    servceLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];

    servceLabel.top               = Main_Screen_Height*10/667;
    servceLabel.left              = Main_Screen_Width*10/375;
    
    NSString *servceNumString        = [NSString stringWithFormat:@"可免费洗车%ld次",self.choosecard.CardCount];
    UIFont *servceNumFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *servceNumLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:servceNumString font:servceNumFont] font:servceNumFont text:servceNumString isCenter:NO];
    servceNumLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    servceNumLabel.top               = Main_Screen_Height*10/667;
    servceNumLabel.right             = Main_Screen_Width -Main_Screen_Width*10/375;
    
    NSString *servceShowString        = @"金顶自动洗车可使用";
    UIFont *servceShowFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *servceShowLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:servceShowString font:servceShowFont] font:servceShowFont text:servceShowString isCenter:NO];
    servceShowLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];

    servceShowLabel.top               =servceNumLabel.bottom +Main_Screen_Height*10/667;
    servceShowLabel.right             = Main_Screen_Width -Main_Screen_Width*10/375;
    
    NSString *servcePriceString        = @"原价";
    UIFont *servcePriceShowFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *servcePriceLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:servcePriceString font:servcePriceShowFont] font:servcePriceShowFont text:servcePriceString isCenter:NO];
    servcePriceLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];

    servcePriceLabel.top               = servceShowLabel.bottom +Main_Screen_Height*20/667;
    servcePriceLabel.left              = Main_Screen_Width*10/375;
    
    NSString *priceString        = [NSString stringWithFormat:@"￥%@",self.choosecard.CardPrice];
    UIFont *priceFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *priceLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:priceString font:priceFont] font:priceFont text:priceString isCenter:NO];
    priceLabel.top               = servceShowLabel.bottom +Main_Screen_Height*20/667;
    priceLabel.right             = Main_Screen_Width -Main_Screen_Width*10/375;
    
    UIView      *lineView   = [UIUtil drawLineInView:upView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*1/667) color:[UIColor colorFromHex:@"#e6e6e6"]];
    lineView.centerX        = Main_Screen_Width/2;
    lineView.top            = servcePriceLabel.bottom +Main_Screen_Height*20/667;
    
    NSString *salePriceString        = @"特惠活动";
    UIFont *salePriceShowFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *salePriceLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:salePriceString font:salePriceShowFont] font:salePriceShowFont text:salePriceString isCenter:NO];
    salePriceLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];

    salePriceLabel.top               = lineView.bottom +Main_Screen_Height*20/667;
    salePriceLabel.left              = Main_Screen_Width*10/375;
    
    NSString *saleString        = [NSString stringWithFormat:@"立减%@元",self.choosecard.DiscountPrice];
    UIFont *saleFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *saleLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:saleString font:saleFont] font:saleFont text:saleString isCenter:NO];
    saleLabel.textColor         = [UIColor colorFromHex:@"#ff3645"];
    saleLabel.top               = lineView.bottom +Main_Screen_Height*20/667;
    saleLabel.right             = Main_Screen_Width -Main_Screen_Width*10/375;
    
    upView.height   = saleLabel.bottom +Main_Screen_Height*20/667;
    
    
    
    UIView *downView                  = [UIUtil drawLineInView:self.scrollView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*320/667) color:[UIColor colorFromHex:@"#e5e5e5"]];
    downView.backgroundColor          = [UIColor whiteColor];
    downView.top                      = upView.bottom +Main_Screen_Height*10/667;
    
//    NSString *userString        = @"使用须知";
//    UIFont *userFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
//    UILabel *userLabel          = [UIUtil drawLabelInView:downView frame:[UIUtil textRect:userString font:userFont] font:userFont text:userString isCenter:NO];
//    userLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
//
//    userLabel.top               = Main_Screen_Height*10/667;
//    userLabel.left              = Main_Screen_Width*10/375;
//    
//    NSString *userNeedString        = @"1.此卡仅限清洗汽车外观，不得购买其它服务项目";
//    UIFont *userNeedFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
//    UILabel *userNeedLabel          = [UIUtil drawLabelInView:downView frame:[UIUtil textRect:userNeedString font:userNeedFont] font:userNeedFont text:userNeedString isCenter:NO];
//    userNeedLabel.textColor         = [UIColor colorFromHex:@"#999999"];
//    userNeedLabel.top               = userLabel.bottom +Main_Screen_Height*20/667;
//    userNeedLabel.left              = Main_Screen_Width*10/375;
//    
//    NSString *needString        = @"2.洗车卡不能兑换现金和转赠与其他人使用";
//    UIFont *needFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
//    UILabel *needLabel          = [UIUtil drawLabelInView:downView frame:[UIUtil textRect:needString font:needFont] font:needFont text:needString isCenter:NO];
//    needLabel.textColor         = [UIColor colorFromHex:@"#999999"];
//    needLabel.top               = userNeedLabel.bottom +Main_Screen_Height*20/667;
//    needLabel.left              = Main_Screen_Width*10/375;
    
    
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"使用须知";
    noticeLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    noticeLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    [downView addSubview:noticeLabel];
    
    
    UILabel *noticeLabelOne = [[UILabel alloc] init];
    noticeLabelOne.text = @"1、此卡仅限清洗汽车外观，不得购买其它服务项目";
    noticeLabelOne.numberOfLines = 0;
    noticeLabelOne.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabelOne.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    [downView addSubview:noticeLabelOne];
    
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView).mas_offset(12*Main_Screen_Height/667);
        make.left.equalTo(downView).mas_offset(12*Main_Screen_Height/667);
        make.height.mas_equalTo(30);
    }];
    
    [noticeLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLabel.mas_bottom).mas_offset(12*Main_Screen_Height/667);
        make.leading.equalTo(noticeLabel);
        make.right.equalTo(downView).mas_offset(-12*Main_Screen_Height/667);
        make.height.mas_equalTo(30);

    }];
    
    UILabel *noticeLabelTwo = [[UILabel alloc] init];
    noticeLabelTwo.text = @"2、洗车卡不能兑换现金和转赠与其他人使用";
    noticeLabelTwo.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabelTwo.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    [downView addSubview:noticeLabelTwo];
    UILabel *noticeLabelThree = [[UILabel alloc] init];
    noticeLabelThree.text = @"3、此卡一经售出，概不兑现。不记名，不挂失，不退卡，不补办";
    noticeLabelThree.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabelThree.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabelThree.numberOfLines = 0;
    [downView addSubview:noticeLabelThree];
    UILabel *noticeLabelFour = [[UILabel alloc] init];
    noticeLabelFour.text = @"4、此卡可在金顶服务点享受会员优惠待遇，不得与其它优惠同时使用";
    noticeLabelFour.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabelFour.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabelFour.numberOfLines = 0;
    [downView addSubview:noticeLabelFour];
    UILabel *noticeLabelFive = [[UILabel alloc] init];
    noticeLabelFive.text = @"5、由青岛金顶汽车服务有限公司保留此卡法律范围内的最终解释权。VIP热线：4006979558";
    noticeLabelFive.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabelFive.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabelFive.numberOfLines = 0;
    [downView addSubview:noticeLabelFive];
    
    
    [noticeLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLabelOne.mas_bottom).mas_offset(0*Main_Screen_Height/667);
        make.leading.equalTo(noticeLabelOne);
        make.right.equalTo(downView).mas_offset(-12*Main_Screen_Height/667);
        make.height.mas_equalTo(30);

    }];
    
    [noticeLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLabelTwo.mas_bottom).mas_offset(0*Main_Screen_Height/667);
        make.leading.equalTo(noticeLabelTwo);
        make.right.equalTo(downView).mas_offset(-12*Main_Screen_Height/667);
        make.height.mas_equalTo(40);

        
    }];
    [noticeLabelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLabelThree.mas_bottom).mas_offset(5*Main_Screen_Height/667);
        make.leading.equalTo(noticeLabelThree);
        make.right.equalTo(downView).mas_offset(-12*Main_Screen_Height/667);
        make.height.mas_equalTo(40);

        
    }];
    [noticeLabelFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeLabelFour.mas_bottom).mas_offset(5*Main_Screen_Height/667);
        make.leading.equalTo(noticeLabelFour);
        make.right.equalTo(downView).mas_offset(-12*Main_Screen_Height/667);
//        make.bottom.equalTo(downView).mas_offset(-12*Main_Screen_Height/667);
//        make.height.mas_equalTo(30);

    }];
    
//    downView.height = noticeLabelFive.bottom +Main_Screen_Height*10/667;
    
    UIView *backgroudView                  = [UIUtil drawLineInView:self.view frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*64/667) color:[UIColor whiteColor]];
    backgroudView.backgroundColor          = [UIColor whiteColor];
    backgroudView.bottom                   = Main_Screen_Height -Main_Screen_Height*0/667;
    
    
    
    UIButton    *buyButton      = [UIUtil drawDefaultButton:self.view title:@"立即购买" target:self action:@selector(buyButtonClick:)];
    buyButton.centerX           = Main_Screen_Width/2;
    buyButton.centerY           = backgroudView.centerY;
}
- (void) buyButtonClick:(id)sender {

//    Card *card = (Card *)[_CardArray objectAtIndex:_Xuhao];
    PayPurchaseCardController *payCardVC = [[PayPurchaseCardController alloc] init];
    payCardVC.hidesBottomBarWhenPushed = YES;
    payCardVC.choosecard = self.choosecard;
    [self.navigationController pushViewController:payCardVC animated:YES];

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
