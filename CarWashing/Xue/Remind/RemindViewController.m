//
//  RemindViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindViewTableViewCell.h"
#import "CareRemindViewController.h"
#import "DriverLicenseViewController.h"
#import "YearTestViewController.h"
#import "InsurenceViewController.h"
#import "AddCareRemindViewController.h"
#import "AddDriverLicenseViewController.h"
#import "AddYearTestViewController.h"
#import "AddInSurenceViewController.h"
#import "RemindMoel.h"

#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"
//四个模块的入口

@interface RemindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UIImageView *fakeNavigation;
@property(strong,nonatomic)UITableView *jackTableView;
@property(strong,nonatomic)NSArray *titleArray;
@property(strong,nonatomic)NSArray *imageArray;

@property(strong,nonatomic)NSMutableArray *modelArray;
@property(copy,nonatomic)NSString *oneString;
@property(copy,nonatomic)NSString *twoString;
@property(copy,nonatomic)NSString *threeString;
@property(copy,nonatomic)NSString *fourString;

//判断是否已经设定，用来控制跳转页面
@property(copy,nonatomic)NSString *oneIsNot;
@property(copy,nonatomic)NSString *twoIsNot;
@property(copy,nonatomic)NSString *threeIsNot;
@property(copy,nonatomic)NSString *fourIsNot;



@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.view addSubview:self.fakeNavigation];
    [self.view addSubview:self.jackTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestFromWeb];
}

#pragma mark - 懒加载
-(UIImageView *)fakeNavigation{
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
        _fakeNavigation.image = [UIImage imageNamed:@"ijanbiantiao"];
        _fakeNavigation.userInteractionEnabled = YES;
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"爱车提醒";
        fakeTitle.font = [UIFont systemFontOfSize:18 weight:18];
        fakeTitle.textColor = [UIColor whiteColor];
        fakeTitle.textAlignment = NSTextAlignmentCenter;
        [_fakeNavigation addSubview:fakeTitle];
        
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 32, 19, 19)];
        backImageView.image = [UIImage imageNamed:@"icon_titlebar_arrow"];
        backImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_fakeNavigation addSubview:backImageView];
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 66)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_fakeNavigation addSubview:backButton];
        
        
    }
    return _fakeNavigation;
}

#pragma mark - tableView
-(UITableView *)jackTableView{
    if (!_jackTableView) {
        _jackTableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 66, Main_Screen_Width-24, Main_Screen_Height-91) style:(UITableViewStylePlain)];
        _jackTableView.delegate = self;
        _jackTableView.dataSource = self;
        _jackTableView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [_jackTableView registerClass:[RemindViewTableViewCell class] forCellReuseIdentifier:@"cell"];
        _jackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _jackTableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemindViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleArray = @[@"保养提醒",@"驾驶证更换提醒",@"车辆年检提醒",@"车险提醒"];
    _imageArray = @[@"baoyang",@"jiashizheng",@"nianjian",@"chexian"];
    cell.bigLabel.text = _titleArray[indexPath.row];
    cell.smallImageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    if (indexPath.row == 0) {
        cell.shortLabel.text = self.oneString;
    }else if(indexPath.row == 1){
        cell.shortLabel.text = self.twoString;
    }else if (indexPath.row == 2){
        cell.shortLabel.text = self.threeString;
    }else if(indexPath.row == 3){
        cell.shortLabel.text = self.fourString;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //保养提醒
        if ([self.oneIsNot isEqualToString: @"1"]) {
            //“1”已经设置
            CareRemindViewController *new = [[CareRemindViewController alloc]init];
            [self.navigationController pushViewController:new animated:YES];
        }else{
            AddCareRemindViewController *add = [[AddCareRemindViewController alloc]init];
            add.typeString = @"MyCar/AddVehicleReminder";
            add.dateMuSting = @"请选择";
            add.subMuSting = @"请选择";
            add.whereString = @"1";
            [self.navigationController pushViewController:add animated:YES];
        }
    }else if (indexPath.row == 1){
        if ([self.twoIsNot isEqualToString:@"1"]) {
            DriverLicenseViewController *new = [[DriverLicenseViewController alloc]init];
            [self.navigationController pushViewController:new animated:YES];
        }else{
            AddDriverLicenseViewController *add = [[AddDriverLicenseViewController alloc]init];
            add.webTypeString = @"MyCar/AddVehicleReminder";
            add.placeHolderString = @"请输入证件号";
            add.licenseTypeString = @"请选择";
            add.dateMuSting = @"请选择";
            add.whereString = @"1";
            [self.navigationController pushViewController:add animated:YES];

            
        }
        
    }else if (indexPath.row == 2){
        if ([self.threeIsNot isEqualToString:@"1"]) {
            YearTestViewController *new = [[YearTestViewController alloc]init];
            [self.navigationController pushViewController:new animated:YES];
        }else{
            AddYearTestViewController *add = [[AddYearTestViewController alloc]init];
            add.webTypeString = @"MyCar/AddVehicleReminder";
            add.placeholderString = @"请输入车牌号";
            add.sendButtonTitleString = @"沪";
            add.dateMuSting = @"请选择";
            add.yearsMuSting = @"请选择";
            add.carMuSting = @"请选择";
            add.whereString = @"1";
            [self.navigationController pushViewController:add animated:YES];
        }
        
    }else if (indexPath.row == 3){
        if ([self.fourIsNot isEqualToString:@"1"]) {
            InsurenceViewController *new = [[InsurenceViewController alloc]init];
            [self.navigationController pushViewController:new animated:YES];
        }else{
            AddInSurenceViewController *add = [[AddInSurenceViewController alloc]init];
            add.webTypeString = @"MyCar/AddVehicleReminder";
            add.companyNameMuString = @"请选择保险公司";
            add.dateMuSting = @"请选择";
            add.whereString = @"1";
            [self.navigationController pushViewController:add animated:YES];
            
        }
        
    }
}

