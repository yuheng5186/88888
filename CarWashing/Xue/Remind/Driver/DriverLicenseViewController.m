//
//  DriverLicenseViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/12.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DriverLicenseViewController.h"
#import "RemindViewController.h"
#import "AddDriverLicenseViewController.h"
#import "MBProgressHUD.h"

#import "LicenseModel.h"
#import "UdStorage.h"
#import "YearModel.h"
#import "AFNetworkingTool.h"
#import "LCMD5Tool.h"
#import "HTTPDefine.h"
@interface DriverLicenseViewController ()
@property(copy,nonatomic)NSString *timeString;                  //到期时间
@property(copy,nonatomic)NSString *sendIDString;
@property(copy,nonatomic)NSString *mainPlateText;       //车牌号

@property(copy,nonatomic)NSString *sendTypeString;              //ok
@property(copy,nonatomic)NSString *sendPlaceHolderString;       //ok


@end

@implementation DriverLicenseViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fakeNavigation];
    //需要判断是否已经添加保养提醒,目前直接写在这里,点击“添加”按钮时隐藏添加View
    [self.view addSubview:self.afterView];
//    [self.view addSubview:self.addView];
}

//需要判断是否已经添加保养提醒
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestFromWeb];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *setAlready = [userDefaults objectForKey:@"License"];
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
-(UIImageView *)fakeNavigation{
    
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 186)];
//        _fakeNavigation.image = [UIImage imageNamed:@"cheliangtixingtu"];
        _fakeNavigation.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
        _fakeNavigation.userInteractionEnabled = YES;
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
                fakeTitle.text = @"驾驶证更换提醒";
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
        
        //afterView中的属性
        _carNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, Main_Screen_Width, 35)];
        _carNoLabel.textColor = [UIColor whiteColor];
        _carNoLabel.font = [UIFont systemFontOfSize:15];
        _carNoLabel.text = @"驾驶证到期提醒";
        _carNoLabel.textAlignment = NSTextAlignmentCenter;
        [_fakeNavigation addSubview:_carNoLabel];
        
        _carCareTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, Main_Screen_Width, 40)];
        _carCareTimeLabel.textColor = [UIColor whiteColor];
        _carCareTimeLabel.font = [UIFont systemFontOfSize:20];
        _carCareTimeLabel.text = self.timeString;
        _carCareTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_fakeNavigation addSubview:_carCareTimeLabel];
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
//        [addButton setTitle:@"尚未添加驾驶证信息，点击添加" forState:(UIControlStateNormal)];
//        addButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:18];
//        [addButton addTarget:self action:@selector(callNewViewController) forControlEvents:(UIControlEventTouchUpInside)];
//        [_addView addSubview:addButton];
//    }
//    return _addView;
//}

//添加成功后的View
-(UIView *)afterView{
    if (!_afterView) {
        _afterView = [[UIView alloc]initWithFrame:CGRectMake(0, 186, Main_Screen_Width, Main_Screen_Height-66)];
        _afterView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageViewHere = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 432*Main_Screen_Height/667)];
        imageViewHere.image = [UIImage imageNamed:@"具体步骤"];
        imageViewHere.contentMode = UIViewContentModeScaleAspectFit;
        [_afterView addSubview:imageViewHere];
        
        
    }
    return _afterView;
}
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
    
}

-(void)editingAction{
    AddDriverLicenseViewController *new = [[AddDriverLicenseViewController alloc]init];
    new.webTypeString = @"MyCar/ModifyVehicleReminder";
    new.getID = self.sendIDString;
    new.placeHolderString = self.sendPlaceHolderString;
    new.licenseTypeString = self.sendTypeString;
    new.dateMuSting = self.timeString;
    //whereString = 2 -> present进来
    new.whereString = @"2";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:new];
    
    [self presentViewController:nav animated:YES completion:nil];
}

//addView上present新控制器
//-(void)callNewViewController{
//    AddDriverLicenseViewController *new = [[AddDriverLicenseViewController alloc]init];
//    new.webTypeString = @"MyCar/AddVehicleReminder";
//    new.placeHolderString = @"请输入证件号";
//    new.licenseTypeString = @"请选择";
//    new.dateMuSting = @"请选择";
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:new];
//    [self presentViewController:nav animated:YES completion:^{
//        self.addView.hidden = YES;
//    }];
//}


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
    NSLog(@"%@",mulDic);
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MyCar/VehicleReminderList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        if ([dict[@"ResultCode"] isEqualToString:@"F000000"]) {
            
//            NSArray *newArr = dict[@"JsonData"];
//            NSLog(@"车票提醒%@",newArr[1]);
            
//            [hud hide:YES afterDelay:0.5];
            
            NSMutableArray *modelArray = (NSMutableArray *)[LicenseModel mj_objectArrayWithKeyValuesArray:dict[@"JsonData"]];
            LicenseModel *modelJack = modelArray[1];
            self.timeString = modelJack.ExpirationDate;
            _carCareTimeLabel.text = self.timeString;
            self.sendIDString = modelJack.Id;
            self.sendPlaceHolderString = modelJack.IDNumber;
            self.sendTypeString = modelJack.QuasiDriveType;
//            if ([modelJack.IsSetUp isEqualToString:@"1"]) {
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
