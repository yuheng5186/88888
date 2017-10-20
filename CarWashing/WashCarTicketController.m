//
//  WashCarTicketController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "WashCarTicketController.h"
#import "CarTicketView.h"
#import <Masonry.h>

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AppDelegate.h"

@interface WashCarTicketController ()

@end

@implementation WashCarTicketController


- (void)drawNavigation {
    
    [self drawTitle:self.card.CardName];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *upView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*328/667) color:[UIColor colorFromHex:@"#fafafa"]];
    upView.top                      = 0;
    CarTicketView *ticketView = [CarTicketView carTicketView];
//    ticketView.frame = CGRectMake(37.5*Main_Screen_Height/667, 64 + 25*Main_Screen_Height/667, Main_Screen_Width - 75*Main_Screen_Height/667, 192*Main_Screen_Height/667);
    ticketView.backgroundColor = self.view.backgroundColor;
    
//    ticketView.CardName.text = self.card.CardName;
    
    ticketView.BackImgV.image = [UIImage imageNamed:@"bg_card"];

//    if(self.card.CardType == 1)
//    {
//        ticketView.BackImgV.image = [UIImage imageNamed:@"qw_tiyanka"];
//    }else if(self.card.CardType == 2)
//    {
//        ticketView.BackImgV.image = [UIImage imageNamed:@"qw_yueka"];
//    }else if(self.card.CardType == 3)
//    {
//        ticketView.BackImgV.image = [UIImage imageNamed:@"qw_cika"];
//    }else if(self.card.CardType == 4)
//    {
//        ticketView.BackImgV.image = [UIImage imageNamed:@"qw_nianka"];
//    }
    
    
    ticketView.ScoreLabel.text = [NSString stringWithFormat:@"%ld积分",self.card.Integralnum];

    [upView addSubview:ticketView];
    
    UIButton *exchangeButton = [UIUtil drawDefaultButton:upView title:[NSString stringWithFormat:@"%ld积分兑换",self.card.Integralnum] target:self action:@selector(didClickExhangeButton:)];
     if(self.card.Integralnum > [self.CurrentScore integerValue])
     {
         [exchangeButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHex:@"#e6e6e6"]] forState:UIControlStateNormal];
         exchangeButton.enabled=NO;
     }
    
    [ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView).mas_offset(25*Main_Screen_Height/667);
        make.left.equalTo(upView).mas_offset(22.5*Main_Screen_Height/667);
        make.right.equalTo(upView).mas_offset(-22.5*Main_Screen_Height/667);
        make.height.mas_equalTo(190*Main_Screen_Height/667);
    }];
    
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ticketView.mas_bottom).mas_offset(50*Main_Screen_Height/667);
        make.centerX.equalTo(upView);
        make.height.mas_equalTo(48*Main_Screen_Height/667);
        make.width.mas_equalTo(350*Main_Screen_Height/667);
    }];
    
    UIView *downView                = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*270/667) color:[UIColor whiteColor]];
    downView.top                    = upView.bottom;
    //
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"使用须知";
    noticeLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    noticeLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    [downView addSubview:noticeLabel];
    
    
    UILabel *noticeLabel1 = [[UILabel alloc] init];
    noticeLabel1.text = @"1. 下载金顶洗车APP，通过扫码可直接启动洗车机；";
    noticeLabel1.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel1.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel1.numberOfLines = 0;
    [downView addSubview:noticeLabel1];
    
    
    UILabel *noticeLabel2 = [[UILabel alloc] init];
    noticeLabel2.text = @"2. 整个洗车过程请遵照洗车提示和工作人员引导；";
    noticeLabel2.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel2.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel2.numberOfLines = 0;
    [downView addSubview:noticeLabel2];
    
    
    UILabel *noticeLabel3 = [[UILabel alloc] init];
    noticeLabel3.text = @"3. 此卡请在有效期内使用，不退卡、不转让、不挂失；";
    noticeLabel3.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel3.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel3.numberOfLines = 0;
    [downView addSubview:noticeLabel3];
    
    
    UILabel *noticeLabel4 = [[UILabel alloc] init];
    noticeLabel4.text = @"4. 启动前请确保外置天线、反光镜已经收起，车窗等处于关闭、全车处于隔水状态，自行改装外饰确保不妨碍洗车；";
    noticeLabel4.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel4.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel4.numberOfLines = 0;
    [downView addSubview:noticeLabel4];
    
    
    UILabel *noticeLabel5 = [[UILabel alloc] init];
    noticeLabel5.text = @"5. 请不要在洗车过程中随意上下车，若出现问题或者故障可咨询工作人员或拨打客服电话进行咨询";
    noticeLabel5.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel5.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel5.numberOfLines = 0;
    [downView addSubview:noticeLabel5];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(downView).mas_offset(10*Main_Screen_Height/667);
    }];
    
    [noticeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [noticeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel1.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [noticeLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel2.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [noticeLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel3.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [noticeLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel4.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
}
                                
- (void)didClickExhangeButton:(UIButton *)button {
    
    
    if(self.card.Integralnum > [self.CurrentScore integerValue])
    {
        [self.view showInfo:@"积分不足" autoHidden:YES interval:2];
    }
    else
    {
        NSString *scordstr= [NSString stringWithFormat:@"-%ld积分",self.card.Integralnum];
    // 创建对象.
    NSString *stringForColor = @"red";
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:scordstr];
    //
    NSRange range = [scordstr rangeOfString:stringForColor];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
   
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认兑换" message:scordstr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *datenow = [NSDate date];
            NSDate *newDate = [datenow dateByAddingTimeInterval:60 * 60 * 24 * self.card.ExpiredDay];
            
            
            NSDictionary *mulDic = @{
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                     @"ConfigCode":[NSString stringWithFormat:@"%ld",self.card.ConfigCode],
                                     @"UseLevel":@1,
                                     @"GetCardType":[NSString stringWithFormat:@"%ld",self.card.GetCardType],
                                     @"Area":self.card.Area,
                                     @"CardCount":[NSString stringWithFormat:@"%ld",self.card.CardCount],
                                     @"CardName":self.card.CardName,
                                     @"CardPrice":[NSString stringWithFormat:@"%@",self.card.CardPrice],
                                     @"CardType":[NSString stringWithFormat:@"%ld",self.card.CardType],
                                     @"Description":self.card.Description,
                                     @"ExpStartDates":[NSString stringWithFormat:@"%@",[formatter stringFromDate:datenow]],
                                     @"ExpEndDates":[NSString stringWithFormat:@"%@",[formatter stringFromDate:newDate]],
                                     @"Integralnum": [NSString stringWithFormat:@"%ld",self.card.Integralnum],
                                     };
            
            
            NSLog(@"%@",mulDic);
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/ReceiveCardInfo",Khttp] success:^(NSDictionary *dict, BOOL success) {
                
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {
                    [self.view showInfo:@"兑换成功" autoHidden:YES interval:2];
                    
                    APPDELEGATE.currentUser.UserScore = APPDELEGATE.currentUser.UserScore - self.card.Integralnum;
                    
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
                    
                    
                    NSNotification * notice = [NSNotification notificationWithName:@"updatecard" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    
                    
                    
                }
                else
                {
                    [self.view showInfo:@"兑换失败" autoHidden:YES interval:2];
                }
            } fail:^(NSError *error) {
                [self.view showInfo:@"兑换失败" autoHidden:YES interval:2];
                
            }];
            
        }];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
       

    }
    
    
    
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
