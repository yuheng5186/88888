//
//  DSPasswordController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSPasswordController.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "UdStorage.h"
#import "HTTPDefine.h"
@interface DSPasswordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton * submitButton;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *userMobileFieldText;
@property (nonatomic, strong) UITextField *verifyFieldText;
@property (nonatomic, strong) UITextField *passwordNewFieldText;
@property (nonatomic, strong) UITextField *passwordAgainFieldText;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int second;
@property (nonatomic, strong) UIButton *getVeriifyStringButton;
@property (nonatomic, strong) UIButton *resendFakeBtn;


@end

@implementation DSPasswordController

- (void)drawNavigation {
        [self drawTitle:@"密码管理"];
    
}

- (void) drawContent
{
    self.contentView.top                = self.navigationView.bottom;
    self.contentView.height             = self.view.height;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubView];
}

- (void) createSubView {
    
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height*280/667) style:UITableViewStyleGrouped];
    self.tableView.top              = Main_Screen_Height*10/667;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.scrollEnabled    = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView  = [UIView new];
//    self.tableView.tableHeaderView  = [UIView new];
    [self.contentView addSubview:self.tableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    submitButton      = [UIUtil drawDefaultButton:self.contentView title:@"提交" target:self action:@selector(submitButtonClick:)];
    submitButton.top           = self.tableView.bottom +Main_Screen_Height*40/667;
    submitButton.centerX       = Main_Screen_Width/2;
    
}
- (void) submitButtonClick:(id)sender {
    

    [self.verifyFieldText resignFirstResponder];
    
    [self.userMobileFieldText resignFirstResponder];
    
//    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
//    submitButton.enabled = NO;
    if (self.passwordNewFieldText.text.length!=6) {
        [self.view showInfo:@"请输入6位密码" autoHidden:YES interval:2];
        return;
    }
    if (![self.passwordNewFieldText.text isEqualToString:self.passwordAgainFieldText.text]) {
        [self.view showInfo:@"两次密码输入不一致" autoHidden:YES interval:2];
        return;
    }
    if ([LCMD5Tool valiMobile:self.userMobileFieldText.text]) {
        if (self.verifyFieldText.text.length == 4) {
            
            NSDictionary *mulDic = @{
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                     @"Mobile":self.userMobileFieldText.text,
                                     @"PassWord":self.passwordNewFieldText.text,
                                     @"VerCode":self.verifyFieldText.text
                                     
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/PassWordManage",Khttp] success:^(NSDictionary *dict, BOOL success) {
                
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self.view showInfo:@"验证码不正确" autoHidden:YES interval:2];
                    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
                    submitButton.enabled = YES;
                }
                
            } fail:^(NSError *error) {
                [self.view showInfo:@"提交失败" autoHidden:YES interval:2];
                [submitButton setTitle:@"提交" forState:UIControlStateNormal];
                submitButton.enabled = YES;
            }];
            
            
            
            
            
        }else{
            [self.view showInfo:@"请输入4位验证码！" autoHidden:YES interval:2];
            [submitButton setTitle:@"提交" forState:UIControlStateNormal];
            submitButton.enabled = YES;
        }
        
    }else {
        [self.view showInfo:@"请输入正确的手机号码" autoHidden:YES];
        [submitButton setTitle:@"提交" forState:UIControlStateNormal];
        submitButton.enabled = YES;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*Main_Screen_Height/667;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 10.0f*Main_Screen_Height/667;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.backgroundColor    = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        cell.imageView.image                = [UIImage imageNamed:@"yonghushouji"];
        
        self.userMobileFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(10*Main_Screen_Height/667, 45*Main_Screen_Height/667, Main_Screen_Width-Main_Screen_Width*70/375, Main_Screen_Height*40/667)];
        self.userMobileFieldText.placeholder    = @"请输入手机号码";
        self.userMobileFieldText.delegate       = self;
        self.userMobileFieldText.clearButtonMode= UITextFieldViewModeAlways;
        self.userMobileFieldText.returnKeyType  = UIReturnKeyDone;
        self.userMobileFieldText.keyboardType   = UIKeyboardTypeNumberPad;

        self.userMobileFieldText.textAlignment  = NSTextAlignmentLeft;
        self.userMobileFieldText.font           = [UIFont systemFontOfSize:14];
        self.userMobileFieldText.backgroundColor= [UIColor whiteColor];
        self.userMobileFieldText.top            = Main_Screen_Height*5/667;
        self.userMobileFieldText.left           = Main_Screen_Width*70/375 ;
        
        [self.userMobileFieldText addTarget:self action:@selector(userMobileFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.userMobileFieldText];
    }else if (indexPath.section == 1){
        cell.imageView.image                = [UIImage imageNamed:@"mimayanzheng"];
        
        self.verifyFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(10*Main_Screen_Height/667, 45*Main_Screen_Height/667, Main_Screen_Width-Main_Screen_Width*240/375, Main_Screen_Height*40/667)];
        self.verifyFieldText.placeholder    = @"输入验证码";
        self.verifyFieldText.delegate       = self;
        self.verifyFieldText.returnKeyType  = UIReturnKeyDone;
        self.verifyFieldText.textAlignment  = NSTextAlignmentLeft;
        self.verifyFieldText.font           = [UIFont systemFontOfSize:14];
        self.verifyFieldText.clearButtonMode= UITextFieldViewModeAlways;
        self.verifyFieldText.keyboardType   = UIKeyboardTypeNumberPad;

        //        self.verifyFieldText.backgroundColor= [UIColor grayColor];
        self.verifyFieldText.top            = Main_Screen_Height*5/667;
        self.verifyFieldText.left           = Main_Screen_Width*70/375 ;
        
        [self.verifyFieldText addTarget:self action:@selector(verifyFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.verifyFieldText];
        
        NSString *getVeriifyString      = @"获取验证码";
        UIFont *getVeriifyStringFont          = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
        _getVeriifyStringButton      = [UIUtil drawButtonInView:cell.contentView frame:CGRectMake(0, 0, Main_Screen_Width*90/375, Main_Screen_Height*30/667) text:getVeriifyString font:getVeriifyStringFont color:[UIColor whiteColor] target:self action:@selector(getVeriifyButtonClick:)];
        _getVeriifyStringButton.backgroundColor=  RGBAA(253, 167, 9, 1.0);
        _getVeriifyStringButton.layer.cornerRadius = Main_Screen_Height*15/667;
        _getVeriifyStringButton.right          = Main_Screen_Width -Main_Screen_Width*10/375;
        _getVeriifyStringButton.top            = Main_Screen_Height*10/667;
    }else if (indexPath.section == 2){
        cell.imageView.image                = [UIImage imageNamed:@"mimasuo"];
        
        self.passwordNewFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(10, 45, Main_Screen_Width-Main_Screen_Width*70/375, Main_Screen_Height*40/667)];
        self.passwordNewFieldText.placeholder    = @"请输入新密码";
        self.passwordNewFieldText.delegate       = self;
        self.passwordNewFieldText.returnKeyType  = UIReturnKeyDone;
        self.passwordNewFieldText.clearButtonMode= UITextFieldViewModeAlways;
        self.passwordNewFieldText.textAlignment  = NSTextAlignmentLeft;
        self.passwordNewFieldText.font           = [UIFont systemFontOfSize:14];
        self.passwordNewFieldText.backgroundColor= [UIColor whiteColor];
        self.passwordNewFieldText.top            = Main_Screen_Height*5/667;
        self.passwordNewFieldText.left           = Main_Screen_Width*70/375 ;
        
        [self.verifyFieldText addTarget:self action:@selector(passwordNewFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.passwordNewFieldText];
    }else{
        cell.imageView.image                = [UIImage imageNamed:@"mimasuo"];
        
        self.passwordAgainFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(10*Main_Screen_Height/667, 45*Main_Screen_Height/667, Main_Screen_Width-Main_Screen_Width*70/375, Main_Screen_Height*40/667)];
        self.passwordAgainFieldText.placeholder    = @"再次输入密码";
        self.passwordAgainFieldText.delegate       = self;
        self.passwordAgainFieldText.returnKeyType  = UIReturnKeyDone;
        self.passwordAgainFieldText.textAlignment  = NSTextAlignmentLeft;
        self.passwordAgainFieldText.clearButtonMode= UITextFieldViewModeAlways;
        self.passwordAgainFieldText.font           = [UIFont systemFontOfSize:14];
        self.passwordAgainFieldText.backgroundColor= [UIColor whiteColor];
        self.passwordAgainFieldText.top            = Main_Screen_Height*5/667;
        self.passwordAgainFieldText.left           = Main_Screen_Width*70/375 ;
        
        [self.passwordAgainFieldText addTarget:self action:@selector(passwordAgainFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.passwordAgainFieldText];
    
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
}


