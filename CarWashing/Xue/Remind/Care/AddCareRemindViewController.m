//
//  AddCareRemindViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/10.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "AddCareRemindViewController.h"
#import "AddCareTableViewCell.h"

//时间选择器
#import "WSDatePickerView.h"

#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"
#import "CareRemindViewController.h"

//菊花
#import "MBProgressHUD.h"

@interface AddCareRemindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *careTableView;
@property(strong,nonatomic)NSArray *mainTitleArray;
@property(strong,nonatomic)NSMutableArray *subTitleArray;





@end

@implementation AddCareRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _mainTitleArray = @[@"保养频率",@"上次保养时间"];
//    self.subMuSting = @"请选择";
//    self.dateMuSting = @"请选择";
//    self.sendSerHowLongStr = [NSString string];
    [self.view addSubview:self.fakeNavigation];
    [self.view addSubview:self.careTableView];
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

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
//        _fakeNavigation.backgroundColor = [UIColor colorWithRed:13/255.0 green:98/255.0 blue:159/255.0 alpha:1];
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"添加保养提醒";
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
    
//    UIImageView *buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 150+66, Main_Screen_Width-24, 50)];
//    buttonImageView.image = [UIImage imageNamed:@"ijanbiantiao"];
//    [self.view addSubview:buttonImageView];
    
    //保存按钮
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 150+66, Main_Screen_Width-24, 50)];
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
        _careTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, Main_Screen_Width, 150) style:(UITableViewStylePlain)];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.1)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddCareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.mainTitleLabel.text = self.mainTitleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.subTitleLabel.text = self.subMuSting;
    }else if (indexPath.row == 1){
        cell.subTitleLabel.text = self.dateMuSting;
    }
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        //选择保养时间间隔
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"选择保养间隔" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *quarter = [UIAlertAction actionWithTitle:@"三个月一次" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //三个月一次操作
            self.subMuSting = @"三个月保养一次";
            self.sendSerHowLongStr = @"1";
            [tableView reloadData];
        }];
        UIAlertAction *half = [UIAlertAction actionWithTitle:@"六个月一次" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //六个月一次操作
            self.subMuSting = @"六个月保养一次";
            self.sendSerHowLongStr = @"2";
            [tableView reloadData];
        }];
        UIAlertAction *oneYear = [UIAlertAction actionWithTitle:@"每年一次" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //每年一次
            self.subMuSting = @"每年保养一次";
            self.sendSerHowLongStr = @"3";
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

    }else if (indexPath.row == 1){
        //选择时间
        WSDatePickerView *datePicker = [[WSDatePickerView alloc]initWithDateStyle:(DateStyleShowYearMonthDay) CompleteBlock:^(NSDate *selectDate) {
            //获得结果位date
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            self.dateMuSting = date;
            [tableView reloadData];
        }];
        datePicker.doneButtonColor = [UIColor orangeColor];
        [datePicker show];
    }//@end "else if"
}


#pragma mark - 保存+上传
//保存按钮动作,在这里开始上传数据
-(void)addButtonAction{
//    //本地userDefault
//    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CareRemide"];
//    // 保存到本地
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.sendSerHowLongStr == NULL || self.dateMuSting == NULL) {
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
                                 @"ReminderType":@(1),
                                 @"MaintenanceFrequency":[NSString stringWithFormat:@"%@",self.sendSerHowLongStr],
                                 @"TimeDate":[NSString stringWithFormat:@"%@",self.dateMuSting]
                                 };
        
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        NSLog(@"参数是否在变%@",mulDic);
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@%@",Khttp,self.typeString] success:^(NSDictionary *dict, BOOL success) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"成功!";
            [hud hide:YES afterDelay:0.5];
            NSLog(@"上传结果%@",dict);
            if ([dict[@"ResultCode"] isEqualToString:@"F000000"]) {
                NSLog(@"上传成功！");
                //            [self dismissViewControllerAnimated:YES completion:nil];
                if ([self.whereString isEqualToString:@"1"]) {
                    CareRemindViewController *new = [[CareRemindViewController alloc]init];
                    [self.navigationController pushViewController:new animated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else{
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"提交失败";
                [hud hide:YES afterDelay:0.5];
            }
        } fail:^(NSError *error) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"失败!";
            [hud hide:YES afterDelay:0.5];
            NSLog(@"AF失败%@",error);
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

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
