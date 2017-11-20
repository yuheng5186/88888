//
//  CareRemindViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/10.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CareRemindViewController.h"
#import "RemindViewController.h"
#import "AddCareRemindViewController.h"
#import "MBProgressHUD.h"
#import "OldDriverViewController.h"

#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"

#import "MBProgressHUD.h"

#import "CareModel.h"
#import "BusinessViewController.h"


@interface CareRemindViewController ()
@property(copy,nonatomic)NSString *mainPlateText;
@property(copy,nonatomic)NSString *provenceText;
@property(copy,nonatomic)NSString *munText;
@property(copy,nonatomic)NSString *dateText;
@property(copy,nonatomic)NSString *showOrNot;
@property(copy,nonatomic)NSMutableArray *modelDict;
@property(nonatomic)CareModel *modelJack;
@property(strong,nonatomic)UIButton *nearByButton;
@property(copy,nonatomic)NSString *sendToNewString;

//给下次进入传值
@property(nonatomic,copy)NSString *sendFrequency;
@property(nonatomic,copy)NSString *sendTimeData;
@end

@implementation CareRemindViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.mainPlateText = @"";
//    self.provenceText = @"";
//    self.munText = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fakeNavigation];
    [self.view addSubview:self.afterView];
    //需要判断是否已经添加保养提醒,目前直接写在这里,点击“添加”按钮时隐藏添加View
//    [self.view addSubview:self.addView];
    

    
}

//需要判断是否已经添加保养提醒
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestFromWeb];
    //创建userDefault
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *setAlready = [userDefaults objectForKey:@"CareRemide"];
//    if ([setAlready isEqualToString:@"1"]) {
//        self.addView.hidden = YES;
//        self.afterView.hidden = NO;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 懒加载fakeNavigation
-(UIView *)fakeNavigation{
    
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
        _fakeNavigation.backgroundColor = [UIColor colorWithRed:13/255.0 green:98/255.0 blue:159/255.0 alpha:1];
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"保养提醒";
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
        
        
        UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-31,30, 19, 19)];
        buttonImage.image = [UIImage imageNamed:@"bianji"];
        [_fakeNavigation addSubview:buttonImage];
        
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-66,0, 66, 66)];
        [editButton addTarget:self action:@selector(editingAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_fakeNavigation addSubview:editButton];
        
        
    }
    return _fakeNavigation;
}

//提示添加的View，添加按钮时隐藏
//-(UIView *)addView{
//    if (!_addView) {
//        _addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
//        _addView.backgroundColor = [UIColor whiteColor];
//
//        //提示信息
//
//        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width)];
//        addButton.backgroundColor = [UIColor colorWithRed:13/255.0 green:98/255.0 blue:159/255.0 alpha:1];
//        [addButton setTitle:@"尚未添加保养信息，点击添加" forState:(UIControlStateNormal)];
//        addButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:18];
//        [addButton addTarget:self action:@selector(callNewViewController) forControlEvents:(UIControlEventTouchUpInside)];
//        [_addView addSubview:addButton];
//    }
//    return _addView;
//}

//添加成功后的View
-(UIView *)afterView{
    if (!_afterView) {
        _afterView = [[UIView alloc]initWithFrame:CGRectMake(0, 66, Main_Screen_Width, Main_Screen_Height-66)];
        _afterView.backgroundColor = [UIColor whiteColor];
        
        UIView *blueBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 120)];
        blueBase.backgroundColor = [UIColor colorWithRed:13/255.0 green:98/255.0 blue:159/255.0 alpha:1];
        [_afterView addSubview:blueBase];
        
        //afterView中的属性
        _carNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Main_Screen_Width, 35)];
        _carNoLabel.textColor = [UIColor whiteColor];
        _carNoLabel.font = [UIFont systemFontOfSize:15];
        _carNoLabel.text = self.mainPlateText;
        _carNoLabel.textAlignment = NSTextAlignmentCenter;
        [_afterView addSubview:_carNoLabel];
        
        _carCareTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, Main_Screen_Width, 40)];
        _carCareTimeLabel.textColor = [UIColor whiteColor];
        _carCareTimeLabel.font = [UIFont systemFontOfSize:20];
        _carCareTimeLabel.text = self.dateText;
        _carCareTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_afterView addSubview:_carCareTimeLabel];
        
        UIImageView *imageViewHere = [[UIImageView alloc]initWithFrame:CGRectMake(0, 120, Main_Screen_Width, 432*Main_Screen_Height/667)];
        imageViewHere.image = [UIImage imageNamed:@"保养小知识"];
        imageViewHere.contentMode = UIViewContentModeScaleAspectFit;
        imageViewHere.userInteractionEnabled = YES;
        [_afterView addSubview:imageViewHere];
        
        //老司机button
        UIButton *oldDriverButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 100, 100)];
        [oldDriverButton addTarget:self action:@selector(oldBoyAction) forControlEvents:(UIControlEventTouchUpInside)];
        oldDriverButton.backgroundColor = [UIColor clearColor];
        [imageViewHere addSubview:oldDriverButton];
        
        //底部按钮
        _nearByButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-116, Main_Screen_Width, 50)];
        [_nearByButton setTitle:@"查看附近保养商户" forState:(UIControlStateNormal)];
        _nearByButton.backgroundColor = [UIColor colorWithRed:13/255.0 green:98/255.0 blue:159/255.0 alpha:1];
        _nearByButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_nearByButton addTarget:self action:@selector(nearByAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_afterView addSubview:_nearByButton];
        
    }
    return _afterView;
}