- (void) userMobileFieldTextChanged:(UITextField *)sender {


}
- (void) verifyFieldTextChanged: (UITextField *) sender
{

}
- (void) getVeriifyButtonClick:(id)sender {
    if ([LCMD5Tool valiMobile:self.userMobileFieldText.text]) {
        
        
        [self startTimer];
        [self.view showInfo:@"验证码发送成功，请在手机上查收！" autoHidden:YES interval:2];
        
        NSDictionary *mulDic = @{@"Mobile":self.userMobileFieldText.text};
        
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        
        
        NSLog(@"%@",params);
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/GetVerCode",Khttp] success:^(NSDictionary *dict, BOOL success) {
            NSLog(@"%@",dict);
        } fail:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }else
    {
        [self.view showInfo:@"请输入正确的手机号码" autoHidden:YES];
        
    }

}

- (void) passwordNewFieldTextChanged: (UITextField *) sender
{
    
}
- (void) passwordAgainFieldTextChanged: (UITextField *) sender
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {

}


- (void)startTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.second = 60;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self.timer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)onTimer
{
    if (self.second == 0) {
        
        [self.view showInfo:@"未收到验证码，请点击重新发送！" autoHidden:YES interval:2];
        self.getVeriifyStringButton.hidden = NO;
        self.resendFakeBtn.hidden = NO;
        self.getVeriifyStringButton.enabled = YES;
        self.resendFakeBtn.enabled = YES;
        [self.getVeriifyStringButton setTitle:@"重新发送" forState:UIControlStateNormal];
        //                [self.resendBtn setTitle:NSLocalizedString(@"Resend Code", nil) forState:UIControlStateNormal];
        //        self.secondLbl.text = @"";
        //        self.secondLbl.hidden = YES;
        [self.timer invalidate];
        
    } else {
        //        self.resendBtn.hidden = YES;
        self.getVeriifyStringButton.enabled = NO;
        self.resendFakeBtn.enabled = NO;
        //        [self.resendBtn setTitle:NSLocalizedString(@"Waiting", nil) forState:UIControlStateNormal];
        //        self.secondLbl.hidden = NO;
        NSString *text = [NSString stringWithFormat:@"%d%@",self.second--,@"s"];
        [self.getVeriifyStringButton setTitle:text forState:UIControlStateNormal];
    }
}


@end
