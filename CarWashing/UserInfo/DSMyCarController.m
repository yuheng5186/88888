//
//  DSMyCarController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSMyCarController.h"
#import "MyCarPortController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import <Masonry.h>
#import "MyCarInfosHeaderView.h"
#import "UIView+Uitls.h"
#import "QFDatePickerView.h"
#import "ProvinceShortController.h"
#import "IQKeyboardManager.h"
#import "IcreaseCarController.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MyCar.h"
#import "UdStorage.h"
#import "MBProgressHUD.h"

#import "UIScrollView+EmptyDataSet.h"//第三方空白页
#import "CYCarInsertViewController.h"
#import "MySettingViewController.h"
@interface DSMyCarController ()<UITableViewDelegate, UITableViewDataSource, NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, UITextFieldDelegate,UIGestureRecognizerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, weak) UIImageView *carImageView;

@property (nonatomic, weak) UITableView *carInfoView;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, weak) UIButton *provinceBtn;

@property (nonatomic, strong) NSMutableArray *CarArray;
@property (nonatomic, assign) NSInteger Xuhao;

@property (nonatomic, weak) UILabel *lbl;
@property (nonatomic, weak) UILabel *lbl2;
@property (nonatomic, weak) UITextField *carNum;
@property (nonatomic, weak) UITextField *carBrand;
@property (nonatomic, weak) UITextField *carBrandType;
@property (nonatomic, weak) UITextField *ChassisNum;
@property (nonatomic, weak) UITextField *Mileage;
@end

static NSString * HeaderId = @"header";

@implementation DSMyCarController{
    CGFloat _totalYOffset;
}

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}



//- (UIImageView *)carImageView {
//
//    if (_carImageView == nil) {
//        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 200)];
//        _carImageView = carImageView;
//        [self.view addSubview:_carImageView];
//    }
//    return _carImageView;
//}

- (UITableView *)carInfoView {
    
    if (_carInfoView == nil) {
        
        UITableView *carInfoView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height)];
        carInfoView.contentInset     = UIEdgeInsetsMake(0, 0, 80, 0);
        _carInfoView = carInfoView;
        [self.view addSubview:_carInfoView];
    }
    return _carInfoView;
}


- (void)drawNavigation {
    
    [self drawTitle:@"我的爱车"];
    [self drawRightTextButton:@"我的车库" action:@selector(clickMycarPort)];
    [self drawLeftImageButton:@"" action:@selector(jackBackAction)];
}

