//
//  DSChangeNameController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSChangeNameController.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AppDelegate.h"
#import "HowToUpGradeController.h"
#import "EarnScoreController.h"
#import "DSMembershipController.h"

#import "MBProgressHUD.h"

@interface DSChangeNameController ()<UITextFieldDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) UITextField *userNameText;

@end

@implementation DSChangeNameController

- (void)drawNavigation {
    
    [self drawTitle:@"修改姓名"];
    [self drawRightTextButton:@"确定" action:@selector(buttonClick:)];
    
}
- (void) buttonClick:(id)sender {
    
    [self.userNameText resignFirstResponder];
    
    if (self.userNameText.text.length > 0) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide =YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                 @"ModifyType":@"2",
                                 @"Name":self.userNameText.text
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/UserInfoEdit",Khttp] success:^(NSDictionary *dict, BOOL success) {
            
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                
                
                HUD.mode = MBProgressHUDModeCustomView;
                
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.animationType = MBProgressHUDAnimationZoom;
                HUD.removeFromSuperViewOnHide = YES;
                
                
                
                
                HUD.completionBlock = ^(){
                    
                    
                    APPDELEGATE.currentUser.userName = self.userNameText.text;
                    
                    [UdStorage storageObject:APPDELEGATE.currentUser.userName forKey:@"Name"];
                    NSNotification * notice = [NSNotification notificationWithName:@"updatenamesuccess" object:nil userInfo:@{@"username":self.userNameText.text}];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    
                    
                    
                    NSArray *vcsArray = [NSArray array];
                    vcsArray= [self.navigationController viewControllers];
                    NSInteger vcCount = vcsArray.count;
                    
                    
                    
                    if(vcCount <= 3)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                    else
                    {
                        UIViewController *lastVC = vcsArray[vcCount-3];
                        UIViewController *lasttwoVC = vcsArray[vcCount-4];
                        int index=[[self.navigationController viewControllers]indexOfObject:self];
                        
                        if([lastVC isKindOfClass:[HowToUpGradeController class]])
                        {
                            
                            NSNotification * notice = [NSNotification notificationWithName:@"Earnsuccess" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter]postNotification:notice];
                            
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3]animated:YES];
                        }
                        else if([lastVC isKindOfClass:[EarnScoreController class]])
                        {
                            if([lasttwoVC isKindOfClass:[DSMembershipController class]])
                            {
                                NSNotification * notice = [NSNotification notificationWithName:@"Earnsuccess" object:nil userInfo:nil];
                                [[NSNotificationCenter defaultCenter]postNotification:notice];
                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3]animated:YES];
                            }
                            NSNotification * notice = [NSNotification notificationWithName:@"Earnsuccess" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter]postNotification:notice];
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-4]animated:YES];
                        }
                        
                        
                    }
                    
                    
                    
                    
                };
                
                [HUD hide:YES afterDelay:1.f];
                
            }
            else
            {
                [HUD hide:YES];
                [self.view showInfo:@"修改失败" autoHidden:YES interval:2];
            }
            
        } fail:^(NSError *error) {
            [HUD hide:YES];
            [self.view showInfo:@"修改失败" autoHidden:YES interval:2];
        }];
        
    }else{
    
        [self.view showInfo:@"请输入内容，再点击确定" autoHidden:YES interval:2];

    }
    
}

- (void) drawContent
{
    self.contentView.top                = self.navigationView.bottom;
    self.contentView.height             = self.view.height;}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubView];
}
- (void) createSubView {

    UIView *upView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*50/667) color:[UIColor whiteColor]];
    upView.top                      = 10;
    
    self.userNameText                = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40*Main_Screen_Height/667)];
    //        self.phoneNumberText.placeholder    = @"输入验证码";
    self.userNameText.placeholder    = APPDELEGATE.currentUser.userName;
//    self.userNameText.text           = @"15800781856";
    self.userNameText.delegate       = self;
    self.userNameText.returnKeyType  = UIReturnKeyDone;
    self.userNameText.textAlignment  = NSTextAlignmentLeft;
    self.userNameText.font           = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    self.userNameText.backgroundColor= [UIColor whiteColor];
    self.userNameText.top            = Main_Screen_Height*5/667;
    self.userNameText.left           = Main_Screen_Width*20/375 ;
    
    [self.userNameText addTarget:self action:@selector(userNameTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [upView addSubview:self.userNameText];

}
- (void) userNameTextChanged:(UITextField *)sender {


}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
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
