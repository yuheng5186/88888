//
//  MoreInfoViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/27.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "MenuTabBarController.h"

//上传参数
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"

#import "AppDelegate.h"

@interface MoreInfoViewController ()
@property(strong,nonatomic)UIButton *commitButton;
@property(strong,nonatomic)UIView *mainView;

@property(strong,nullable)UITextField *nameField;
@property(strong,nullable)UITextField *plateNumField;

@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.commitButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, Main_Screen_Width, 400)];
        
        //顶部提示
        UILabel *toplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
        toplabel.text = @"完善个人信息即可获得洗车卡";
        toplabel.textAlignment = NSTextAlignmentCenter;
        toplabel.font = [UIFont systemFontOfSize:18 weight:18];
        toplabel.textColor = [UIColor whiteColor];
        [_mainView addSubview:toplabel];
        
        //姓名label
        UILabel *midLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, Main_Screen_Width-60, 30)];
        midLabel.text = @"填写个人姓名";
        midLabel.font = [UIFont systemFontOfSize:18 weight:18];
        midLabel.textColor = [UIColor whiteColor];
        [_mainView addSubview:midLabel];
        
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-150, 100, 300, 46)];
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.clipsToBounds = YES;
        _nameField.layer.cornerRadius = 23;
        _nameField.font = [UIFont systemFontOfSize:18];
        [_mainView addSubview:_nameField];
        
        
        UILabel *botLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 180, Main_Screen_Width-60, 30)];
        botLabel.text = @"填写车牌号";
        botLabel.font = [UIFont systemFontOfSize:18 weight:18];
        botLabel.textColor = [UIColor whiteColor];
        [_mainView addSubview:botLabel];
        
        _plateNumField = [[UITextField alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-150, 220, 300, 46)];
        _plateNumField.backgroundColor = [UIColor whiteColor];
        _plateNumField.clipsToBounds = YES;
        _plateNumField.layer.cornerRadius = 23;
        _plateNumField.font = [UIFont systemFontOfSize:18];
        [_mainView addSubview:_plateNumField];
        
    }
    return _mainView;
}




//确认按钮
-(UIButton*)commitButton{
    if (!_commitButton) {
        _commitButton = [[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-150, Main_Screen_Height-100, 300, 46)];
        _commitButton.backgroundColor = [UIColor colorFromHex:@"ffcf36"];
        [_commitButton addTarget:self action:@selector(commitAction) forControlEvents:(UIControlEventTouchUpInside)];
        _commitButton.clipsToBounds = YES;
        _commitButton.layer.cornerRadius = 23;
        [_commitButton setTitle:@"确认" forState:(UIControlStateNormal)];
    }
    return _commitButton;
}

//确认的动作
-(void)commitAction{
    
    //注销两个键盘
    [self.nameField resignFirstResponder];
    [self.plateNumField resignFirstResponder];
    
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:Userid],
                             @"Name":self.nameField.text,
                             @"PlateNumber":self.plateNumField.text
                             };

    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/AddUserInfo",Khttp] success:^(NSDictionary *dict, BOOL success) {
        //af成功
        if ([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]]) {
            //后台成功
            NSLog(@"首次添加信息--后台成功");
            MenuTabBarController *menuTabBarController              = [[MenuTabBarController alloc] init];
            [AppDelegate sharedInstance].window.rootViewController  = menuTabBarController;
        }
    } fail:^(NSError *error) {
        //af失败
        NSLog(@"首次添加信息--AF失败%@",error);
    }];
    
    
    
    
    
}

//点击别处结束编辑
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