-(void)jackBackAction{
    if ([self.homeString isEqualToString:@"1"]) {
        
        self.tabBarController.selectedIndex = 4;
        self.homeString = @"0";

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //    [center addObserver:self selector:@selector(noticeupdateMyCar:) name:@"updatemycarsuccess" object:nil];
    //    [center addObserver:self selector:@selector(noticeupdateMyCar:) name:@"increasemycarsuccess" object:nil];
    
    //    [IQKeyboardManager sharedManager].enable = YES;
    //self.carImageView.image = [UIImage imageNamed:@"02"];
    
    
    
    
    
    
    
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    //    tap.delegate = self;
    //    [self.view addGestureRecognizer:tap];
}



-(void)getMyCarData
{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MyCar/GetCarList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"我的爱车数据--%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            _Xuhao = 0;
            _CarArray = [NSMutableArray array];
            self.imageArray  = [NSMutableArray array];
            
            
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            for(NSDictionary *dic in arr)
            {
                MyCar *newcar = [[MyCar alloc]init];
                [newcar setValuesForKeysWithDictionary:dic];
                [_CarArray addObject:newcar];
            }
            
            for (int index = 0; index < [_CarArray count]; index++) {
                UIImage *image = [UIImage imageNamed:@"aicheditu"];
                [self.imageArray addObject:image];
            }
            
            [self setupUI];
            
            [_carInfoView reloadData];
            
            [HUD setHidden:YES];
            
        }
        else
        {
            [HUD setHidden:YES];
            
            [self.view showInfo:@"信息获取失败,请检查网络" autoHidden:YES];
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
        
        
    } fail:^(NSError *error) {
        [HUD setHidden:YES];
        [self.view showInfo:@"信息获取失败,请检查网络" autoHidden:YES interval:2];
        
        
        ////        [self.view showInfo:@"信息获取失败,请检查网络" autoHidden:YES];
        //        [self.view showInfo:@"信息获取失败,请检查网络"];
        //
        
        //        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

- (void)setupUI {
    
    //无限轮播图
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, (Main_Screen_Width - 60*Main_Screen_Height/667) * 9*Main_Screen_Height/667 / 16*Main_Screen_Height/667+ 24*Main_Screen_Height/667)];
    
    if(self.imageArray.count == 0)
    {
        pageFlowView.backgroundColor = [UIColor clearColor];
    }
    
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.85;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    
    [self.view addSubview:pageFlowView];
    [pageFlowView reloadData];
    
    //    UIPageControl *pageControl = [[UIPageControl alloc] init];
    //    pageControl.numberOfPages = self.imageArray.count;
    //    pageControl.userInteractionEnabled = NO;
    //    [pageControl setValue:[UIImage imageNamed:@"xuanzhong"] forKey:@"currentPageImage"];
    //    [pageControl setValue:[UIImage imageNamed:@"wei_xuanzhong"] forKey:@"pageImage"];
    //    self.pageControl = pageControl;
    //    [pageFlowView addSubview:pageControl];
    //
    //    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(pageFlowView);
    //        make.bottom.equalTo(pageFlowView).mas_offset(-1);
    //    }];
    
    self.carInfoView.delegate = self;
    self.carInfoView.dataSource = self;
    
#pragma maek-空白页
    self.carInfoView.emptyDataSetSource = self;
    self.carInfoView.emptyDataSetDelegate = self;
    
    //可以去除tableView的多余的线，否则会影响美观
    self.carInfoView.tableFooterView = [UIView new];
    
    [self.carInfoView registerClass:[MyCarInfosHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderId];
    
    self.carInfoView.tableHeaderView = pageFlowView;
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Main_Screen_Width - 84*Main_Screen_Height/667, (Main_Screen_Width - 84*Main_Screen_Height/667) / 2);
}

//横着的车
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    //    NSLog(@"%ld",subIndex);
    _Xuhao = subIndex;
}


#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width - 84*Main_Screen_Height/667, (Main_Screen_Width - 84*Main_Screen_Height/667) / 2)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    UIImageView *containImageView = [[UIImageView alloc] initWithFrame:bannerView.bounds];
    containImageView.image = self.imageArray[index];
    [bannerView addSubview:containImageView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"aichemoren"];
    [containImageView addSubview:iconImageView];
    
    
    MyCar *car = [[MyCar alloc]init];
    car = [_CarArray objectAtIndex:index];
    if(car.IsDefaultFav == 0)
    {
        iconImageView.hidden = YES;
    }
    else
    {
        iconImageView.hidden = NO;
    }
    
    
    
    UIImageView *carImageView = [[UIImageView alloc] init];
    carImageView.image = [UIImage imageNamed:@"aiche_def"];
    [containImageView addSubview:carImageView];
    
    UILabel *carpinpai = [[UILabel alloc]init];
    carpinpai.text = car.CarBrand;
    carpinpai.textColor = [UIColor whiteColor];
    carpinpai.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    [containImageView addSubview:carpinpai];
    
    UILabel *carpro = [[UILabel alloc]init];
    if (car.Manufacture==0) {
        carpro.text = @"";
    }else{
        carpro.text = [NSString stringWithFormat:@"%ld年产",car.Manufacture];
    }
    carpro.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    carpro.textColor = [UIColor whiteColor];
    
    [containImageView addSubview:carpro];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(containImageView);
        make.width.height.mas_equalTo(30*Main_Screen_Height/667);
    }];
    
    [carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containImageView);
        make.left.equalTo(containImageView).mas_equalTo(24*Main_Screen_Height/667);
        make.width.height.mas_equalTo(67*Main_Screen_Height/667);
    }];
    
    [carpinpai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(carImageView.mas_centerY).mas_offset(-10*Main_Screen_Height/667);
        make.leading.equalTo(carImageView.mas_trailing).mas_offset(20*Main_Screen_Height/667);
        
    }];
    
    [carpro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carImageView.mas_centerY).mas_offset(10*Main_Screen_Height/667);
        make.leading.equalTo(carImageView.mas_trailing).mas_offset(20*Main_Screen_Height/667);
        
    }];
    
    bannerView.mainImageView = containImageView;
    
    
    bannerView.backgroundColor=[UIColor whiteColor];
    bannerView.mainImageView.backgroundColor=[UIColor clearColor];
    bannerView.mainImageView.clipsToBounds=YES;
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    //self.pageControl.currentPage = pageNumber;
    NSLog(@"%ld",pageNumber);
    _Xuhao = pageNumber;
    MyCar *car = [[MyCar alloc]init];
    
    //    if(_CarArray.count == 0)
    //    {
    //
    //    }
    //    else
    //    {
    car = [_CarArray objectAtIndex:_Xuhao];
    
    
