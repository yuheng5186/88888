//
//  AddInSurenceViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "AddInSurenceViewController.h"
#import "AddCareTableViewCell.h"
#import "ChooseInsurenceViewController.h"
#import "InsurenceViewController.h"
//时间选择
#import "WSDatePickerView.h"

#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"

//菊花
#import "MBProgressHUD.h"

@interface AddInSurenceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *careTableView;
@property(strong,nonatomic)NSArray *mainTitleArray;



@end

@implementation AddInSurenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _mainTitleArray = @[@"保险公司",@"到期时间"];
    [self.view addSubview:self.fakeNavigation];
    [self.view addSubview:self.careTableView];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载fakeNavigation
-(UIImageView *)fakeNavigation{
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
//        _fakeNavigation.image = [UIImage imageNamed:@"ijanbiantiao"];
        _fakeNavigation.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
        _fakeNavigation.userInteractionEnabled = YES;
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"添加车险提醒";
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
    
    UIImageView *buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 150+66, Main_Screen_Width-24, 50)];
    buttonImageView.image = [UIImage imageNamed:@"ijanbiantiao"];
    [self.view addSubview:buttonImageView];
    
    //保存按钮
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 150+66, Main_Screen_Width-24, 50)];
    saveButton.backgroundColor = [UIColor clearColor];
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
        _careTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, Main_Screen_Width, 100) style:(UITableViewStylePlain)];
        _careTableView.delegate = self;
        _careTableView.dataSource = self;
        _careTableView.scrollEnabled = NO;
        [_careTableView registerClass:[AddCareTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _careTableView;
}

//设置行数，看row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

//高度50
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddCareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.mainTitleLabel.text = self.mainTitleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.subTitleLabel.text = self.companyNameMuString;
    }else if (indexPath.row == 1){
        cell.subTitleLabel.text = self.dateMuSting;
    }
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ChooseInsurenceViewController *new = [[ChooseInsurenceViewController alloc]init];
        new.deliverBlock = ^(NSString *sendInsurenceTypeString) {
            self.companyNameMuString = sendInsurenceTypeString;
            [tableView reloadData];
        };
        [self.navigationController pushViewController:new animated:YES];
    }else if (indexPath.row == 1){
        WSDatePickerView *datePicker = [[WSDatePickerView alloc]initWithDateStyle:(DateStyleShowYearMonthDay) CompleteBlock:^(NSDate *selectDate) {
            //获得结果位date
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            self.dateMuSting = date;
            [tableView reloadData];
        }];
        datePicker.minLimitDate = [NSDate dateWithTimeIntervalSinceNow:0];
        datePicker.doneButtonColor = [UIColor orangeColor];
        [datePicker show];
    }
}


#pragma mark - 上传
//保存按钮动作,在这里开始上传数据
-(void)addButtonAction{
    
//    //本地userDefault
//    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"Insure"];
//    // 保存到本地
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"正在上传";
    //上传
    NSDictionary *mulDic = @{
                             @"Id":[NSString stringWithFormat:@"%@",self.getID],
                             @"Account_Id":[UdStorage getObjectforKey:Userid],
                             @"ReminderType":@(4),
                             @"TimeDate":[NSString stringWithFormat:@"%@",self.dateMuSting],
                             @"InsuranceCompany":[NSString stringWithFormat:@"%@",self.companyNameMuString]
                             };
    NSLog(@"查看参数%@",mulDic);
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@%@",Khttp,self.webTypeString] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"车险上传结果%@",dict);
        if ([dict[@"ResultCode"] isEqualToString:@"F000000"]) {
            NSLog(@"车辆限上传成功！");
            if ([self.whereString isEqualToString:@"1"]) {
                InsurenceViewController *new = [[InsurenceViewController alloc]init];
                [self.navigationController pushViewController:new animated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"成功!";
            [hud hide:YES afterDelay:0.5];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } fail:^(NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"失败!";
        [hud hide:YES afterDelay:0.5];
    }];
    
    
}

//取消按钮动作
-(void)cancleAction{
    if ([self.whereString isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.whereString isEqualToString:@"2"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
