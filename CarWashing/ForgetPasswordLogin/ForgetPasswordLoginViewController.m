//
//  ForgetPasswordLoginViewController.m
//  CarWashing
//
//  Created by apple on 2017/9/27.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ForgetPasswordLoginViewController.h"
#import "MenuTabBarController.h"
#import "AppDelegate.h"
#import "DSAgreementController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "KPIndicatorView.h"
#import <Masonry.h>

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "UdStorage.h"
#import "HTTPDefine.h"

#import "IQKeyboardManager.h"
@interface ForgetPasswordLoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    KPIndicatorView *_indicatorView;
    UIButton  *loginButton;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *userMobileFieldText;
@property (nonatomic, strong) UITextField *verifyFieldText;
@property (nonatomic, strong) UITextField *passwordFieldText;
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int second;
@property (nonatomic, strong) UIButton *getVeriifyStringButton;
@property (nonatomic, strong) UIButton *resendFakeBtn;
@end

@implementation ForgetPasswordLoginViewController
- (void)drawNavigation {
    [self drawTitle:@"忘记密码"];
    
}

- (void) drawContent
{
    self.statusView.backgroundColor         = [UIColor whiteColor];
    self.navigationView.hidden              = YES;
    self.contentView.backgroundColor        = [UIColor whiteColor];
    self.contentView.top                    = self.statusView.bottom;
    self.contentView.height                 = self.view.height;
    self.view.backgroundColor               = [UIColor whiteColor];
    
}
- (void) dealloc
{
    [self.timer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    [self createSubView];
}
- (void) createSubView {
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    backBtn.backgroundColor=[UIColor redColor];
    backBtn.frame=CGRectMake(0, 0, Main_Screen_Width*150/375, Main_Screen_Height*40/667);
    backBtn.top  = Main_Screen_Height/667;
    UIImageView * backimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
    backimage.image=[UIImage imageNamed:@"dengluyefanhui"];
    
    [backBtn addSubview:backimage];
    [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:backBtn];
    
    NSString   *headerString     = @"忘记密码";
    UIFont     *headerFont       = [UIFont systemFontOfSize:Main_Screen_Height*20/667];
    UILabel *deaderLabel         = [UIUtil drawLabelInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*150/375, Main_Screen_Height*30/667) font:headerFont text:headerString isCenter:NO];
    deaderLabel.textColor        = [UIColor blackColor];
    deaderLabel.textAlignment    = NSTextAlignmentCenter;
    
    deaderLabel.centerX          = Main_Screen_Width/2;
    deaderLabel.top              = Main_Screen_Height/667;
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height*40/667, Main_Screen_Width, 1)];
    lineView.backgroundColor=RGBAA(242, 242, 242, 1.0);
    [self.contentView addSubview:lineView];
    
    UIImageView *logoImageView  = [UIUtil drawCustomImgViewInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*100/375, Main_Screen_Height*100/667) imageName:@"denglu_icon"];
    logoImageView.layer.masksToBounds = YES;
    //    logoImageView.layer.cornerRadius = logoImageView.size.width/2;
    logoImageView.top           = deaderLabel.bottom +Main_Screen_Height*30/667;
    logoImageView.centerX       = Main_Screen_Width/2;
    
    NSString   *titleString     = @"金顶洗车";
    //    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:titleString];
    //    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-20 * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFont     *titleFont       = [UIFont boldSystemFontOfSize:Main_Screen_Height*25/667];
    UILabel *titleLabel         = [UIUtil drawLabelInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*150/375, Main_Screen_Height*30/667) font:titleFont text:titleString isCenter:NO];
    //    titleLabel.attributedText   = attributed;
    //    titleLabel.transform        = matrix;
    titleLabel.text             = titleString;
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    
    
    titleLabel.centerX          = Main_Screen_Width/2;
    titleLabel.top              = logoImageView.bottom +Main_Screen_Height*20/667;
    
    NSString   *welcomeString     = @"欢迎登录金顶洗车APP";
    UIFont     *welcomeFont       = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *welcomeLabel         = [UIUtil drawLabelInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*200/375, Main_Screen_Height*30/667) font:welcomeFont text:welcomeString isCenter:NO];
    welcomeLabel.textColor        = [UIColor colorFromHex:@"#0161a1"];
    welcomeLabel.textAlignment    = NSTextAlignmentCenter;
    welcomeLabel.centerX          = Main_Screen_Width/2;
    welcomeLabel.top              = titleLabel.bottom +Main_Screen_Height*10/667;
    
    
    //    UIImage *backgroundImage            = [UIImage imageNamed:@"dengluditu"];
    UIImageView  *backgroundImageView   = [UIUtil drawCustomImgViewInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width-10, Main_Screen_Height*380/667) imageName:@"dengluditu"];
    backgroundImageView.top             = welcomeLabel.bottom-20;
    backgroundImageView.centerX         = Main_Screen_Width/2;
    
    
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*280/375,Main_Screen_Height*150/667) style:UITableViewStyleGrouped];
    self.tableView.top              = backgroundImageView.top +Main_Screen_Height*100/667;
    self.tableView.centerX          = backgroundImageView.centerX-Main_Screen_Width*10/375;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.scrollEnabled    = NO;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor  = [UIColor whiteColor];
    self.tableView.tableFooterView  = [UIView new];
    [self.contentView addSubview:self.tableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    NSString   *remindString     = @"";
    UIFont     *remindFont       = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *remindLabel         = [UIUtil drawLabelInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*250/375, Main_Screen_Height*30/667) font:remindFont text:remindString isCenter:NO];
    remindLabel.textColor        = [UIColor colorFromHex:@"#999999"];
    remindLabel.textAlignment    = NSTextAlignmentCenter;
    remindLabel.centerX          = Main_Screen_Width/2;
    remindLabel.top              = self.tableView.bottom +Main_Screen_Height*20/667;
    
    NSString *buttonString        = @"登录";
    UIFont   *buttonFont          = [UIFont systemFontOfSize:Main_Screen_Height*16/667];
    loginButton        = [UIUtil drawButtonInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*280/375, Main_Screen_Height*45/667) text:buttonString font:buttonFont color:[UIColor colorFromHex:@"#ffffff"] target:self action:@selector(loginButtonClick:)];
    loginButton.backgroundColor   = [UIColor colorFromHex:@"#0161a1"];
    loginButton.tintColor         = [UIColor whiteColor];
    loginButton.layer.cornerRadius  = Main_Screen_Height*5/667;
    loginButton.bottom            = backgroundImageView.bottom -Main_Screen_Height*75/667;
    loginButton.centerX           = Main_Screen_Width/2;
    
    _indicatorView = [[KPIndicatorView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Height*35/667, Main_Screen_Height*35/667)];
    _indicatorView.bottom            = backgroundImageView.bottom -Main_Screen_Height*70/667;
    _indicatorView.centerX           = Main_Screen_Width/2;
    [self.contentView addSubview:_indicatorView];
    