//    NSString *platenumbertype=[car.PlateNumber substringToIndex:1];
//    [self.provinceBtn setTitle:platenumbertype forState:UIControlStateNormal];
    [self.provinceBtn setTitle:car.Province forState:(UIControlStateNormal)];
    self.carNum.text = car.PlateNumber;
    
    
    
//    self.carNum.text =  [car.PlateNumber substringFromIndex:1];
    self.carBrand.text = car.CarBrand;
    self.carBrandType.text = car.CarType;
    self.ChassisNum.text = car.ChassisNum;
    self.Mileage.text = [NSString stringWithFormat:@"%ld",car.Mileage];
    
    
    
    
    
    //        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    //        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //        [inputFormatter setDateFormat:@"yyyyMM"];
    //        NSDate* inputDate = [inputFormatter dateFromString:car.DepartureTime];
    //        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //        [outputFormatter setLocale:[NSLocale currentLocale]];
    //        [outputFormatter setDateFormat:@"yyyy-MM"];
    //        NSString *targetTime = [outputFormatter stringFromDate:inputDate];
    //        _lbl2.text  = targetTime;
    //
    //        if(targetTime == 0)
    //        {
    //            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    //            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //            [inputFormatter setDateFormat:@"yyyyM"];
    //            NSDate* inputDate = [inputFormatter dateFromString:car.DepartureTime];
    //            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //            [outputFormatter setLocale:[NSLocale currentLocale]];
    //            [outputFormatter setDateFormat:@"yyyy-M"];
    //            NSString *targetTime = [outputFormatter stringFromDate:inputDate];
    //            _lbl2.text  = targetTime;
    //        }
    
    _lbl2.text  = car.DepartureTime;
    
    
    _lbl.text = [NSString stringWithFormat:@"%ld",car.Manufacture];
    //    }
    
    
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(_CarArray.count == 0)
    {
        return 0;
    }
    
    else
    {
        return 2;
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_CarArray.count == 0)
    {
        return 0;
    }
    
    else
    {
        if (section == 0) {
            return 3;
        }
        
        return 4;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *id_carCell = @"id_carCell";
    UITableViewCell *carCell = [tableView dequeueReusableCellWithIdentifier:id_carCell];
    carCell.selectionStyle=UITableViewCellSelectionStyleNone;
    carCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:id_carCell];
    
    MyCar *car = [[MyCar alloc]init];
    
    if(_CarArray.count == 0)
    {
        
    }
    
    else
    {
        car = [_CarArray objectAtIndex:_Xuhao];
    }
    
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            carCell.textLabel.text = @"车牌号";
            carCell.textLabel.textColor = [UIColor colorFromHex:@"#868686"];
            carCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            
            //            UILabel *provinceLabel = [[UILabel alloc] init];
            //            provinceLabel.text = @"沪";
            //            provinceLabel.textColor = [UIColor colorFromHex:@"#868686"];
            //            provinceLabel.font = [UIFont systemFontOfSize:14];
            UIButton *provinceBtn = [[UIButton alloc] init];
            _provinceBtn = provinceBtn;
