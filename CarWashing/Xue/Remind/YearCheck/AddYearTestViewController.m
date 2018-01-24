//
//  AddYearTestViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "AddYearTestViewController.h"
#import "AddCareTableViewCell.h"

//时间选择
#import "WSDatePickerView.h"

//选择车
#import "CYCarInsertViewController.h"

#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"
#import "YearTestViewController.h"
//菊花
#import "MBProgressHUD.h"

@interface AddYearTestViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic)UITableView *careTableView;
@property(strong)NSArray *mainTitleArray;
@property(strong,nonatomic)UITextField *licenseNumTextField;

@property(strong,nonatomic)UIView *popView;
@property(strong,nonatomic)UIView *backView;
@property(strong,nonatomic)NSArray *proArray;
@property(strong,nonatomic)UIButton *button;




@end

@implementation AddYearTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.licenseNumTextField];
    
    
    //老杨的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editCarInformation:) name:@"editCarIndorMation" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _mainTitleArray = @[@"车牌号",@"品牌车系",@"选择车辆年限",@"上次年检时间"];

    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.fakeNavigation];
    [self.view addSubview:self.careTableView];
    
    self.licenseNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 76, 200, 35)];
    _licenseNumTextField.placeholder = self.placeholderString;
    _licenseNumTextField.borderStyle = UITextBorderStyleNone;
    _licenseNumTextField.delegate = self;
    _licenseNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _licenseNumTextField.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.licenseNumTextField];
    [self setUI];
    
    self.proArray = @[@"京",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新"];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(70, 66, 50, 50)];
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    self.button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.button setTitle:self.sendButtonTitleString forState:(UIControlStateNormal)];
    [self.button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview: self.button];
}

///////////////////////////////////////////
//点击省市
-(void)buttonAction{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载fakeNavigation
-(UIImageView *)fakeNavigation{
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
        _fakeNavigation.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
//        _fakeNavigation.image = [UIImage imageNamed:@"ijanbiantiao"];
        _fakeNavigation.userInteractionEnabled = YES;
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"添加年检提醒";
        fakeTitle.font = [UIFont systemFontOfSize:18 weight:18];
        fakeTitle.textColor = [UIColor whiteColor];
        fakeTitle.textAlignment = NSTextAlignmentCenter;
        [_fakeNavigation addSubview:fakeTitle];
        
        //取消按钮
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 26, 66, 30)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [backButton addTarget:self action:@selector(cancleAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_fakeNavigation addSubview:backButton];
        
        
    }
    return _fakeNavigation;
}

-(void)setUI{
    
//    UIImageView *buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 250+66, Main_Screen_Width-24, 50)];
//    buttonImageView.image = [UIImage imageNamed:@"ijanbiantiao"];
//    [self.view addSubview:buttonImageView];
    
    //保存按钮
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 250+66, Main_Screen_Width-24, 50)];
    saveButton.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
    [saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:18];
    saveButton.clipsToBounds = YES;
    saveButton.layer.cornerRadius = 5;
    [saveButton addTarget:self action:@selector(addButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:saveButton];
    
    
}

