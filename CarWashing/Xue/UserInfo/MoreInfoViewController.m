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

//添加省市按钮
@property(strong,nonatomic)UIView *popView;
@property(strong,nonatomic)UIView *backView;
@property(strong,nonatomic)NSArray *proArray;
@property(strong,nonatomic)UIButton *button;
@property(copy,nonatomic)NSString *sendButtonTitleString;       //传回button名字

//键盘出现移动
@property(strong,nonatomic)UIScrollView *baseJackView;

@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.baseJackView];
    
    
    self.sendButtonTitleString = @"沪";
    self.proArray = @[@"京",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新"];
    [self.baseJackView addSubview:self.mainView];
    [self.baseJackView addSubview:self.commitButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)                                                name:@"UITextFieldTextDidChangeNotification" object:self.plateNumField];
    
    

    
    
    
//    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 46)];
//    [self.button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
//    self.button.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.button setTitle:self.sendButtonTitleString forState:(UIControlStateNormal)];
//    [self.button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}

-(UIScrollView*)baseJackView{
    if (!_baseJackView) {
        _baseJackView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        _baseJackView.contentSize = CGSizeMake(Main_Screen_Width, 800);
    }
    return _baseJackView;
}

-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > 6)
            {
                textField.text = [toBeString substringToIndex:6];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > 6)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:6];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:6];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 6)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"UITextFieldTextDidChangeNotification"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 95.0/667*Main_Screen_Height, Main_Screen_Width, 400.0/667*Main_Screen_Height)];
        
        //顶部提示
        UILabel *toplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30.0/667*Main_Screen_Height)];
        toplabel.text = @"完善个人信息即可获得洗车卡";
        toplabel.textAlignment = NSTextAlignmentCenter;
        toplabel.font = [UIFont systemFontOfSize:18 weight:18];
        toplabel.textColor = [UIColor whiteColor];
        [_mainView addSubview:toplabel];
        
        //姓名label
        UILabel *midLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60.0/667*Main_Screen_Height, Main_Screen_Width-60, 30.0/667*Main_Screen_Height)];
        midLabel.text = @"填写个人姓名";
        midLabel.font = [UIFont systemFontOfSize:18.0/667*Main_Screen_Height weight:18.0/667*Main_Screen_Height];
        midLabel.textColor = [UIColor whiteColor];
        [_mainView addSubview:midLabel];
        
        UIView *topBackView = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-150, 100.0/667*Main_Screen_Height, 300, 46.0/667*Main_Screen_Height)];
        topBackView.backgroundColor = [UIColor whiteColor];
        topBackView.clipsToBounds = YES;
        topBackView.layer.cornerRadius = 23.0/667*Main_Screen_Height;
        [_mainView addSubview:topBackView];
        
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-125, 101.0/667*Main_Screen_Height, 250, 44.0/667*Main_Screen_Height)];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.font = [UIFont systemFontOfSize:18.0/667*Main_Screen_Height];
        [_mainView addSubview:_nameField];
        
        
        UILabel *botLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 180.0/667*Main_Screen_Height, Main_Screen_Width-60, 30.0/667*Main_Screen_Height)];
        botLabel.text = @"填写车牌号";
        botLabel.font = [UIFont systemFontOfSize:18.0/667*Main_Screen_Height weight:18.0/667*Main_Screen_Height];
        botLabel.textColor = [UIColor whiteColor];
        [_mainView addSubview:botLabel];
        
        UIView *botBackView = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-150, 220.0/667*Main_Screen_Height, 300, 46.0/667*Main_Screen_Height)];
        botBackView.backgroundColor = [UIColor whiteColor];
        botBackView.clipsToBounds = YES;
        botBackView.layer.cornerRadius = 23.0/667*Main_Screen_Height;
        [_mainView addSubview:botBackView];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 46.0/667*Main_Screen_Height)];
        self.button.backgroundColor = [UIColor whiteColor];
        [self.button setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [self.button setTitle:self.sendButtonTitleString forState:(UIControlStateNormal)];
        [self.button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
        [botBackView addSubview:self.button];
        
        _plateNumField = [[UITextField alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 221.0/667*Main_Screen_Height, 230, 44.0/667*Main_Screen_Height)];
        _plateNumField.backgroundColor = [UIColor whiteColor];
//        _plateNumField.clipsToBounds = YES;
//        _plateNumField.layer.cornerRadius = 23;
        _plateNumField.font = [UIFont systemFontOfSize:18.0/667*Main_Screen_Height];
        _plateNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    
    if ([self.nameField.text isEqualToString:@""]||[self.plateNumField.text isEqualToString:@""]) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"请补全信息" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleCancel) handler:nil];
        [alertCon addAction:sureAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }else{
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:Userid],
                                 @"Name":self.nameField.text,
                                 @"PlateNumber":[NSString stringWithFormat:@"%@",self.plateNumField.text],
                                 @"Province":[NSString stringWithFormat:@"%@",self.sendButtonTitleString]
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
                APPDELEGATE.currentUser.userName = self.nameField.text;
                MenuTabBarController *menuTabBarController              = [[MenuTabBarController alloc] init];
                [AppDelegate sharedInstance].window.rootViewController  = menuTabBarController;
            }
        } fail:^(NSError *error) {
            //af失败
            NSLog(@"首次添加信息--AF失败%@",error);
        }];
    }
    

    
    
    
    
    
}

///////////////////////////////////////////
//点击省市
-(void)buttonAction{
    
    //注销两个键盘
    [self.nameField resignFirstResponder];
    [self.plateNumField resignFirstResponder];
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.popView];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0.7;
        self.backView.hidden = NO;
        self.popView.frame = CGRectMake(0, Main_Screen_Height-300, Main_Screen_Width, 300);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)backActionJack{
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.alpha = 0;
        self.popView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 300);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        [self.popView removeFromSuperview];
    }];
}

-(void)chooseProAction:(UIButton *)sender{
    self.sendButtonTitleString = self.proArray[sender.tag-100];
    [self.button setTitle:self.sendButtonTitleString forState:(UIControlStateNormal)];
    [self backActionJack];
}

-(UIView *)popView{
    if (!_popView) {
        _popView = [[UIView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 300)];
        _popView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < self.proArray.count; i++) {
            UIButton *provenButton = [[UIButton alloc]initWithFrame:CGRectMake(15+(i%5)*(71.0/375*Main_Screen_Width), 10+(i/5)*(35.0/667*Main_Screen_Height), (61.0/375*Main_Screen_Width), (30.0/667*Main_Screen_Height))];
            provenButton.layer.borderWidth = 0.5;
            [provenButton setTitle:self.proArray[i] forState:(UIControlStateNormal)];
            provenButton.tag = 100+i;
            [provenButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [provenButton addTarget:self action:@selector(chooseProAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [_popView addSubview:provenButton];
        }
    }
    return _popView;
}


-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        _backView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backActionJack)];
        _backView.userInteractionEnabled = YES;
        [_backView addGestureRecognizer:tap];
        _backView.alpha = 0;
        _backView.hidden = YES;
    }
    return _backView;
}
///////////////////////////////////////////





//点击别处结束编辑
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
