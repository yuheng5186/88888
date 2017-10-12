//
//  DSExchangeController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSExchangeController.h"
#import <Masonry.h>
#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"

@interface DSExchangeController ()
{
    UITextField *exchangeTF;
}

@end

@implementation DSExchangeController

- (void)drawNavigation {
    
    [self drawTitle:@"激活卡券"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)setupUI {
    
    exchangeTF = [[UITextField alloc] init];
    exchangeTF.placeholder = @"请输入激活码";
    exchangeTF.textAlignment = NSTextAlignmentCenter;
    exchangeTF.layer.cornerRadius = Main_Screen_Height*24/667;
    exchangeTF.keyboardType = UIKeyboardTypeASCIICapable;
    exchangeTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:exchangeTF];
    
    UIButton *exchangeBtn = [UIUtil drawDefaultButton:self.view title:@"激活" target:self action:@selector(didClickExchangeScoreBtn:)];
    
    [exchangeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(64 + Main_Screen_Height*23/667);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(Main_Screen_Width*351/375);
        make.height.mas_equalTo(Main_Screen_Height*48/667);
    }];
    
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exchangeTF.mas_bottom).mas_offset(Main_Screen_Height*60/667);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(Main_Screen_Width*351/375);
        make.height.mas_equalTo(Main_Screen_Height*48/667);
    }];

 }
                             
- (void)didClickExchangeScoreBtn:(UIButton *)button {
    
    
    if(exchangeTF.text.length == 0)
    {
        [self.view showInfo:@"请输入激活码" autoHidden:YES interval:2];
    }
    else
    {
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                 @"ActivationCode":exchangeTF.text
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/ActivationCard",Khttp] success:^(NSDictionary *dict, BOOL success) {
            
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                
                if([[[dict objectForKey:@"JsonData"] objectForKey:@"Activationstate"] integerValue] == 3)
                {
                    [self.view showInfo:@"对不起，该卡不存在" autoHidden:YES interval:2];
                }
                else if([[[dict objectForKey:@"JsonData"] objectForKey:@"Activationstate"] integerValue] == 1)
                {
                    [self.view showInfo:@"激活成功,你可以在我的卡包中进行查看" autoHidden:YES interval:2];
                }
                else if([[[dict objectForKey:@"JsonData"]objectForKey:@"Activationstate"] integerValue] == 2)
                {
                    if([[[dict objectForKey:@"JsonData"] objectForKey:@"CardUseState"] integerValue] == 1)
                    {
                        [self.view showInfo:@"对不起，该卡已被激活" autoHidden:YES interval:2];
                    }
                    else if([[[dict objectForKey:@"JsonData"] objectForKey:@"CardUseState"] integerValue] == 2)
                    {
                        [self.view showInfo:@"对不起，该卡已被使用" autoHidden:YES interval:2];
                    }
                    else{
                        [self.view showInfo:@"对不起，该卡已失效" autoHidden:YES interval:2];
                    }
                    
                    
                }
                else
                {
                    [self.view showInfo:@"激活失败" autoHidden:YES interval:2];
                }
                
                
            }
            else
            {
                [self.view showInfo:@"激活失败" autoHidden:YES interval:2];
            }
        } fail:^(NSError *error) {
            [self.view showInfo:@"激活失败" autoHidden:YES interval:2];
            
        }];

    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
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