#pragma mark - 懒加载careTableView
-(UITableView *)careTableView{
    if (!_careTableView) {
        _careTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, Main_Screen_Width, 200) style:(UITableViewStylePlain)];
        _careTableView.delegate = self;
        _careTableView.dataSource = self;
        _careTableView.scrollEnabled = NO;
        [_careTableView registerClass:[AddCareTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _careTableView;
}

//设置行数，看row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

//高度50
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddCareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 1) {   //品牌车系
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.subTitleLabel.text = self.carMuSting;
    }else if(indexPath.row == 0){       //牌照
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.subTitleLabel.text = @"";
    }else if (indexPath.row == 2){      //自选段时间
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.subTitleLabel.text = self.yearsMuSting;
    }else if (indexPath.row == 3){      //上次时间
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.subTitleLabel.text = self.dateMuSting;
    }
    cell.mainTitleLabel.text = self.mainTitleArray[indexPath.row];
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        //选择车的品牌
        [self.licenseNumTextField resignFirstResponder];
        CYCarInsertViewController * increaseVC = [[CYCarInsertViewController alloc]init];
        increaseVC.hidesBottomBarWhenPushed = YES;
        increaseVC.CyTYpe = @"编辑车辆信息";
        [self.navigationController pushViewController:increaseVC animated:YES];
        
    }else if (indexPath.row == 2){
        //选择车龄
        [self.licenseNumTextField resignFirstResponder];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"选择车辆年限" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *quarter = [UIAlertAction actionWithTitle:@"不足六年" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //三个月一次操作
            self.yearsMuSting = @"不足六年";
            self.sendSerString = @"1";
            [tableView reloadData];
        }];
        UIAlertAction *half = [UIAlertAction actionWithTitle:@"六年至十五年" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //六个月一次操作
            self.yearsMuSting = @"六年至十五年";
            self.sendSerString = @"2";

            [tableView reloadData];
        }];
        UIAlertAction *oneYear = [UIAlertAction actionWithTitle:@"大于十五年" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //每年一次
            self.yearsMuSting = @"大于十五年";
            self.sendSerString = @"3";

            [tableView reloadData];
        }];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        //添加三个
        [alert addAction:quarter];
        [alert addAction:half];
        [alert addAction:oneYear];
        [alert addAction:cancle];
        
        //present出来
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else if (indexPath.row == 3){
        //年检时间选择
        [self.licenseNumTextField resignFirstResponder];
        WSDatePickerView *datePicker = [[WSDatePickerView alloc]initWithDateStyle:(DateStyleShowYearMonthDay) CompleteBlock:^(NSDate *selectDate) {
            //获得结果位date
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            self.dateMuSting = date;
            [tableView reloadData];
        }];
        datePicker.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:0];
        datePicker.doneButtonColor = [UIColor orangeColor];
        [datePicker show];
    }   //@end “if”
}


#pragma mark - 上传
//保存按钮动作,在这里开始上传数据
-(void)addButtonAction{
//    //本地userDefault
//    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"Year"];
//    // 保存到本地
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    

    
    if ([self.licenseNumTextField.text isEqualToString:@""]) {
        self.licenseNumTextField.text = self.placeholderString;
    }
    
    
    if ([self.dateMuSting isEqualToString:@"请选择"] || [self.licenseNumTextField.text isEqualToString:@"请输入车牌号"] || [self.carMuSting isEqualToString:@"请选择"] || [self.sendSerString isEqualToString:@"请选择"]) {
        UIAlertController *nullController = [UIAlertController alertControllerWithTitle:nil message:@"请补全信息" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleCancel) handler:nil];
        [nullController addAction:cancleAction];
        [self presentViewController:nullController animated:YES completion:nil];
    }else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = @"正在上传";
        
        //上传
        NSDictionary *mulDic = @{
                                 @"Id":[NSString stringWithFormat:@"%@",self.getID],
                                 @"Account_Id":[UdStorage getObjectforKey:Userid],
                                 @"ReminderType":@(3),
                                 @"Province":[NSString stringWithFormat:@"%@",self.sendButtonTitleString],
                                 @"TimeDate":[NSString stringWithFormat:@"%@",self.dateMuSting],
                                 @"PlateNumber":[NSString stringWithFormat:@"%@",self.licenseNumTextField.text],
                                 @"CarBrand":[NSString stringWithFormat:@"%@",self.carMuSting],
                                 @"VehicleYears":[NSString stringWithFormat:@"%@",self.sendSerString]
                                 };
        
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        NSLog(@"年检参数%@",mulDic);
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@%@",Khttp,self.webTypeString] success:^(NSDictionary *dict, BOOL success) {
            NSLog(@"年检上传结果%@",dict);
            if ([dict[@"ResultCode"] isEqualToString:@"F000000"]) {
                NSLog(@"年检上传成功！");
                if ([self.whereString isEqualToString:@"1"]) {
                    YearTestViewController *new = [[YearTestViewController alloc]init];
                    [self.navigationController pushViewController:new animated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"成功!";
                [hud hide:YES afterDelay:0.5];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"提交失败";
                [hud hide:YES afterDelay:0.5];
            }
        } fail:^(NSError *error) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"失败!";
            [hud hide:YES afterDelay:0.5];
        }];
    }
    
    
    

    
}

//取消按钮动作
-(void)cancleAction{
    if ([self.whereString isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.whereString isEqualToString:@"2"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//通知的另一部分
-(void)editCarInformation:(NSNotification *)notification{
    self.carMuSting = [NSString stringWithFormat:@"%@-%@",notification.userInfo[@"CYCarname"],notification.userInfo[@"CYCarType"]] ;
    [self.careTableView reloadData];
}

//退出编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

//点击别处推出编辑
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
            if (toBeString.length > 7)
            {
                textField.text = [toBeString substringToIndex:7];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > 7)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:7];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:7];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 7)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"UITextFieldTextDidChangeNotification"];
}

@end