#pragma mark - 函数
//返回按钮动作
-(void)backAction{
    if([self.wayGetHere isEqualToString:@"1"]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RemindViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }//@end else
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[RemindViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
}

-(void)oldBoyAction{
    OldDriverViewController *new = [[OldDriverViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
}

-(void)editingAction{
    AddCareRemindViewController *new = [[AddCareRemindViewController alloc]init];
    new.typeString = @"MyCar/ModifyVehicleReminder";
    new.getID = self.sendToNewString;
    new.dateMuSting = self.sendTimeData;
    if ([self.sendFrequency isEqualToString:@"1"]) {
        //三个月
        new.subMuSting = @"三个月保养一次";
        new.sendSerHowLongStr = @"1";
    }else if ([self.sendFrequency isEqualToString:@"2"]){
        //六个月
        new.subMuSting = @"六个月保养一次";
        new.sendSerHowLongStr = @"2";
    }else if ([self.sendFrequency isEqualToString:@"3"]){
        //一年
        new.subMuSting = @"每年保养一次";
        new.sendSerHowLongStr = @"3";
    }
    [self presentViewController:new animated:YES completion:^{
//        [self.afterView removeFromSuperview];
    }];
}

////addView上present新控制器
//-(void)callNewViewController{
//    AddCareRemindViewController *new = [[AddCareRemindViewController alloc]init];
//    new.typeString = @"MyCar/AddVehicleReminder";
//    new.dateMuSting = @"请选择";
//    new.subMuSting = @"请选择";
//    [self presentViewController:new animated:YES completion:^{
//        self.addView.hidden = YES;
////        [self.afterView removeFromSuperview];
//
//    }];
//}

//附近的洗车点
-(void)nearByAction{
    self.tabBarController.selectedIndex = 1;
}

-(void)requestFromWeb{
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeDeterminate;
//    hud.labelText = @"正在加载";
    NSDictionary *mulDic = [NSDictionary new];
    if ([self.wayGetHere isEqualToString:@"1"]) {
        mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:Userid],
                                 @"ReminderType":[NSString stringWithFormat:@"%@",self.getRemindType],
                                 @"Id":[NSString stringWithFormat:@"%@",self.getID]
                                 };
    }else{
        mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:Userid]
                                 };
        
    }
    /*[UdStorage getObjectforKey:Userid]*/

    NSLog(@"%@",mulDic);
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MyCar/VehicleReminderList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
//        [hud hide:YES afterDelay:0.5];
        
        if ([dict[@"ResultCode"] isEqualToString:@"F000000"]) {

            NSArray *newArr = dict[@"JsonData"];
            NSLog(@"保养提醒%@",newArr[0]);
            
            //判断逻辑在这里
            self.modelDict = (NSMutableArray *)[CareModel mj_objectArrayWithKeyValuesArray:dict[@"JsonData"]];
            self.modelJack = self.modelDict[0];
            
            self.dateText = self.modelJack.ExpirationDate;
            self.sendToNewString = self.modelJack.Id;
            _carCareTimeLabel.text = self.dateText;
            self.mainPlateText = [NSString stringWithFormat:@"%@ %@ 下次保养时间",self.modelJack.Province,self.modelJack.PlateNumber];
            _carNoLabel.text = self.mainPlateText;
            self.showOrNot = self.modelJack.IsSetUp;
            
            //给再次打开传值
            self.sendFrequency = self.modelJack.MaintenanceFrequency;
            self.sendTimeData = self.modelJack.TimeDate;
            
//            if ([self.showOrNot isEqualToString:@"1"]) {
//                self.addView.hidden = YES;
//                self.afterView.hidden = NO;
//            }else{
//                self.addView.hidden = NO;
//                self.afterView.hidden = YES;
//            }
            

        }
    } fail:^(NSError *error) {
        NSLog(@"%@失败",error);
//        [hud hide:YES afterDelay:0.5];
    }];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



@end