#pragma mark - backAction
-(void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)requestFromWeb{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:Userid]
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MyCar/VehicleReminderList",Khttp] success:^(NSDictionary *dict, BOOL success) {
//        NSArray *newArr = dict[@"JsonData"];
//        NSLog(@"车票提醒%@",newArr[1]);
        if ([dict[@"ResultCode"] isEqualToString:@"F000000"]) {
            self.modelArray = (NSMutableArray *)[RemindMoel mj_objectArrayWithKeyValuesArray:dict[@"JsonData"]];
            
            ////////////////////////////////////////////////////////////////////////////
            RemindMoel * oneModel = self.modelArray[0];
            self.oneIsNot = oneModel.IsSetUp;
            NSString *getOneString = oneModel.TimeSpans;
            if([oneModel.IsSetUp isEqualToString:@"1"]){
                if([getOneString isEqualToString:@"0"] || [getOneString containsString:@"-"]){
                    self.oneString = @"请开始保养";
                }else if ([getOneString containsString:@"-"]){
                    self.twoString = @"请更换驾驶证";
                }else{
                    self.oneString = [NSString stringWithFormat:@"距下次保养还有%@天",getOneString];
                }
            }else{
                self.oneString = @"尚未设置提醒";
            }
            ////////////////////////////////////////////////////////////////////////////

            ////////////////////////////////////////////////////////////////////////////
            RemindMoel * twoModel = self.modelArray[1];
            self.twoIsNot = twoModel.IsSetUp;
            NSString *getTwoString = twoModel.TimeSpans;
            if([twoModel.IsSetUp isEqualToString:@"1"]){
                NSLog(@"=====================%@",getTwoString);
                if([getTwoString isEqualToString:@"0"]){
                    self.twoString = @"请更换驾驶证";
                }else if ([getTwoString containsString:@"-"]){
                    self.twoString = @"请更换驾驶证";
                }else{
                    self.twoString = [NSString stringWithFormat:@"距下次换证还有%@天",getTwoString];
                }
            }else{
                self.twoString = @"尚未设置提醒";
            }
            ////////////////////////////////////////////////////////////////////////////
            
            ////////////////////////////////////////////////////////////////////////////
            RemindMoel * threeModel = self.modelArray[2];
            self.threeIsNot = threeModel.IsSetUp;
            NSString *getThreeString = threeModel.TimeSpans;
            if([threeModel.IsSetUp isEqualToString:@"1"]){
                if([getThreeString isEqualToString:@"0"]){
                    self.threeString = @"请开始年检";
                }else if ([getThreeString containsString:@"-"]){
                    self.threeString = @"请开始年检";
                }else{
                    self.threeString = [NSString stringWithFormat:@"距下次年检还有%@天",getThreeString];
                }
            }else{
                self.threeString = @"尚未设置提醒";
            }
            ////////////////////////////////////////////////////////////////////////////
            
            ////////////////////////////////////////////////////////////////////////////
            RemindMoel * fourModel = self.modelArray[3];
            self.fourIsNot = fourModel.IsSetUp;
            NSString *getFourString = fourModel.TimeSpans;
            if([fourModel.IsSetUp isEqualToString:@"1"]){
                if([getFourString isEqualToString:@"0"] || [getOneString containsString:@"-"]){
                    self.fourString = @"请重新购买保险";
                }else if ([getFourString containsString:@"-"]){
                    self.threeString = @"请开始年检";
                }else{
                    self.fourString = [NSString stringWithFormat:@"距保险到期还有%@天",getFourString];
                }
            }else{
                self.fourString = @"尚未设置提醒";
            }
            ////////////////////////////////////////////////////////////////////////////
            
            [self.jackTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