//            NSString *platenumbertype=[car.PlateNumber substringToIndex:1];
            [provinceBtn setTitle:car.Province forState:UIControlStateNormal];
            [provinceBtn setTitleColor:[UIColor colorFromHex:@"#868686"] forState:UIControlStateNormal];
            provinceBtn.titleLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            //            [provinceBtn addTarget:self action:@selector(didClickProvinceBtn) forControlEvents:UIControlEventTouchUpInside];
            [carCell.contentView addSubview:provinceBtn];
            
            //            UIImageView *provinceImgV = [[UIImageView alloc] init];
            //            provinceImgV.image = [UIImage imageNamed:@"xuanshengfen"];
            //            [provinceBtn addSubview:provinceImgV];
            
            UITextField *numTF = [[UITextField alloc] init];
            numTF.placeholder = @"请输入车牌号";
            
//            numTF.text = [car.PlateNumber substringFromIndex:1];
            numTF.text = car.PlateNumber;
            numTF.textColor = [UIColor colorFromHex:@"#b4b4b4"];
            numTF.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            numTF.delegate = self;
            numTF.tag = 100;
            self.carNum=numTF;
            [carCell.contentView addSubview:numTF];
            
            [provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(carCell.textLabel);
                make.left.equalTo(carCell.contentView).mas_offset(110*Main_Screen_Height/667);
            }];
            
            //            [provinceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.right.equalTo(provinceBtn);
            //                make.bottom.equalTo(provinceBtn);
            //                make.width.height.mas_equalTo(7*Main_Screen_Height/667);
            //            }];
            
            [numTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(provinceBtn);
                make.leading.equalTo(provinceBtn.mas_trailing).mas_offset(0*Main_Screen_Height/667);
                make.width.mas_equalTo(200*Main_Screen_Height/667);
            }];
        }else if(indexPath.row==1){
            carCell.textLabel.text = @"品牌";
            carCell.textLabel.textColor = [UIColor colorFromHex:@"#868686"];
            carCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            
            UITextField *brandTF = [[UITextField alloc] init];
            brandTF.placeholder = @"请填写";
            brandTF.text = car.CarBrand;
            brandTF.delegate = self;
            brandTF.textColor = [UIColor colorFromHex:@"#b4b4b4"];
            
            self.carBrand = brandTF;
            self.carBrand.tag = 101;
            brandTF.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            [carCell.contentView addSubview:brandTF];
            
            [brandTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(carCell.contentView).mas_offset(110*Main_Screen_Height/667);
                make.centerY.equalTo(carCell);
                make.right.equalTo(carCell.contentView).mas_offset(-12*Main_Screen_Height/667);
            }];
        }else if(indexPath.row==2){
            carCell.textLabel.text = @"车系";
            carCell.textLabel.textColor = [UIColor colorFromHex:@"#868686"];
            carCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            
            UITextField *brandTF = [[UITextField alloc] init];
            brandTF.placeholder = @"请填写";
            brandTF.text = car.CarType;
            brandTF.delegate = self;
            brandTF.textColor = [UIColor colorFromHex:@"#b4b4b4"];
            
            self.carBrandType = brandTF;
            self.carBrand.tag = 102;
            brandTF.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            [carCell.contentView addSubview:brandTF];
            
            [brandTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(carCell.contentView).mas_offset(110*Main_Screen_Height/667);
                make.centerY.equalTo(carCell);
                make.right.equalTo(carCell.contentView).mas_offset(-12*Main_Screen_Height/667);
            }];
        }
    }
    
    if (indexPath.section == 1)
    {
        
        NSArray *arr = @[@"车架号码",@"生产年份",@"上路时间",@"行驶里程"];
        carCell.textLabel.text = arr[indexPath.row];
        carCell.textLabel.textColor = [UIColor colorFromHex:@"#868686"];
        carCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
        
        if (indexPath.row == 0)
        {
            UITextField *textTF = [[UITextField alloc] init];
            textTF.delegate = self;
            textTF.tag = 102;
            textTF.text = car.ChassisNum;
            textTF.placeholder = @"请填写";
            textTF.textColor = [UIColor colorFromHex:@"#b4b4b4"];
            textTF.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            self.ChassisNum = textTF;
            [carCell.contentView addSubview:textTF];
            
            [textTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(carCell.contentView).mas_offset(110*Main_Screen_Height/667);
                make.centerY.equalTo(carCell);
                make.right.equalTo(carCell.contentView).mas_offset(-12*Main_Screen_Height/667);
            }];
        }
        
        
        else if (indexPath.row == 3)
        {
            UITextField *textTF = [[UITextField alloc] init];
            textTF.delegate = self;
            textTF.tag = 103;
            textTF.text = [NSString stringWithFormat:@"%ld",car.Mileage];
            textTF.placeholder = @"请填写";
            textTF.keyboardType    = UIKeyboardTypeNumberPad;
            textTF.textColor = [UIColor colorFromHex:@"#b4b4b4"];
            
            self.Mileage = textTF;
            textTF.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            [carCell.contentView addSubview:textTF];
            
            [textTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(carCell.contentView).mas_offset(110*Main_Screen_Height/667);
                make.centerY.equalTo(carCell);
                make.right.equalTo(carCell.contentView).mas_offset(-12*Main_Screen_Height/667);
            }];
        }
        
        
        else
        {
            
            //carCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 1)
            {
                UILabel *lbl = [[UILabel alloc] init];
                _lbl = lbl;
                lbl.text = [NSString stringWithFormat:@"%ld",car.Manufacture];
                lbl.textColor = [UIColor colorFromHex:@"#868686"];
                lbl.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
                [carCell.contentView addSubview:lbl];
                
                [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(carCell.contentView).mas_offset(110*Main_Screen_Height/667);
                    make.centerY.equalTo(carCell);
                }];
            }
            else
            {
                UILabel *lbl2 = [[UILabel alloc] init];
                _lbl2 = lbl2;
                
                
                //                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                //                [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                //                [inputFormatter setDateFormat:@"yyyy-MM"];
                //                NSDate* inputDate = [inputFormatter dateFromString:car.DepartureTime];
                //                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                //                [outputFormatter setLocale:[NSLocale currentLocale]];
                //                [outputFormatter setDateFormat:@"yyyy-MM"];
                //                NSString *targetTime = [outputFormatter stringFromDate:inputDate];
                //                lbl2.text  = targetTime;
                
                //                if(targetTime == 0)
                //                {
                //                    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                //                    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                //                    [inputFormatter setDateFormat:@"yyyyM"];
                //                    NSDate* inputDate = [inputFormatter dateFromString:car.DepartureTime];
                //                    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                //                    [outputFormatter setLocale:[NSLocale currentLocale]];
                //                    [outputFormatter setDateFormat:@"yyyy-M"];
                //                    NSString *targetTime = [outputFormatter stringFromDate:inputDate];
                lbl2.text  = car.DepartureTime;
                //                }
                
                
                lbl2.textColor = [UIColor colorFromHex:@"#868686"];
                lbl2.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
                [carCell.contentView addSubview:lbl2];
                
                [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(carCell.contentView).mas_offset(110*Main_Screen_Height/667);
                    make.centerY.equalTo(carCell);
                }];
            }
            
        }
        
        
    }
    
    return carCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*Main_Screen_Height/667;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50*Main_Screen_Height/667;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *hederview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50*Main_Screen_Height/667)];
    hederview.backgroundColor=[UIColor colorWithHex:0xf0f0f0];
    UIView *hederviews=[[UIView alloc]initWithFrame:CGRectMake(0, 10*Main_Screen_Height/667, Main_Screen_Width, 39*Main_Screen_Height/667)];
    hederviews.backgroundColor=[UIColor whiteColor];
    
    UIImageView *infoimage = [[UIImageView alloc] initWithFrame:CGRectMake((hederviews.bounds.size.height-15*Main_Screen_Height/667)/2, (hederviews.bounds.size.height-15*Main_Screen_Height/667)/2, 15*Main_Screen_Height/667, 15*Main_Screen_Height/667)];
    infoimage.contentMode=UIViewContentModeScaleAspectFill;
    
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoimage.frame.origin.x+infoimage.frame.size.width, 0, Main_Screen_Width, 39*Main_Screen_Height/667)];
    
    infoLabel.textColor = [UIColor colorFromHex:@"#868686"];
    infoLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    
    if (section == 0) {
        infoimage.image=[UIImage imageNamed:@"xinxi"];
        infoLabel.text = @"  基本信息";
        
    }else{
        infoimage.image=[UIImage imageNamed:@"qitaxinxi"];
        infoLabel.text = @"  其他信息";
    }
    [hederviews addSubview:infoimage];
    [hederviews addSubview:infoLabel];
    [hederview addSubview:hederviews];
    
    return hederview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    MyCar *car = [[MyCar alloc]init];
    car = [_CarArray objectAtIndex:_Xuhao];
    
    
    IcreaseCarController *increaseVC = [[IcreaseCarController alloc] init];
    increaseVC.hidesBottomBarWhenPushed = YES;
    increaseVC.titlename = @"修改车辆信息";
    increaseVC.mycar = car;
    [self.navigationController pushViewController:increaseVC animated:YES];
    //    if (indexPath.section == 1)
    //    {
    //
    //        if (indexPath.row == 1) {
    //            QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
    //
    //                self.lbl.text = str;
    //
    //            }];
    //            [datePickerView show];
    //        }
    //
    //        if (indexPath.row == 2) {
    //            QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
    //
    //                self.lbl2.text = str;
    //
    //            }];
    //            [datePickerView show];
    //        }
    //    }
    
}