//    UIButton * ForgetpasswordBtn = [UIButton buttonWithType: UIButtonTypeSystem];
//    [ForgetpasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [ForgetpasswordBtn setTitleColor:[UIColor colorFromHex:@"#999999"] forState:UIControlStateNormal];
//    ForgetpasswordBtn.titleLabel.font=[UIFont systemFontOfSize:Main_Screen_Height*12/667];
//    ForgetpasswordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    ForgetpasswordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [ForgetpasswordBtn addTarget:self action:@selector(ForgetpasswordBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:ForgetpasswordBtn];
//    [ForgetpasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginButton.mas_bottom);
//        make.left.equalTo(loginButton.mas_left);
//        make.size.mas_equalTo(CGSizeMake(100, Main_Screen_Height*40/667));
//    }];
    UIButton * checkLoginBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [checkLoginBtn setTitle:@"验证码登录?" forState:UIControlStateNormal];
    [checkLoginBtn setTitleColor:[UIColor colorFromHex:@"#999999"] forState:UIControlStateNormal];
    checkLoginBtn.titleLabel.font=[UIFont systemFontOfSize:Main_Screen_Height*12/667];
    checkLoginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    checkLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [checkLoginBtn addTarget:self action:@selector(checkLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkLoginBtn];
    [checkLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom);
        make.right.equalTo(loginButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(100, Main_Screen_Height*40/667));
    }];
    
//    UIButton *updateRuleButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width*320/375, Main_Screen_Height*30/667)];
//    [updateRuleButton setTitleColor:[UIColor colorFromHex:@"#0161a1"] forState:UIControlStateNormal];
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"注册即为同意《金顶洗车用户服务协议》"];
//    NSRange titleRange = {0,[title length]};
//    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:titleRange];
//    [title addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 6)];
//    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHex:@"#0161a1"] range:NSMakeRange(6, 12)];
//    
//    [updateRuleButton setAttributedTitle:title forState:UIControlStateNormal];
//    [updateRuleButton setBackgroundColor:[UIColor clearColor]];
//    [updateRuleButton.titleLabel setFont:[UIFont systemFontOfSize:Main_Screen_Height*14/667]];
//    [updateRuleButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    updateRuleButton.top              = loginButton.bottom +Main_Screen_Height*40/667;
//    updateRuleButton.centerX          = loginButton.centerX;
//    [self.contentView addSubview:updateRuleButton];
    [self.scrollView addSubview:self.contentView];
    [self.view addSubview:self.scrollView];
    
    
}
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.contentView.bounds];
    }
    return _scrollView;
}