#pragma mark - 弹出省份简称
//- (void)didClickProvinceBtn {
//
//    ProvinceShortController *provinceVC = [[ProvinceShortController alloc] init];
//
//    typeof(self) weakSelf = self;
//
//    provinceVC.provinceBlock = ^(NSString *nameText) {
//
//        [weakSelf.provinceBtn setTitle:nameText forState:UIControlStateNormal];
//    };
//
//    provinceVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:provinceVC animated:NO completion:nil];
//}


#pragma mark - 键盘

//点击输入框触发
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //键盘高度
    //    CGFloat keyboardHeight = 216.0f;
    //获取tag
    //    textField.enabled = NO;
    //    NSLog(@"hhhhh === %ld",textField.tag);
    //判断键盘高度是否遮住输入框，具体超过多少距离，移动多少距离（自己算好就可以，不一定和这里一样）
    //    if ((self.carInfoView.bounds.size.height - 264) - keyboardHeight - 60 * (textField.tag + 1) < 0 &&(self.carInfoView.bounds.size.height - 264) - keyboardHeight - 60 * (textField.tag + 1) > -60) {
    //
    //        [self.carInfoView setContentOffset:CGPointMake(0, 216) animated:YES];
    //    }
    //    else if (self.carInfoView.bounds.size.height - 264 - keyboardHeight - 60 * (textField.tag + 1) < 180 &&self.carInfoView.bounds.size.height - 264 - keyboardHeight - 60 * (textField.tag + 1) > -120)
    //    {
    //        [self.carInfoView setContentOffset:CGPointMake(0, 80) animated:YES];
    //    }
    //    else if (self.carInfoView.bounds.size.height - keyboardHeight - 60 * (textField.tag + 1) < -120 &&self.carInfoView.bounds.size.height - keyboardHeight - 60 * (textField.tag + 1) > -180)
    //    {
    //        [self.carInfoView setContentOffset:CGPointMake(0, 170) animated:YES];
    //    }
    MyCar *car = [[MyCar alloc]init];
    car = [_CarArray objectAtIndex:_Xuhao];
    [textField resignFirstResponder];
    
    IcreaseCarController *increaseVC = [[IcreaseCarController alloc] init];
    increaseVC.hidesBottomBarWhenPushed = YES;
    increaseVC.titlename = @"修改车辆信息";
    increaseVC.mycar = car;
    [self.navigationController pushViewController:increaseVC animated:YES];
    
}

//键盘收回触发
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //回归原处
    [self.carInfoView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
//
//    MyCar *car = [[MyCar alloc]init];
//    car = [_CarArray objectAtIndex:_Xuhao];
//
//    NSDictionary *mulDic = @{
//                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
//                             @"CarCode":[NSString stringWithFormat:@"%ld",car.CarCode],
//                             @"ModifyType":@1,
//                             @"CarBrand":self.carBrand.text,
//                             @"PlateNumber":[NSString stringWithFormat:@"%@%@",_provinceBtn.titleLabel.text,self.carNum.text],
//                             @"ChassisNum":self.ChassisNum.text,
//                             @"Manufacture":[self.lbl.text substringToIndex:4],
//                             @"DepartureTime":self.lbl2.text,
//                             @"Mileage":self.Mileage.text
//                            };
//    NSDictionary *params = @{
//                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
//                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
//                             };
//    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MyCar/ModifyCarInfo",Khttp] success:^(NSDictionary *dict, BOOL success) {
//
//        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
//        {
//            [self.view showInfo:@"修改成功" autoHidden:YES interval:2];
//
//
//        }
//        else
//        {
//            [self.view showInfo:@"修改失败" autoHidden:YES interval:2];
//        }
//
//    } fail:^(NSError *error) {
//        [self.view showInfo:@"修改失败" autoHidden:YES interval:2];
//    }];




//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
//}
//
//- (void)keyboardWillShow:(NSNotification *)noti
//{
//    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;;
//    [self.view.layer removeAllAnimations];
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
//
//    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:firstResponderView.frame fromView:firstResponderView.superview];
//
//    CGFloat bottom = rect.origin.y + rect.size.height;
//    CGFloat keyboardY = self.view.window.size.height - keyboardHeight;
//    if (bottom > keyboardY) {
//        _totalYOffset += bottom - (self.view.window.size.height - keyboardHeight);
//        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
//                              delay:0
//                            options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
//                         animations:^{
//                             self.view.y -= _totalYOffset;
//                         }
//                         completion:nil];
//    }
//
//
//}
//
//- (void)keyboardWillHide:(NSNotification *)noti
//{
//    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
//                          delay:0
//                        options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
//                     animations:^{
//                         self.view.y += _totalYOffset;
//                     }
//                     completion:nil];
//    _totalYOffset = 0;
//}
//
//- (void)keyboardWillChangeFrame:(NSNotification *)noti
//{
//
//}
//
//- (void)keyboardDidShow:(NSNotification *)noti
//{
//}
//
//- (void)keyboardDidHide:(NSNotification *)noti
//{
//}
//
//- (void)keyboardDidChangeFrame:(NSNotification *)noti
//{
//}

#pragma mark - 无数据占位
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"cheku_kongbai"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"cheku_kongbai"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0,   1.0)];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}
//设置文字（上图下面的文字，我这个图片默认没有这个文字的）是富文本样式，扩展性很强！