- (void) loginButtonClick:(id)sender {
    
    [self.verifyFieldText resignFirstResponder];
    
    [self.userMobileFieldText resignFirstResponder];
    [self.passwordFieldText resignFirstResponder];
    
//    [_indicatorView startAnimating];
//    [loginButton setTitle:@"" forState:UIControlStateNormal];
//    loginButton.enabled = NO;
    if (self.userMobileFieldText.text.length==0) {
        [self.view showInfo:@"请输入手机号" autoHidden:YES interval:2];
        return;
    }
    if (self.verifyFieldText.text.length==0) {
        [self.view showInfo:@"请输入验证码" autoHidden:YES interval:2];
        return;
    }
    if (self.passwordFieldText.text.length==0) {
        [self.view showInfo:@"请输入新密码" autoHidden:YES interval:2];
        return;
    }
    if ([LCMD5Tool valiMobile:self.userMobileFieldText.text]) {
        if (self.passwordFieldText.text.length >= 6) {
            
            
            
            NSDictionary *mulDic = @{
                                     @"LoginType":@(2),
                                     @"Mobile":self.userMobileFieldText.text,
                                     @"PassWord":self.passwordFieldText.text,
                                     @"VerCode":self.verifyFieldText.text
                                     
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            NSLog(@"%@",params);
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/Login",Khttp] success:^(NSDictionary *dict, BOOL success) {
                NSLog(@"%@",dict);
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {
                    
                    
                    APPDELEGATE.currentUser = [User getInstanceByDic:[dict objectForKey:@"JsonData"]];
                    
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.Account_Id] forKey:@"Account_Id"];
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.Level_id] forKey:@"Level_id"];
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.ModifyType] forKey:@"ModifyType"];
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.VerCode] forKey:@"VerCode"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.userName forKey:@"Name"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.Accountname forKey:@"UserName"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.userImagePath forKey:@"Headimg"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.userPhone forKey:@"Mobile"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.userSex forKey:@"Sex"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.userAge forKey:@"Age"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.userhobby forKey:@"Hobby"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.usermemo forKey:@"Memo"];
                    [UdStorage storageObject:APPDELEGATE.currentUser.useroccupation forKey:@"Occupation"];
                    
                    MenuTabBarController *menuTabBarController              = [[MenuTabBarController alloc] init];
                    [AppDelegate sharedInstance].window.rootViewController  = menuTabBarController;
                }
                else
                {
                    [self.view showInfo:@"密码不正确" autoHidden:YES interval:2];
                    [_indicatorView stopAnimating];
                    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
                    loginButton.enabled = YES;
                }
                
            } fail:^(NSError *error) {
                [self.view showInfo:@"登录失败" autoHidden:YES interval:2];
                [_indicatorView stopAnimating];
                [loginButton setTitle:@"登录" forState:UIControlStateNormal];
                loginButton.enabled = YES;
            }];
            
        }else{
            [self.view showInfo:@"请输入6位密码！" autoHidden:YES interval:2];
            [_indicatorView stopAnimating];
            [loginButton setTitle:@"登录" forState:UIControlStateNormal];
            loginButton.enabled = YES;
        }
        
    }else {
        [self.view showInfo:@"请输入正确的手机号码" autoHidden:YES];
        [_indicatorView stopAnimating];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        loginButton.enabled = YES;
    }
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Main_Screen_Height*46/667;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.backgroundColor    = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.imageView.image                = [UIImage imageNamed:@"yonghushouji"];
        
        self.userMobileFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-150, Main_Screen_Height*40/667)];
        self.userMobileFieldText.placeholder    = @"请输入手机号码";
        self.userMobileFieldText.delegate       = self;
        self.userMobileFieldText.returnKeyType  = UIReturnKeyDone;
        self.userMobileFieldText.keyboardType   = UIKeyboardTypeNumberPad;
        self.userMobileFieldText.textAlignment  = NSTextAlignmentLeft;
        self.userMobileFieldText.font           = [UIFont systemFontOfSize:Main_Screen_Height*16/667];
        self.userMobileFieldText.backgroundColor= [UIColor whiteColor];
        self.userMobileFieldText.top            = Main_Screen_Height*3/667;
        self.userMobileFieldText.left           = Main_Screen_Width*50/375 ;
        
        [self.userMobileFieldText addTarget:self action:@selector(userPhoneFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.userMobileFieldText];
        
        UIView          *lineView       = [UIUtil drawLineInView:cell.contentView frame:CGRectMake(0, 0, Main_Screen_Width, 1) color:[UIColor colorFromHex:@"#e6e6e6"]];
        lineView.top                    = Main_Screen_Height*46/667;
        lineView.left                   = cell.imageView.left +Main_Screen_Width*20/375;
        
    }else if(indexPath.row ==1){
        cell.imageView.image                = [UIImage imageNamed:@"mimayanzheng"];
        
        self.verifyFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*260/375, Main_Screen_Height*40/667)];
        self.verifyFieldText.placeholder    = @"请输入验证码";
        self.verifyFieldText.delegate       = self;
        self.verifyFieldText.returnKeyType  = UIReturnKeyDone;
        self.verifyFieldText.keyboardType   = UIKeyboardTypeNumberPad;
        self.verifyFieldText.textAlignment  = NSTextAlignmentLeft;
        self.verifyFieldText.font           = [UIFont systemFontOfSize:Main_Screen_Height*16/667];
        //        self.verifyFieldText.backgroundColor= [UIColor grayColor];
        self.verifyFieldText.top            = Main_Screen_Height*3/667;
        self.verifyFieldText.left           = Main_Screen_Width*50/375 ;
        
        [self.verifyFieldText addTarget:self action:@selector(verifyFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.verifyFieldText];
        
                NSString *getVeriifyString      = @"获取验证码";
                UIFont *getVeriifyStringFont          = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
                self.getVeriifyStringButton      = [UIUtil drawButtonInView:cell.contentView frame:CGRectMake(0, 0, Main_Screen_Width*90/375, Main_Screen_Height*28/667) text:getVeriifyString font:getVeriifyStringFont color:[UIColor whiteColor] target:self action:@selector(getVeriifyByButtonClick:)];
                self.getVeriifyStringButton.backgroundColor=  [UIColor colorFromHex:@"#0161a1"];
                self.getVeriifyStringButton.layer.masksToBounds  = YES;
                self.getVeriifyStringButton.layer.cornerRadius = Main_Screen_Height*14/667;
                self.getVeriifyStringButton.right          = self.tableView.width;
                self.getVeriifyStringButton.centerY        = self.verifyFieldText.centerY;
        
        UIView          *lineView       = [UIUtil drawLineInView:cell.contentView frame:CGRectMake(0, 0, Main_Screen_Width, 1) color:[UIColor colorFromHex:@"#e6e6e6"]];
        lineView.top                    = Main_Screen_Height*46/667;
        lineView.left                   = cell.imageView.left +Main_Screen_Width*20/375;
        
    }else if (indexPath.row == 2) {
        cell.imageView.image                = [UIImage imageNamed:@"mimayanzheng"];
        
        self.passwordFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-150, Main_Screen_Height*40/667)];
        self.passwordFieldText.placeholder    = @"至少输入6位新密码";
        self.passwordFieldText.delegate       = self;
        self.passwordFieldText.returnKeyType  = UIReturnKeyDone;
        self.passwordFieldText.keyboardType   = UIKeyboardTypeNumberPad;
        self.passwordFieldText.textAlignment  = NSTextAlignmentLeft;
        self.passwordFieldText.font           = [UIFont systemFontOfSize:Main_Screen_Height*16/667];
        self.passwordFieldText.backgroundColor= [UIColor whiteColor];
        self.passwordFieldText.top            = Main_Screen_Height*3/667;
        self.passwordFieldText.left           = Main_Screen_Width*50/375 ;
        
//        [self.passwordFieldText addTarget:self action:@selector(userPhoneFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.passwordFieldText];
        
        UIView          *lineView       = [UIUtil drawLineInView:cell.contentView frame:CGRectMake(0, 0, Main_Screen_Width, 1) color:[UIColor colorFromHex:@"#e6e6e6"]];
        lineView.top                    = Main_Screen_Height*46/667;
        lineView.left                   = cell.imageView.left +Main_Screen_Width*20/375;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void) getVeriifyByButtonClick:(id)sender {
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}


- (void) userPhoneFieldTextChanged:(UITextField *)sender {
    
    
    
    
}
- (void) verifyFieldChanged: (UITextField *) sender
{
    
}
-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)checkLoginBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