//这个是设置标题文字的
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    NSString *text = @"您暂未添加爱车哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor colorFromHex: @"#4a4a4a"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//设置按钮的文本和按钮的背景图片

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state  {
////    NSLog(@"buttonTitleForEmptyDataSet:点击上传照片");
////    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
////    return [[NSAttributedString alloc] initWithString:@"点击上传照片" attributes:attributes];
//}
// 返回可以点击的按钮 上面带文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor blueColor],};
    return [[NSAttributedString alloc] initWithString:@"新增车辆" attributes:attributes];
}

//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
//}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [UIImage imageNamed:@"xinzeng"];
}
//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}
//是否允许点击，默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
//图片是否要动画效果，默认NO
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
    return YES;
}
//空白页点击事件
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    NSLog(@"空白页点击事件");
}
//空白页按钮点击事件
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    CYCarInsertViewController * increaseVC = [[CYCarInsertViewController alloc]init];
    increaseVC.hidesBottomBarWhenPushed = YES;
    increaseVC.open=1;
    [self.navigationController pushViewController:increaseVC animated:YES];
    //    IcreaseCarController *increaseVC = [[IcreaseCarController alloc] init];
    //    increaseVC.hidesBottomBarWhenPushed = YES;
    //    increaseVC.titlename = @"新增车辆";
    //    [self.navigationController pushViewController:increaseVC animated:YES];
}
/**
 *  调整垂直位置
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -64;
}


- (void)endEditing
{
    [self.carInfoView endEditing:YES];
}

//-(void)noticeupdateMyCar:(NSNotification *)sender{
//
//    [self getMyCarData];
//}

-(void)viewWillAppear:(BOOL)animated
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    [self getMyCarData];
}

#pragma mark -点击我的车库
- (void)clickMycarPort {
    
    MyCarPortController *carPortVC = [[MyCarPortController alloc] init];
    
    carPortVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carPortVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
