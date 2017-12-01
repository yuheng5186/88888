//
//  HomeViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/19.
//  Copyright © 2017年 DS. All rights reserved.
//
#import "HomeViewController.h"
#import "SXScrPageView.h"
#import "DSAdDetailController.h"
#import "DSCardGroupController.h"
#import "PurchaseViewController.h"
#import "MenuTabBarController.h"
#import "DSExchangeController.h"

#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "JFCityViewController.h"

#import "DSMembershipController.h"
#import "DSMemberRightsController.h"
#import "DSServiceController.h"
#import "DSMyCarController.h"
#import "FindViewController.h"
#import "ScanController.h"
#import "DSScanQRCodeController.h"
#import "DSAddMerchantController.h"
#import "ScoreDetailController.h"


#import "DSConsumerDetailController.h"
#import "DSUserRightDetailController.h"
#import "DSCarWashingActivityController.h"

#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]
#define mainW [UIScreen mainScreen].bounds.size.width
#define mainH [UIScreen mainScreen].bounds.size.height


#import "PopupView.h"
#import "LewPopupViewAnimationDrop.h"
#import "DSDownloadController.h"
#import "DSShareGetMoneyController.h"
#import "DSAddShopController.h"
#import "DSSaleActivityController.h"

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "HTTPDefine.h"
#import "UdStorage.h"
#import "Record.h"
#import "AppDelegate.h"
#import "CoreLocation/CoreLocation.h"
#import "MBProgressHUD.h"
#import "DSStartWashingController.h"

#import "HSUpdateApp.h"

//车辆提醒
#import "CareRemindViewController.h"
#import "DriverLicenseViewController.h"
#import "YearTestViewController.h"
#import "InsurenceViewController.h"

//车友圈
#import "RemindViewController.h"

#import "CYCarInsertViewController.h"

#import "UselessViewController.h"

#import "DSMyCarController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIScrollViewDelegate,GCCycleScrollViewDelegate>
{
    UIImageView     *logoImageView;
    UILabel         *titleNameLabel;
    GCCycleScrollView *cycleScroll;
    UIView          *titleView;
    UIImageView *newManImageView;
    MBProgressHUD *HUD;

}

/** 选择的结果*/
@property (strong, nonatomic) UILabel *resultLabel;
@property (nonatomic, strong) UIButton  *locationButton;
/** 城市定位管理器*/
//@property (nonatomic, strong) JFLocation *locationManager;
///** 城市数据管理器*/
//@property (nonatomic, strong) JFAreaDataManager *manager;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger IsSign;

@property (nonatomic, strong) NSMutableArray *GetUserRecordData;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic)NSString *LocCity;
@property (strong, nonatomic)Record *newrc;

@property(copy,nonatomic)NSString *getCarCode;
@property(strong,nonatomic)UILabel*addCarInfoLabel;
@property(strong,nonatomic)UILabel*subAddCarLabel;
@property(copy,nonatomic)NSString *PlateNumber;
@end

@implementation HomeViewController

-(void)drawNavigation
{
    [self drawTitle:@"金顶洗车"];
    
    [self drawRightImageButton:@"xiazai" action:@selector(downloadButtonClick:)];
    [self drawLeftImageButton:@"jinding" action:nil];
}

- (void) drawContent {
    
    self.statusView.hidden      = NO;
    
    self.navigationView.hidden  = NO;
    self.contentView.top        = 0;
    self.contentView.height     = self.view.height;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //一句代码实现检测更新,很简单哦 （需要在viewDidAppear完成时，再调用改方法。不然在网速飞快的时候，会出现一个bug，就是当前控制器viewDidLoad调用的话，可能当前视图还没加载完毕就需要推出UIAlertAction）
    
}

-(void)hsUpdateApp{
    __weak __typeof(&*self)weakSelf = self;
    [HSUpdateApp hs_updateWithAPPID:@"1291609168" block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
        NSLog(@"--%@",storeVersion);
        //版本内容
        NSLog(@"---%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"releaseNotes"]);
        if (isUpdate == YES) {
            [weakSelf showStoreVersion:storeVersion openUrl:openUrl];
        }
    }];
}




-(void)showStoreVersion:(NSString *)storeVersion openUrl:(NSString *)openUrl{
    UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",storeVersion] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:openUrl];
        [[UIApplication sharedApplication] openURL:url];
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alercConteoller addAction:actionYes];
    [alercConteoller addAction:actionNo];
    [self presentViewController:alercConteoller animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.LocCity=nil;
//    [self startLocation];

   
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticeupdateUserheadimg:) name:@"updateheadimgsuccess" object:nil];
    
    
    // Do any additional setup after loading the view.
//    self.title = @"首页";
    self.navigationController.navigationBar.hidden = YES;
    
    [UdStorage storageObject:@"青岛市" forKey:@"City"];
    [UdStorage storageObject:@"市南区" forKey:@"Quyu"];
    [UdStorage storageObject:@"31.192272" forKey:@"Ym"];
    [UdStorage storageObject:@"121.523387"  forKey:@"Xm"];

    _IsSign = 0;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    
    [self createSubView];
    
//    self.locationManager = [[JFLocation alloc] init];
//    _locationManager.delegate = self;
    [self hsUpdateApp];
    [self headerRereshing];
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editCarInformation:) name:@"editCarIndorMation" object:nil];
    
}
-(void)editCarInformation:(NSNotification *)notification{
    self.addCarInfoLabel.text = [NSString stringWithFormat:@"%@-%@",notification.userInfo[@"CYCarname"],notification.userInfo[@"CYCarType"]] ;
}

- (void)dealloc{
    //移除观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"editCarIndorMation" object:nil];
}


- (void) createSubView {
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(goBack) name:@"paysuccess" object:nil];
//    [self createNavTitleView];
    
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Main_Screen_Width,Main_Screen_Height-44) style:UITableViewStyleGrouped];
//    self.tableView.top              = 0;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor  = [UIColor colorFromHex:@"#f6f6f6"];
    //    self.tableView.scrollEnabled    = NO;
//    self.tableView.tableFooterView  = [UIView new];
//    self.tableView.tableHeaderView  = [UIView new];
    
//    self.tableView.bounces  = NO;
    /*
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
     
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset     = UIEdgeInsetsMake(0, 0, 70, 0);
     */
    [self.contentView addSubview:self.tableView];
    
//     [self setupRefresh];
//    [self createHeaderView];
    
//    [self createNavTitleView];
    

}
-(void)goBack{
    [self setupRefresh];
}
-(void)setupRefresh
{
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [self headerRereshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        [self startLocation];
        
        
       
        [self setData];
        
    });
}


- (void) createNavTitleView {
    
    titleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, 64) color:[UIColor clearColor]];
    titleView.top                      = 0;
    
    NSString *titleName              = @"金顶洗车";
    UIFont *titleNameFont            = [UIFont boldSystemFontOfSize:18];
    titleNameLabel          = [UIUtil drawLabelInView:titleView frame:[UIUtil textRect:titleName font:titleNameFont] font:titleNameFont text:titleName isCenter:NO];
    titleNameLabel.textColor         = [UIColor whiteColor];
//    titleNameLabel.text              = @"金顶洗车";
    titleNameLabel.centerX           = titleView.centerX;
    titleNameLabel.centerY           = titleView.centerY +8;
    
    
    UIImage *logeImage              = [UIImage imageNamed:@"sy_icon"];
    logoImageView      = [UIUtil drawCustomImgViewInView:titleView frame:CGRectMake(0, 0, logeImage.size.width,logeImage.size.height) imageName:@"sy_icon"];

    
//    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHTTPImg,[UdStorage getObjectforKey:UserHead]]] placeholderImage:[UIImage imageNamed:@"sy_icon"]];
//    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.cornerRadius = logeImage.size.width/2;
    
    
    logoImageView.left              = Main_Screen_Width*12/375;
    logoImageView.centerY           = titleNameLabel.centerY;
    
    
//    UIImage *downloadImage           = [UIImage imageNamed:@"xiazai"];
//    UIButton  *downloadButton        = [UIUtil drawButtonInView:titleView frame:CGRectMake(0, 0, downloadImage.size.width, downloadImage.size.height) iconName:@"xiazai" target:self action:@selector(downloadButtonClick:)];
//    downloadButton.right             = Main_Screen_Width -Main_Screen_Width*12/375;
//    downloadButton.centerY           = logoImageView.centerY;
    
    
}



- (void) createHeaderView {
    
    UIView *headerView = [UIView new];
    headerView.width = [UIScreen mainScreen].bounds.size.width;
    headerView.height   = Main_Screen_Height*240/667;
    headerView.backgroundColor  = [UIColor colorFromHex:@"#f6f6f6"];
    self.tableView.tableHeaderView  = headerView;

//    UIView *backgroudView           = [UIView new];
//    backgroudView.width             = [UIScreen mainScreen].bounds.size.width;
//    backgroudView.height            = Main_Screen_Height*150/667;
//    backgroudView.backgroundColor   = [UIColor colorFromHex:@"#f6f6f6"];
//    backgroudView.top               = 0;
//    backgroudView.left              = 0;
//    [headerView addSubview:backgroudView];
   
    
    
//    NSMutableArray * images = [NSMutableArray array];
//
//    if (self.newrc.adverList.count!=0) {
//        for (NSInteger i = 0; i<self.newrc.adverList.count; i++)
//        {
//            [images addObject:[NSString stringWithFormat:@"%@%@",kHTTPImg,[((NSDictionary *)self.newrc.adverList[i]) objectForKey:@"ImgUrl"]]];
//        }
//        
//        
//        //网络图片加载
//        cycleScroll = [[GCCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*150/667)];
//        cycleScroll.delegate =self;
//       
//        cycleScroll.imageUrlGroups = images;
//        cycleScroll.autoScrollTimeInterval = 3.0;
//        cycleScroll.dotColor = [UIColor whiteColor];
//        
//          }
//
//    cycleScroll.top  =   0;
//    cycleScroll.width = Main_Screen_Width;
//    [backgroudView addSubview:cycleScroll];
    
    
    UIView *backView                   = [UIUtil drawLineInView:headerView frame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*20/375, Main_Screen_Height*110/667) color:[UIColor whiteColor]];
    backView.centerX                   = Main_Screen_Width/2;
    backView.layer.cornerRadius        = 10;
    backView.top                       = self.navigationView.bottom+10;
    backView.userInteractionEnabled    = YES;
    
    UIView *scanView                   = [UIUtil drawLineInView:backView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*90/667) color:[UIColor clearColor]];
    scanView.centerX                   = backView.width/8;
    scanView.top                       = 0;
    
    UITapGestureRecognizer  *tapScanGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScanButtonClick:)];
    [scanView addGestureRecognizer:tapScanGesture];
    UIImageView *scanImageView      = [UIUtil drawCustomImgViewInView:scanView frame:CGRectMake(0, 0, Main_Screen_Width*45/375,Main_Screen_Height*45/667) imageName:@"saoyisao"];
    scanImageView.centerX           = scanView.size.width/2;
    scanImageView.top               = Main_Screen_Height*10/667;
    
    NSString *scanName              = @"扫一扫";
    UIFont *scanNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *scanNameLabel          = [UIUtil drawLabelInView:scanView frame:[UIUtil textRect:scanName font:scanNameFont] font:scanNameFont text:scanName isCenter:NO];
    scanNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
//    scanNameLabel.backgroundColor         = [UIColor yellowColor];
    scanNameLabel.centerX           = scanImageView.centerX;
    scanNameLabel.top               = scanImageView.bottom +Main_Screen_Height*6/667;
    
    UIView *cardBagView                   = [UIUtil drawLineInView:backView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*90/667) color:[UIColor clearColor]];
    cardBagView.centerX                   = backView.width*3/8;
    cardBagView.centerY                   = scanView.centerY;
    
    UITapGestureRecognizer  *tapCardBagGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCardBagButtonClick:)];
    [cardBagView addGestureRecognizer:tapCardBagGesture];
    
    UIImageView *cardBagImageView      = [UIUtil drawCustomImgViewInView:cardBagView frame:CGRectMake(0, 0, Main_Screen_Width*45/375,Main_Screen_Height*45/667) imageName:@"kabao"];
    cardBagImageView.centerX           = cardBagView.size.width/2;
    cardBagImageView.top               = Main_Screen_Height*10/667;
    
    NSString *cardBagName              = @"卡包";
    UIFont *cardBagNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *cardBagNameLabel          = [UIUtil drawLabelInView:cardBagView frame:[UIUtil textRect:cardBagName font:cardBagNameFont] font:cardBagNameFont text:cardBagName isCenter:NO];
    cardBagNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    cardBagNameLabel.centerX           = cardBagImageView.centerX;
    cardBagNameLabel.top               = cardBagImageView.bottom +Main_Screen_Height*6/667;
    
    
    UIView *memberRightView                   = [UIUtil drawLineInView:backView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*90/667) color:[UIColor clearColor]];
    memberRightView.centerX                   = backView.width*5/8;
    memberRightView.centerY                   = cardBagView.centerY;
    
    UITapGestureRecognizer  *tapMemberRightGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMemberRightButtonClick:)];
    [memberRightView addGestureRecognizer:tapMemberRightGesture];
    
    UIImageView *memberRightImageView      = [UIUtil drawCustomImgViewInView:memberRightView frame:CGRectMake(0, 0, Main_Screen_Width*45/375,Main_Screen_Height*45/667) imageName:@"huiyuan1"];
    memberRightImageView.centerX           = memberRightView.size.width/2;
    memberRightImageView.top               = Main_Screen_Height*10/667;
    
    NSString *rightName              = @"会员特权";
    UIFont *rightNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *rightNameLabel          = [UIUtil drawLabelInView:memberRightView frame:[UIUtil textRect:rightName font:rightNameFont] font:rightNameFont text:rightName isCenter:NO];
    rightNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    rightNameLabel.centerX           = memberRightImageView.centerX;
    rightNameLabel.top               = memberRightImageView.bottom +Main_Screen_Height*6/667;
    
    
    UIView *scoreView                   = [UIUtil drawLineInView:backView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*90/667) color:[UIColor clearColor]];
    scoreView.centerX                   = backView.width*7/8;
    scoreView.centerY                   = cardBagView.centerY;
    
    UITapGestureRecognizer  *tapScoreGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScoreButtonClick:)];
    [scoreView addGestureRecognizer:tapScoreGesture];
    
    UIImageView *scoreImageView      = [UIUtil drawCustomImgViewInView:scoreView frame:CGRectMake(0, 0,Main_Screen_Width*45/375,Main_Screen_Height*45/667) imageName:@"jifen"];
    scoreImageView.centerX           = scoreView.size.width/2;
    scoreImageView.top               = Main_Screen_Height*10/667;
    
    NSString *scoreName              = @"积分";
    UIFont *scoreNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel *scoreNameLabel          = [UIUtil drawLabelInView:scoreView frame:[UIUtil textRect:scoreName font:scoreNameFont] font:scoreNameFont text:scoreName isCenter:NO];
    scoreNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    scoreNameLabel.centerX           = scoreImageView.centerX;
    scoreNameLabel.top               = scoreImageView.bottom +Main_Screen_Height*6/667;

    
    backView.height                  = scanView.bottom +Main_Screen_Height*0/667;
    //  背景高度
//    backgroudView.height             = scanView.bottom +Main_Screen_Height*0/667;
    
    
    UIView *downbackView                   = [UIUtil drawLineInView:headerView frame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*20/375, Main_Screen_Height*110/667) color:[UIColor whiteColor]];
    downbackView.centerX                   = Main_Screen_Width/2;
    downbackView.layer.cornerRadius        = 10;
    downbackView.top                       = backView.bottom+10;
    
    UIView *payView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    payView.centerX                   = downbackView.width/8;
    payView.top                       = Main_Screen_Height*10/375;
    
    UITapGestureRecognizer  *tapPayGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPayButtonClick:)];
    [payView addGestureRecognizer:tapPayGesture];
    UIImage *payImage              = [UIImage imageNamed:@"jihuokaquan"];
    UIImageView *payImageView      = [UIUtil drawCustomImgViewInView:payView frame:CGRectMake(0, 0, payImage.size.width,payImage.size.height) imageName:@"jihuokaquan"];
    payImageView.left              = Main_Screen_Width*15/375;
    payImageView.top               = Main_Screen_Height*10/667;
    
    
    NSString *payName              = @"激活卡券";
    UIFont *payNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *payNameLabel          = [UIUtil drawLabelInView:payView frame:[UIUtil textRect:payName font:payNameFont] font:payNameFont text:payName isCenter:NO];
    payNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    payNameLabel.centerX           = payImageView.centerX;
    payNameLabel.top               = payImageView.bottom +Main_Screen_Height*12/667;
    
    UIView *signView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    signView.centerX                   = downbackView.width*3/8;
    signView.top                       = Main_Screen_Height*10/375;
    
    UITapGestureRecognizer  *tapSignGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSignButtonClick:)];
    [signView addGestureRecognizer:tapSignGesture];
    
    UIImage *signImage              = [UIImage imageNamed:@"qiandao"];
    UIImageView *signImageView      = [UIUtil drawCustomImgViewInView:signView frame:CGRectMake(0, 0, signImage.size.width,signImage.size.height) imageName:@"qiandao"];
    signImageView.left              = Main_Screen_Width*15/375;
    signImageView.top               = Main_Screen_Height*10/667;
    
    NSString *signName              = @"每日签到";
    UIFont *signNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *signNameLabel          = [UIUtil drawLabelInView:signView frame:[UIUtil textRect:signName font:signNameFont] font:signNameFont text:signName isCenter:NO];
    signNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    signNameLabel.centerX           = signImageView.centerX;
    signNameLabel.top               = signImageView.bottom +Main_Screen_Height*12/667;
    
    
    UIView *discountView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    discountView.centerX                   = downbackView.width*5/8;
    discountView.top                       = Main_Screen_Height*10/375;
    
    UITapGestureRecognizer  *tapDiscountGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDiscountButtonClick:)];
    [discountView addGestureRecognizer:tapDiscountGesture];
    
    UIImage *discountImage              = [UIImage imageNamed:@"libao"];
    UIImageView *discountImageView      = [UIUtil drawCustomImgViewInView:discountView frame:CGRectMake(0, 0, discountImage.size.width,discountImage.size.height) imageName:@"libao"];
    discountImageView.left              = Main_Screen_Width*15/375;
    discountImageView.top               = Main_Screen_Height*10/667;
    
    NSString *discountName              = @"优惠活动";
    UIFont *discountNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *discountNameLabel          = [UIUtil drawLabelInView:discountView frame:[UIUtil textRect:discountName font:discountNameFont] font:discountNameFont text:discountName isCenter:NO];
    discountNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    discountNameLabel.centerX           = discountImageView.centerX;
    discountNameLabel.top               = discountImageView.bottom +Main_Screen_Height*12/667;
    
    
    
    UIView *shareView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    shareView.centerX                   = downbackView.width*7/8;
    shareView.top                       = Main_Screen_Height*10/375;
    
    UITapGestureRecognizer  *tapShareGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShareButtonClick:)];
    [shareView addGestureRecognizer:tapShareGesture];
    
    UIImage *shareImage              = [UIImage imageNamed:@"shouyefenxiang"];
    UIImageView *shareImageView      = [UIUtil drawCustomImgViewInView:shareView frame:CGRectMake(0, 0, shareImage.size.width,shareImage.size.height) imageName:@"shouyefenxiang"];
    shareImageView.left              = Main_Screen_Width*15/375;
    shareImageView.top               = Main_Screen_Height*10/667;
    
    NSString *shareName              = @"分享赚钱";
    UIFont *shareNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *shareNameLabel          = [UIUtil drawLabelInView:shareView frame:[UIUtil textRect:shareName font:shareNameFont] font:shareNameFont text:shareName isCenter:NO];
    shareNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    shareNameLabel.centerX           = shareImageView.centerX;
    shareNameLabel.top               = shareImageView.bottom +Main_Screen_Height*12/667;
    
    
    
    UIView *myCarView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    myCarView.centerX                   = downbackView.width/8;
    myCarView.top                       = payView.bottom +Main_Screen_Height*0/375;
    
    UITapGestureRecognizer  *tapMyCarGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMyCarButtonClick:)];
    [myCarView addGestureRecognizer:tapMyCarGesture];
    
    UIImage *myCarImage              = [UIImage imageNamed:@"qiche"];
    UIImageView *myCarImageView      = [UIUtil drawCustomImgViewInView:myCarView frame:CGRectMake(0, 0, myCarImage.size.width,myCarImage.size.height) imageName:@"qiche"];
    myCarImageView.left              = Main_Screen_Width*15/375;
    myCarImageView.top               = Main_Screen_Height*10/667;
    
    
    NSString *myCarName              = @"我的爱车";
    UIFont *myCarNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *myCarNameLabel          = [UIUtil drawLabelInView:myCarView frame:[UIUtil textRect:myCarName font:myCarNameFont] font:myCarNameFont text:myCarName isCenter:NO];
    myCarNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    myCarNameLabel.centerX           = myCarImageView.centerX;
    myCarNameLabel.top               = myCarImageView.bottom +Main_Screen_Height*12/667;
    
//    UIView *shareView                   = [UIUtil drawLineInView:headerView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
//    shareView.centerX                   = Main_Screen_Width*3/8;
//    shareView.top                       = payView.bottom +Main_Screen_Height*0/375;
//    
//    UITapGestureRecognizer  *tapShareGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShareButtonClick:)];
//    [shareView addGestureRecognizer:tapShareGesture];
//    
//    UIImage *shareImage              = [UIImage imageNamed:@"shouyefenxiang"];
//    UIImageView *shareImageView      = [UIUtil drawCustomImgViewInView:shareView frame:CGRectMake(0, 0, shareImage.size.width,shareImage.size.height) imageName:@"shouyefenxiang"];
//    shareImageView.left              = Main_Screen_Width*15/375;
//    shareImageView.top               = Main_Screen_Height*10/667;
//    
//    NSString *shareName              = @"分享赚钱";
//    UIFont *shareNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
//    UILabel *shareNameLabel          = [UIUtil drawLabelInView:shareView frame:[UIUtil textRect:shareName font:shareNameFont] font:shareNameFont text:shareName isCenter:NO];
//    shareNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
//    shareNameLabel.centerX           = shareImageView.centerX;
//    shareNameLabel.top               = shareImageView.bottom +Main_Screen_Height*12/667;
    

//    UIView *discountView                   = [UIUtil drawLineInView:headerView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
//    discountView.centerX                   = Main_Screen_Width*5/8;
//    discountView.top                       = payView.bottom +Main_Screen_Height*0/375;
//
//    UITapGestureRecognizer  *tapDiscountGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDiscountButtonClick:)];
//    [discountView addGestureRecognizer:tapDiscountGesture];
//
//    UIImage *discountImage              = [UIImage imageNamed:@"libao"];
//    UIImageView *discountImageView      = [UIUtil drawCustomImgViewInView:discountView frame:CGRectMake(0, 0, discountImage.size.width,discountImage.size.height) imageName:@"libao"];
//    discountImageView.left              = Main_Screen_Width*15/375;
//    discountImageView.top               = Main_Screen_Height*10/667;
//
//    NSString *discountName              = @"优惠活动";
//    UIFont *discountNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
//    UILabel *discountNameLabel          = [UIUtil drawLabelInView:discountView frame:[UIUtil textRect:discountName font:discountNameFont] font:discountNameFont text:discountName isCenter:NO];
//    discountNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
//    discountNameLabel.centerX           = discountImageView.centerX;
//    discountNameLabel.top               = discountImageView.bottom +Main_Screen_Height*12/667;
    
    UIView *shopView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    shopView.centerX                   = downbackView.width*5/8;
    shopView.top                       = payView.bottom +Main_Screen_Height*0/375;
    
    UITapGestureRecognizer  *tapShopGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShopButtonClick:)];
    [shopView addGestureRecognizer:tapShopGesture];
    
    UIImage *shopImage              = [UIImage imageNamed:@"shangjiaruzhu"];
    UIImageView *shopImageView      = [UIUtil drawCustomImgViewInView:shopView frame:CGRectMake(0, 0, shopImage.size.width,shopImage.size.height) imageName:@"shangjiaruzhu"];
    shopImageView.left              = Main_Screen_Width*15/375;
    shopImageView.top               = Main_Screen_Height*10/667;
    
    NSString *shopName              = @"商家入驻";
    UIFont *shopNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *shopNameLabel          = [UIUtil drawLabelInView:shopView frame:[UIUtil textRect:shopName font:shopNameFont] font:shopNameFont text:shopName isCenter:NO];
    shopNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    shopNameLabel.centerX           = shopImageView.centerX;
    shopNameLabel.top               = shopImageView.bottom +Main_Screen_Height*12/667;
    
    
    
    UIView *carClubView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    carClubView.centerX                   = downbackView.width*3/8;
    carClubView.top                       = payView.bottom +Main_Screen_Height*0/375;
    
    UITapGestureRecognizer  *tapCarClubGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCarClubButtonClick:)];
    [carClubView addGestureRecognizer:tapCarClubGesture];
    
    UIImage *carClubImage              = [UIImage imageNamed:@"cheyouquan"];
    UIImageView *carClubImageView      = [UIUtil drawCustomImgViewInView:carClubView frame:CGRectMake(0, 0, carClubImage.size.width,carClubImage.size.height) imageName:@"tixing"];
    carClubImageView.left              = Main_Screen_Width*15/375;
    carClubImageView.top               = Main_Screen_Height*10/667;
    
    NSString *carClubName              = @"车辆提醒";
    UIFont *carClubNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *CarClubNameLabel          = [UIUtil drawLabelInView:carClubView frame:[UIUtil textRect:carClubName font:carClubNameFont] font:carClubNameFont text:carClubName isCenter:NO];
    CarClubNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    CarClubNameLabel.centerX           = carClubImageView.centerX;
    CarClubNameLabel.top               = carClubImageView.bottom +Main_Screen_Height*12/667;
    
    
    
    UIView *serviceView                   = [UIUtil drawLineInView:downbackView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*80/667) color:[UIColor clearColor]];
    serviceView.centerX                   = downbackView.width*7/8;
    serviceView.top                       = payView.bottom +Main_Screen_Height*0/375;
    
    UITapGestureRecognizer  *tapServiceGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapServiceButtonClick:)];
    [serviceView addGestureRecognizer:tapServiceGesture];
    
    UIImage *serviceImage              = [UIImage imageNamed:@"kefu_wo"];
    UIImageView *serviceImageView      = [UIUtil drawCustomImgViewInView:serviceView frame:CGRectMake(0, 0, serviceImage.size.width,serviceImage.size.height) imageName:@"kefu_wo"];
    serviceImageView.left              = Main_Screen_Width*15/375;
    serviceImageView.top               = Main_Screen_Height*10/667;
    
    NSString *serviceName              = @"客服咨询";
    UIFont *serviceNameFont            = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    UILabel *serviceNameLabel          = [UIUtil drawLabelInView:serviceView frame:[UIUtil textRect:serviceName font:serviceNameFont] font:serviceNameFont text:serviceName isCenter:NO];
    serviceNameLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    serviceNameLabel.centerX           = serviceImageView.centerX;
    serviceNameLabel.top               = serviceImageView.bottom +Main_Screen_Height*12/667;
    
//    newManImageView      = [UIUtil drawCustomImgViewInView:self.tableView frame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height*75/667) imageName:@"banka_banner"];
//    newManImageView.centerX           = headerView.centerX;
//    newManImageView.top               = serviceView.bottom+Main_Screen_Height*20/667;
//    newManImageView.userInteractionEnabled=YES;
//    newManImageView.contentMode=UIViewContentModeScaleAspectFill;
//    newManImageView.image=[UIImage imageNamed:@"banka_banner"];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewOclick)];
//    [newManImageView addGestureRecognizer:tap];
//    downbackView.backgroundColor    = [UIColor redColor];
    downbackView.height   = serviceView.bottom;
    
    
//    if (self.newrc.recList.count==0) {
//        newManImageView      = [UIUtil drawCustomImgViewInView:self.tableView frame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height*75/667) imageName:@"banka_banner"];
//        newManImageView.centerX           = headerView.centerX;
//        newManImageView.top               = serviceView.bottom+Main_Screen_Height*20/667;
//        newManImageView.userInteractionEnabled=YES;
//        newManImageView.contentMode=UIViewContentModeScaleAspectFill;
//        newManImageView.image=[UIImage imageNamed:@"banka_banner"];
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewOclick)];
//        [newManImageView addGestureRecognizer:tap];
//        headerView.height   = serviceNameLabel.bottom;
//    }
//    else{
//        newManImageView.hidden=YES;
//        newManImageView.frame=CGRectMake(0, 0, 0, 0);
//    }
    
    
//    UIImage *newManImage                 = [UIImage imageNamed:@"GO"];
//    UIImageView *newManImageView      = [UIUtil drawCustomImgViewInView:headerView frame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height*75/667) imageName:@"GO"];
//    newManImageView.centerX           = headerView.centerX;
//    newManImageView.top               = carClubView.bottom;
//
////    UIImage *activityImage                 = [UIImage imageNamed:@"02"];
//    UIImageView *activityImageView      = [UIUtil drawCustomImgViewInView:headerView frame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height*100/667) imageName:@"WechatIMG4"];
//    activityImageView.centerX           = headerView.centerX;
//    activityImageView.top               = newManImageView.bottom+Main_Screen_Height*0/667;
    
    headerView.height   = downbackView.bottom;
    


}

- (void)cycleScrollView:(GCCycleScrollView*)cycleScrollView didSelectItemAtRow:(NSInteger)row{
    NSLog(@"dianji =%ld",(long)row);
    //        活动类型1将参数【2个参数】拼接到Url（活动详情的后面）
    //        ,类型2将参数【1个参数】拼接到Url（活动详情的后面）id
    //        类型 3将参数【一个参数】拼接到InviteUrl(分享链接的后面)id
//    1.2 获取一个随机数范围在：[10,100]，包括100，包括100
//    2、  获取一个随机数范围在：[500,1000），包括500，包括1000
    
//    int y = (arc4random() % 11) + 10;
//    int num = (arc4random() % 100);
//    NSLog(@"%d==%d",num,y);
    DSAdDetailController *viewVC = [[DSAdDetailController alloc]init];
//    viewVC.urlstr=[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"Url"];
    NSInteger typetag=[[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"AactivityType"] integerValue];
    NSString *OnetypeUrl=[NSString stringWithFormat:@"%@?ID=%@%d&AactivityCode=%@",[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"Url"],[UdStorage getObjectforKey:Userid],(arc4random() % 11) + 10,[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"AactivityCode"]];
    NSString *TwotypeUrl=[NSString stringWithFormat:@"%@?ID=%@%d",[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"Url"],[UdStorage getObjectforKey:Userid],(arc4random() % 11) + 10];
     NSString *ThereSharetypeUrl=[NSString stringWithFormat:@"%@?ID=%@%d",[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"InviteUrl"],[UdStorage getObjectforKey:Userid],(arc4random() % 11) + 10];
    
    switch (typetag) {
        case 0:
            viewVC.urlstr=[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"Url"];
            viewVC.shareurlstr=[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"InviteUrl"];
            break;
        case 1:
            viewVC.shareurlstr=[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"InviteUrl"];
            viewVC.urlstr=OnetypeUrl;
            break;
        case 2:
            viewVC.shareurlstr=[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"InviteUrl"];
            viewVC.urlstr=TwotypeUrl;
            break;
        case 3:
            viewVC.urlstr=[((NSDictionary *)self.newrc.adverList[row]) objectForKey:@"Url"];
            viewVC.shareurlstr=ThereSharetypeUrl;
            break;
        default:
            break;
    }
    viewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewVC animated:YES];
    
}
-(void)setData
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    if(self.LocCity == nil)
    {
        self.LocCity = @"青岛市";
    }
    
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
//                             @"Area":@"上海市"
                             @"Area":self.LocCity
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    /*
     [NSString stringWithFormat:@"%@User/GetUserRecord",Khttp]
     @"http:192.168.2.152:8090/api/User/GetUserRecord"
     */
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/GetUserRecord",Khttp] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"12345%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
             self.GetUserRecordData = [[NSMutableArray alloc]init];
            
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            if(arr.count == 0)
            {
                [self.view showInfo:@"暂无更多数据" autoHidden:YES interval:1.5];
                [self.tableView.mj_header endRefreshing];
            }
            else
            {

                NSLog(@"首页数据%@",[dict objectForKey:@"JsonData"]);
                self.newrc = [[Record alloc]initWithDictionary:[dict objectForKey:@"JsonData"] error:nil];
                [self creatJackHeaderView];
    //为header上的购卡判断
                NSDictionary *getDict = [dict objectForKey:@"JsonData"];
                NSDictionary *carModelDict = getDict[@"carModel"];
                self.getCarCode = [NSString stringWithFormat:@"%@",carModelDict[@"CarCode"]];
                self.PlateNumber = [NSString stringWithFormat:@"%@",carModelDict[@"PlateNumber"]];
                //车辆品牌
                NSString *carNameString = [NSString stringWithFormat:@"%@ %@",carModelDict[@"CarBrand"],carModelDict[@"CarType"]];
                if ([self.getCarCode isEqualToString:@"0"]) {
                    //第一次什么都不用管
                    self.addCarInfoLabel.text = @"添加爱车享免费洗车";
                    self.subAddCarLabel.text = @"洗车、保养、换轮胎";
                }else{
                    //已经添加信息，判断是否选择车型
                    if ([carNameString isEqualToString:@" "]) {
                        //没选择车型
                        self.addCarInfoLabel.text = @"点击进一步添加信息";
                    }else{
                        self.addCarInfoLabel.text = [NSString stringWithFormat:@"%@",carNameString];
                    }
                    //车牌照每次自动添加
                    self.subAddCarLabel.text = [NSString stringWithFormat:@"%@",self.PlateNumber];
                }
                
                
                
//                 [self createHeaderView];
                
                
                if (self.newrc.recList.count==0) {
                    newManImageView.hidden=NO;
                    newManImageView.frame=CGRectMake(0, 0, 0, 0);
                }else {
                    newManImageView.hidden=YES;
                    newManImageView.frame=CGRectMake(0, 0, 0, 0);
                }
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                
                [HUD setHidden:YES];

            }
            
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        }
        else
        {
            [HUD setHidden:YES];
            [self.view showInfo:@"数据请求失败,请检查定位" autoHidden:YES interval:2];
            [self.tableView.mj_header endRefreshing];

        }
        
    } fail:^(NSError *error) {
        [HUD setHidden:YES];
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [self.tableView.mj_header endRefreshing];
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.newrc.recList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return Main_Screen_Height*170/667;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section==self.newrc.recList.count-1) {
//         return 40.1f;
//    }else{
//        return 0.01;
//    }
    if (self.newrc.recList.count==0||self.newrc.recList.count<2) {
        if (section==0) {
            return Main_Screen_Height*180/667;
        }else{
            return 0.01;
            
        }
    }else{
       
            if (section==0) {
                return Main_Screen_Height*110/667;
            }else if (section==self.newrc.recList.count-1){
                return 80;
            }
            else{
                return 0.01;
                
            }
            
               
        
    }
   
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//     if (section==self.newrc.recList.count-1) {
//         
//    UILabel *footerview=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
//    footerview.textColor         = [UIColor colorFromHex:@"#999999"];
//    footerview.textAlignment=NSTextAlignmentCenter;
//    footerview.text=@"没有更多啦!";
//    return footerview;
//     }else{
//
//         return [UILabel new];
//     
//     }
    
   
    
    if (self.newrc.recList.count==0||self.newrc.recList.count<2) {
        if (section==0) {
            UIView * backView=[[UIView alloc]init];
            UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*30/667)];
            lineview.backgroundColor=[UIColor colorFromHex:@"#f6f6f6"];
            [backView addSubview:lineview];
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height*30/667, Main_Screen_Width, Main_Screen_Height*60/667)];
            imageview.userInteractionEnabled=YES;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.image=[UIImage imageNamed:@"banka_banner"];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewOclick)];
            [imageview addGestureRecognizer:tap];
            
            UILabel *footerview=[[UILabel alloc]initWithFrame:CGRectMake(0, Main_Screen_Height*100/667, Main_Screen_Width, Main_Screen_Height*50/667)];
            footerview.backgroundColor = [UIColor colorFromHex:@"#f6f6f6"];
            footerview.textColor         = [UIColor colorFromHex:@"#999999"];
            footerview.textAlignment=NSTextAlignmentCenter;
            footerview.text=@"没有更多啦";
            [backView addSubview:footerview];
            [backView addSubview:imageview];
            return backView;
        }else{
            return [UILabel new];
        }
    }else{
        if (section==0) {
            UIView * backView=[[UIView alloc]init];
            UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*30/667)];
            lineview.backgroundColor=[UIColor colorFromHex:@"#f6f6f6"];
            [backView addSubview:lineview];
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height*30/667, Main_Screen_Width, Main_Screen_Height*60/667)];
            imageview.userInteractionEnabled=YES;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.image=[UIImage imageNamed:@"banka_banner"];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewOclick)];
            [imageview addGestureRecognizer:tap];
            [backView addSubview:imageview];
            return backView;
        }else if (section==self.newrc.recList.count-1){
            UILabel *footerview=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
            footerview.backgroundColor = [UIColor colorFromHex:@"#f6f6f6"];
            footerview.textColor         = [UIColor colorFromHex:@"#999999"];
            footerview.textAlignment=NSTextAlignmentCenter;
            footerview.text=@"没有更多啦";
            return footerview;
        }else{
            return [UILabel new];
        }
        
    }
   
    

}
-(void)imageviewOclick{
    self.tabBarController.selectedIndex = 3;
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    cell.backgroundColor    = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.newrc.recList.count>0)
    {
        
   
    Recordinfo *record = [[Recordinfo alloc]initWithDictionary:(NSDictionary *)[self.newrc.recList objectAtIndex:indexPath.section] error:nil];
    NSLog(@"%@==%@",record,[self.newrc.recList objectAtIndex:indexPath.section]);
    NSString *imageString;
    NSString *titleString;
    NSString *vipString;
    NSString *contentShowString;
    NSString *remindShowString;
    NSString *getString;
    
    if(record.ShowType == 2){
        imageString               = @"xiaofeijilu";
        titleString               = @"消费记录";
        vipString                 = @"";
        
        
        if(record.ConsumptionType == 1)
        {
            contentShowString         = [NSString stringWithFormat:@"￥%@",record.MiddleDes];
            remindShowString          = record.BottomDes;
        }
        else if(record.ConsumptionType == 2)
        {
            contentShowString         = record.MiddleDes;
            remindShowString          = [NSString stringWithFormat:@"剩余%@次免费洗车",record.BottomDes];
        }
        else if(record.ConsumptionType == 3)
        {
            contentShowString         = record.MiddleDes;
            remindShowString          = [NSString stringWithFormat:@"支付金额: %@元",record.BottomDes];
        }
        else if(record.ConsumptionType == 4)
        {
            contentShowString         = [NSString stringWithFormat:@"您购买%@",record.MiddleDes];
            remindShowString          = [NSString stringWithFormat:@"支付金额: %@元",record.BottomDes];
        }
        
        
        
        
        
        getString                 = @"查看详情";
    }else if(record.ShowType == 3){
        imageString               = @"zensong";
        titleString               = @"活动赠送";
        vipString                 = @"";
        contentShowString         = [NSString stringWithFormat:@"%@",record.MiddleDes];
        remindShowString          = record.ConsumerDescrip;
        
//        if(record.ConsumptionType == 1)
//        {
//            contentShowString         = [NSString stringWithFormat:@"￥%@",record.MiddleDes];
//            remindShowString          = record.BottomDes;
//        }
//        else if(record.ConsumptionType == 2)
//        {
//            contentShowString         = record.MiddleDes;
//            remindShowString          = [NSString stringWithFormat:@"剩余%@次免费洗车",record.BottomDes];
//        }
//        else if(record.ConsumptionType == 3)
//        {
//            contentShowString         = record.MiddleDes;
//            remindShowString          = [NSString stringWithFormat:@"支付金额: %@元",record.BottomDes];
//        }
//        else if(record.ConsumptionType == 4)
//        {
//            contentShowString         = [NSString stringWithFormat:@"您购买%@",record.MiddleDes];
//            remindShowString          = [NSString stringWithFormat:@"支付金额: %@元",record.BottomDes];
//        }
        getString                 = @"查看详情";
    }else if(record.ShowType == 1){
        
        imageString         = @"quanyi";
        titleString         = @"优惠活动";
        vipString           = @"zhuanxiang";
        contentShowString   = record.MiddleDes;
        remindShowString    = record.BottomDes;
        getString           = @"立即领取";
//        vipString   = @"huiyuanzhuanxiang";
    }else if (record.ShowType == 4){
        imageString         = @"xiaoxitongzhi";
        titleString         = @"消息提醒";
        vipString           = @"zhuanxiang";
        contentShowString   = record.MiddleDes;
        remindShowString    = record.BottomDes;
        getString           = @"立即查看";
    }
    
    
    UIImageView  *recordimageView       = [UIUtil drawCustomImgViewInView:cell.contentView frame:CGRectMake(0, 0, Main_Screen_Width*30/375, Main_Screen_Height*30/667) imageName:imageString];
    recordimageView.left                = Main_Screen_Width*12/375;
    recordimageView.top                 = Main_Screen_Height*10/667;
    
    UIFont *titleStringFont            = [UIFont systemFontOfSize:14];
    UILabel *titleStringLabel          = [UIUtil drawLabelInView:cell.contentView frame:[UIUtil textRect:titleString font:titleStringFont] font:titleStringFont text:titleString isCenter:NO];
    titleStringLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    titleStringLabel.left              = recordimageView.right +Main_Screen_Width*13/375;
    titleStringLabel.top               = recordimageView.top;
    
    NSString *timeString              = record.CreateDate;
    UIFont *timeStringFont            = [UIFont systemFontOfSize:12];
    UILabel *timeStringLabel          = [UIUtil drawLabelInView:cell.contentView frame:[UIUtil textRect:timeString font:timeStringFont] font:timeStringFont text:timeString isCenter:NO];
    timeStringLabel.textColor         = [UIColor colorFromHex:@"#999999"];
    timeStringLabel.left              = recordimageView.right +Main_Screen_Width*13/375;
    timeStringLabel.top               = titleStringLabel.bottom +Main_Screen_Height*3/667;
    
    NSString *contentString              = record.RightDes;
    UIFont *contentStringFont            = [UIFont systemFontOfSize:12];
    UILabel *contentStringLabel          = [UIUtil drawLabelInView:cell.contentView frame:[UIUtil textRect:contentString font:contentStringFont] font:contentStringFont text:contentString isCenter:NO];
    contentStringLabel.textColor         = [UIColor colorFromHex:@"#868686"];
    contentStringLabel.right             = Main_Screen_Width -Main_Screen_Width*12/375;
    contentStringLabel.top               = Main_Screen_Height*9/667;
    
    UIImage *vipImage                = [UIImage imageNamed:vipString];
    UIImageView  *vipImageView       = [UIUtil drawCustomImgViewInView:cell.contentView frame:CGRectMake(0, 0, vipImage.size.width, vipImage.size.height) imageName:vipString];
    vipImageView.right               = Main_Screen_Width -Main_Screen_Width*14/375;
    vipImageView.top                 = Main_Screen_Height*12/667;
    vipImageView.hidden              = YES;
    
    UIFont *contentShowStringFont            = [UIFont systemFontOfSize:Main_Screen_Height*20/667];
    UILabel *contentShowStringLabel          = [UIUtil drawLabelInView:cell.contentView frame:[UIUtil textRect:contentShowString font:contentShowStringFont] font:contentShowStringFont text:contentShowString isCenter:NO];
    contentShowStringLabel.textColor         = [UIColor colorFromHex:@"#3a3a3a"];
    contentShowStringLabel.centerX           = Main_Screen_Width/2;
    contentShowStringLabel.top               = Main_Screen_Height*58/667;
    
    UIFont *remindShowStringFont            = [UIFont systemFontOfSize:12];
    UILabel *remindShowStringLabel          = [UIUtil drawLabelInView:cell.contentView frame:[UIUtil textRect:remindShowString font:remindShowStringFont] font:remindShowStringFont text:remindShowString isCenter:NO];
    remindShowStringLabel.textColor         = [UIColor colorFromHex:@"#999999"];
    remindShowStringLabel.centerX           = contentShowStringLabel.centerX;
    remindShowStringLabel.top               = contentShowStringLabel.bottom +Main_Screen_Height*15/667;
    
    UIView  *backgroundView         = [UIUtil drawLineInView:cell.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*40/667) color:[UIColor colorFromHex:@"#fafafa"]];
    backgroundView.left             = 0;
    backgroundView.top              = Main_Screen_Height*170/667 - backgroundView.height;
    
    UIFont *getStringFont            = [UIFont systemFontOfSize:14];
    UILabel *getStringLabel          = [UIUtil drawLabelInView:cell.contentView frame:[UIUtil textRect:getString font:getStringFont] font:getStringFont text:getString isCenter:NO];
    getStringLabel.textColor         = [UIColor colorFromHex:@"#868686"];
    getStringLabel.centerX           = backgroundView.centerX;
    getStringLabel.centerY           = backgroundView.centerY;
         }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Recordinfo *record =[[Recordinfo alloc]initWithDictionary:(NSDictionary *)[self.newrc.recList objectAtIndex:indexPath.section] error:nil] ;
    
    if(record.ShowType == 1)//优惠活动
    {
        DSUserRightDetailController *rightController    = [[DSUserRightDetailController alloc]init];
        rightController.hidesBottomBarWhenPushed        = YES;
        rightController.ConfigCode                      = record.UniqueNumber;
        [self.navigationController pushViewController:rightController animated:YES];
    }
    
    else if(record.ShowType == 2){//消费记录
        Recordinfo *record = [[Recordinfo alloc]initWithDictionary:(NSDictionary *)[self.newrc.recList objectAtIndex:indexPath.section] error:nil] ;
        DSConsumerDetailController *detaleController    = [[DSConsumerDetailController alloc]init];
        detaleController.hidesBottomBarWhenPushed       = YES;
        detaleController.record                         = record;
        [self.navigationController pushViewController:detaleController animated:YES];
    }else if(record.ShowType == 3){//活动赠送
        Recordinfo *record = [[Recordinfo alloc]initWithDictionary:(NSDictionary *)[self.newrc.recList objectAtIndex:indexPath.section] error:nil] ;
        DSConsumerDetailController *detaleController    = [[DSConsumerDetailController alloc]init];
        detaleController.hidesBottomBarWhenPushed       = YES;
        detaleController.titlename = @"活动赠送";
        detaleController.record                         = record;
        [self.navigationController pushViewController:detaleController animated:YES];
    }else if (record.ShowType == 4){
        if (record.ConsumptionType == 1) {
            //保养
            CareRemindViewController *new = [[CareRemindViewController alloc]init];
            new.getRemindType = @"1";
            new.wayGetHere = @"1";
            new.getID = record.UniqueNumber;
            new.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:new animated:YES];
        }else if (record.ConsumptionType == 2){
            //驾驶证
            DriverLicenseViewController *new = [[DriverLicenseViewController alloc]init];
            new.getRemindType = @"1";
            new.wayGetHere = @"1";
            new.getID = record.UniqueNumber;
            new.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:new animated:YES];
        }else if (record.ConsumptionType == 3){
            //年检
            YearTestViewController *new = [[YearTestViewController alloc]init];
            new.getRemindType = @"1";
            new.wayGetHere = @"1";
            new.getID = record.UniqueNumber;
            new.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:new animated:YES];
        }else if (record.ConsumptionType == 4){
            //车险
            InsurenceViewController *new = [[InsurenceViewController alloc]init];
            new.getRemindType = @"1";
            new.wayGetHere = @"1";
            new.getID = record.UniqueNumber;
            new.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:new animated:YES];
        }
    }//@end     车辆提醒
    
    
}


- (void) downloadButtonClick:(id)sender {
    
    DSDownloadController *downController     = [[DSDownloadController alloc]init];
    downController.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:downController animated:YES];
}

//- (void) locationButtonClick:(id)sender {
//    
//    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
//    cityViewController.title = @"城市";
//    __weak typeof(self) weakSelf = self;
//    [cityViewController choseCityBlock:^(NSString *cityName) {
//        
//        [weakSelf.locationButton setTitle:cityName forState:UIControlStateNormal];
//        
//        weakSelf.resultLabel.text = cityName;
//    }];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
//    [self presentViewController:navigationController animated:YES completion:nil];
//    
//}
//#pragma mark --- JFLocationDelegate

////定位中...
//- (void)locating {
//    NSLog(@"定位中...");
//}
//
////定位成功
//- (void)currentLocation:(NSDictionary *)locationDictionary {
//    NSString *city = [locationDictionary valueForKey:@"City"];
//    if (![_resultLabel.text isEqualToString:city]) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            _resultLabel.text = city;
//            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
//            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentCity"];
//            [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
//                [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
//            }];
//        }];
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}
//
///// 拒绝定位
//- (void)refuseToUsePositioningSystem:(NSString *)message {
//    NSLog(@"%@",message);
//}

///// 定位失败
//- (void)locateFailure:(NSString *)message {
//    NSLog(@"%@",message);
//}

- (void) tapPayButtonClick:(id)sender {
    DSExchangeController *exchangeVC        = [[DSExchangeController alloc]init];
    exchangeVC.hidesBottomBarWhenPushed     = YES;
    [self.navigationController pushViewController:exchangeVC animated:YES];
    
}
- (void) tapScanButtonClick:(id)sender {
//    self.tabBarController.selectedIndex = 2;
//    
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSString    *stringTime     = [defaults objectForKey:@"setTime"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *overdate = [dateFormatter dateFromString:stringTime];
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interva1 = [zone1 secondsFromGMTForDate: overdate];
    NSDate*endDate = [overdate dateByAddingTimeInterval: interva1];
    
    //获取当前时间
    NSDate*date = [NSDate date];
    NSTimeZone*zone2 = [NSTimeZone systemTimeZone];
    NSInteger interva2 = [zone2 secondsFromGMTForDate: date];
    NSDate *currentDate = [date dateByAddingTimeInterval: interva2];
    
    NSInteger intString;
    NSTimeInterval interval =[endDate timeIntervalSinceDate:currentDate];
    NSInteger gotime = round(interval);
    NSString *str2 = [[NSString stringWithFormat:@"%ld",(long)gotime] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    intString = [str2 intValue];
    
    if (intString > 0 && intString < 240) {
        
        DSStartWashingController *start = [[DSStartWashingController alloc]init];
//        [UdStorage storageObject:dateString forKey:@"setTime"];
  
        start.paynum=[UdStorage getObjectforKey:@"Jprice"];
        start.RemainCount = [UdStorage getObjectforKey:@"RemainCount"];
        start.IntegralNum = [UdStorage getObjectforKey:@"IntegralNum"];
        start.CardType = [UdStorage getObjectforKey:@"CardType"];
        start.CardName =[UdStorage getObjectforKey:@"CardName"];
//        start.second        = 240;
        start.hidesBottomBarWhenPushed            = YES;
        start.second                    = 240-intString;
        
        [self.navigationController pushViewController:start animated:YES];
//        [_session stopRunning];
        
    }else {
        self.tabBarController.selectedIndex = 2;
        //
        //
            [self.navigationController popToRootViewControllerAnimated:YES];

        
    }
    
//    DSScanQRCodeController *scanController      = [[DSScanQRCodeController alloc]init];
//    scanController.hidesBottomBarWhenPushed     = YES;
//    [self.navigationController pushViewController:scanController animated:YES];
    
//    ScanController * vc = [[ScanController alloc] init];
//    vc.returnScanBarCodeValue = ^(NSString * barCodeString){
//        self.resultLabel.text = [NSString stringWithFormat:@"扫描结果:\n%@",barCodeString];
//        NSLog(@"扫描结果的字符串======%@",barCodeString);
//    };
//    //    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void) tapCardBagButtonClick:(id)sender {
    DSCardGroupController *cardGroupController      = [[DSCardGroupController alloc]init];
    cardGroupController.hidesBottomBarWhenPushed    = YES;
    [self.navigationController pushViewController:cardGroupController animated:YES];
    
}
- (void) tapDiscountButtonClick:(id)sender {

    DSSaleActivityController *saleController    = [[DSSaleActivityController alloc]init];
    saleController.hidesBottomBarWhenPushed     = YES;
    [self.navigationController pushViewController:saleController animated:YES];

}

- (void) tapScoreButtonClick:(id)sender {
    
    DSMembershipController *membershipController        = [[DSMembershipController alloc]init];
    membershipController.hidesBottomBarWhenPushed       = YES;
    [self.navigationController pushViewController: membershipController animated: YES];
}

- (void) tapSignButtonClick:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    if([UdStorage getObjectforKey:@"SignTime"])
    {
        if([[UdStorage getObjectforKey:@"SignTime"] intValue]<[currentTimeString intValue])
        {
            NSDictionary *mulDic = @{
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/AddUserSign",Khttp] success:^(NSDictionary *dict, BOOL success) {
                
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {

                    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                    [inputFormatter setDateFormat:@"yyyy/MM/dd"];
                    NSDate* inputDate = [inputFormatter dateFromString:[[dict objectForKey:@"JsonData"] objectForKey:@"SignTime"]];
                    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                    [outputFormatter setLocale:[NSLocale currentLocale]];
                    [outputFormatter setDateFormat:@"yyyyMMdd"];
                    NSString *targetTime = [outputFormatter stringFromDate:inputDate];
                    
                    [UdStorage storageObject:targetTime forKey:@"SignTime"];
                    
                    
                    APPDELEGATE.currentUser.UserScore = APPDELEGATE.currentUser.UserScore + 10;
                    
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
                    
                    
                    
                    PopupView *view = [PopupView defaultPopupView];
                    view.parentVC = self;
                    
                    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
                        
                    }];
                }
                
                else
                {
                    [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
                }
                
                
                
            } fail:^(NSError *error) {
                [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
            }];

        }
        else
        {
            [self.view showInfo:@"今天已经签过到了" autoHidden:YES interval:2];
        }
    }
    else
    {
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/AddUserSign",Khttp] success:^(NSDictionary *dict, BOOL success) {
            
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                [inputFormatter setDateFormat:@"yyyy/MM/dd"];
                NSDate* inputDate = [inputFormatter dateFromString:[[dict objectForKey:@"JsonData"] objectForKey:@"SignTime"]];
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setLocale:[NSLocale currentLocale]];
                [outputFormatter setDateFormat:@"yyyyMMdd"];
                NSString *targetTime = [outputFormatter stringFromDate:inputDate];
                
                [UdStorage storageObject:targetTime forKey:@"SignTime"];
                
                APPDELEGATE.currentUser.UserScore = APPDELEGATE.currentUser.UserScore + 10;
                
                [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
                
                PopupView *view = [PopupView defaultPopupView];
                view.parentVC = self;
                
                [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
                    
                }];
            }
            
            else
            {
                [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
            }
            
            
            
        } fail:^(NSError *error) {
            [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
        }];

    }
    
    
    
    
    
    
    
    
    

    
}
- (void) tapMemberRightButtonClick:(id)sender {

    DSMemberRightsController *memberRightsVC    = [[DSMemberRightsController alloc]init];
    memberRightsVC.hidesBottomBarWhenPushed     = YES;
    [self.navigationController pushViewController:memberRightsVC animated:YES];

}
- (void) tapServiceButtonClick:(id)sender {

    DSServiceController *serviceVC          = [[DSServiceController alloc]init];
    serviceVC.hidesBottomBarWhenPushed      = YES;
    [self.navigationController pushViewController:serviceVC animated:YES];
}
- (void) tapMyCarButtonClick:(id)sender {
    
    DSMyCarController *myCarController                  = [[DSMyCarController alloc]init];
    myCarController.hidesBottomBarWhenPushed            = YES;
    [self.navigationController pushViewController:myCarController animated:YES];
}
- (void) tapShareButtonClick:(id)sender {
    
    DSShareGetMoneyController  *shareController     = [[DSShareGetMoneyController alloc]init];
    shareController.hidesBottomBarWhenPushed        = YES;
    [self.navigationController pushViewController:shareController animated:YES];
    
}
- (void) tapShopButtonClick:(id)sender {
    
    DSAddShopController *addMerchantController      = [[DSAddShopController alloc]init];
    addMerchantController.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:addMerchantController animated:YES];
    
}
- (void) tapCarClubButtonClick:(id)sender {
    
//    XueCarFirendViewController *new = [[XueCarFirendViewController alloc]init];
//    new.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:new animated:YES];
    
//    FindViewController *findController      = [[FindViewController alloc]init];
//    findController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:findController animated:YES];
    
    RemindViewController *new = [[RemindViewController alloc]init];
    new.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:new animated:YES];
    
}

- (void) tapNewButtonClick:(id)sender {

    MenuTabBarController *menuTabBarController	= [[MenuTabBarController alloc] init];
    [menuTabBarController setSelectedIndex:3];
    menuTabBarController.tabBarItem.tag = 3;
//    [menuTabBarController didSelectRouterAction];
    
    PurchaseViewController *purchaseController  = [[PurchaseViewController alloc]init];
    purchaseController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:purchaseController animated:YES];

}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    
////    NSLog(@"%f",self.tableView.contentOffset.y);
//    if (scrollView.contentOffset.y <= 0) {
//        scrollView.bounces = NO;
//        
//        NSLog(@"禁止下拉");
//    }
//    else
//        if (scrollView.contentOffset.y >= 0){
////            scrollView.bounces = YES;
//            NSLog(@"允许上拉");
//            
//        }

//    if（scrollView.contentOffset.y <= 0 ）{
//        scrollView.contentOffset.y = 0
//    }
//    // 禁止上拉
//    if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height {
//        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.size.height
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;//遵循代理
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 10.0f;
        
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        
        [self.locationManager startUpdatingLocation];//开始定位
        
    }else{//不能定位用户的位置的情况再次进行判断，并给与用户提示
        
        //1.提醒用户检查当前的网络状况
        
        //2.提醒用户打开定位开关
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法进行定位" message:@"请检查您的设备是否开启定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    
//    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
//    [UdStorage storageObject:@"青岛市" forKey:@"City"];
//    [UdStorage storageObject:@"市南区" forKey:@"Quyu"];
    [UdStorage storageObject:[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude] forKey:@"Ym"];
    [UdStorage storageObject:[NSString stringWithFormat:@"%f",currLocation.coordinate.longitude]  forKey:@"Xm"];
    
    NSLog(@"Ym=====%@",[UdStorage getObjectforKey:@"Ym"]);
    
    NSLog(@"Xm=====%@",[UdStorage getObjectforKey:@"Xm"]);

    
    
    
    
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *address = [placemark addressDictionary];
            
            //  Country(国家)  State(省)  City（市）
//            NSLog(@"#####%@",address);
//            
//            NSLog(@"%@", [address objectForKey:@"Country"]);
//            
//            NSLog(@"%@", [address objectForKey:@"State"]);
//            
//            NSLog(@"%@", [address objectForKey:@"City"]);
            
            NSString *subLocality=[address objectForKey:@"SubLocality"];
            
            self.LocCity = [address objectForKey:@"City"];
            
            [UdStorage storageObject:subLocality forKey:@"subLocality"];
            
            
        }
        
    }];
    
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    
//    
//    
//    CLLocation *location = [locations lastObject];
//    
//    NSLog(@"latitude === %g  longitude === %g",location.coordinate.latitude, location.coordinate.longitude);
//    
//    
//    
//    //反向地理编码
//    
//    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
//    
//    CLLocation *cl = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    
//    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
//        
//        for (CLPlacemark *placeMark in placemarks) {
//            
//            
//            
//            NSDictionary *addressDic = placeMark.addressDictionary;
//            
//            
//            
//            NSString *state=[addressDic objectForKey:@"State"];
//            
//            NSString *city=[addressDic objectForKey:@"City"];
//            
//            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
//            
//            NSString *street=[addressDic objectForKey:@"Street"];
//            
//            
//            
//            NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
//            
//            [_locationManager stopUpdatingLocation];
//            
//        }
//        
//    }];
//    
//}

-(void)noticeupdateUserheadimg:(NSNotification *)sender{
    //    UIImageView *imageV = [[UIImageView alloc]init];
    //    NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,APPDELEGATE.currentUser.userImagePath];
    //    NSURL *url=[NSURL URLWithString:ImageURL];
    //    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
//    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHTTPImg,[UdStorage getObjectforKey:UserHead]]] placeholderImage:[UIImage imageNamed:@"xichebaidi"]];
}

#pragma mark - 11.23Jack修改首页布局，tableViewHeader
//11.23Jack修改首页布局
-(void)creatJackHeaderView{
    
    //整个headerView
    UIView *jackHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 655.0/667*mainH)];
    jackHeaderView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    self.tableView.tableHeaderView = jackHeaderView;
    
    //第一部分(金色背景)
    UIView *goldenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 140.0/667*mainH)];
    goldenView.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
    [jackHeaderView addSubview:goldenView];
    
//    UIImageView*goldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 140)];
//    goldImageView.image = [UIImage imageNamed:@"2627"];
//    goldImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [goldenView addSubview:goldImageView];
    
    NSArray *fourTitleArray = @[@"扫一扫",@"卡包",@"会员特权",@"积分"];
    NSArray *fourTopImageArray = @[@"saoyisaoJ",@"kabaoJ",@"huiyuanJ",@"jifenJ"];
    for (int i = 0; i < fourTitleArray.count; i++) {
        
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(20.0/375*mainW + 92.0/375*mainW*i, 40.0/667*mainH, 60.0/375*mainW, 60.0/667*mainH)];
//        baseView.backgroundColor = [UIColor grayColor];
        [goldenView addSubview:baseView];
        
        UIImageView *imageViewJack = [[UIImageView alloc]initWithFrame:CGRectMake(10.0/375*mainW, 0, 40.0/375*mainW, 40.0/667*mainH)];
        imageViewJack.image = [UIImage imageNamed:fourTopImageArray[i]];
//        imageViewJack.backgroundColor = [UIColor redColor];
        [baseView addSubview:imageViewJack];
        
        UILabel *labelJack = [[UILabel alloc]initWithFrame:CGRectMake(-10, 50.0/667*mainH, 80.0/375*mainW, 30.0/667*mainH)];
//        labelJack.backgroundColor = [UIColor greenColor];
        labelJack.text = fourTitleArray[i];
        labelJack.textColor = [UIColor whiteColor];
        labelJack.font = [UIFont systemFontOfSize:16.0/375*mainW weight:16.0/375*mainW];
        labelJack.textAlignment = NSTextAlignmentCenter;
        [baseView addSubview:labelJack];
        

        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width/4*i, 0, Main_Screen_Width/4, 140.0/667*mainH)];
        button.tag = i + 100;
        [button addTarget:self action:@selector(fourButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [goldenView addSubview:button];
    }
    
    //添加爱车按钮
    CGFloat addButtonHeight = 90.0/667*mainH;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, 155.0/667*mainH, Main_Screen_Width-30, 60.0/667*mainH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.clipsToBounds = YES;
    whiteView.layer.cornerRadius = 10;
    [jackHeaderView addSubview:whiteView];
    
    UIImageView *addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15.0/667*mainH, 30.0/375*mainW, 30.0/667*mainH)];
    addImageView.clipsToBounds = YES;
    addImageView.layer.cornerRadius = 15.0/667*mainH;
    addImageView.image = [UIImage imageNamed:@"tianjiaaiche"];
    [whiteView addSubview:addImageView];
    
    _addCarInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10.0/667*mainH, 250, 20.0/667*mainH)];
    _addCarInfoLabel.text = @"添加爱车享免费洗车";
    _addCarInfoLabel.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:_addCarInfoLabel];
    
    _subAddCarLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 32.0/667*mainH, 200, 20.0/667*mainH)];
    _subAddCarLabel.text = @"洗车、保养、换轮胎";
    _subAddCarLabel.textColor = [UIColor colorFromHex:@"#909090"];
    _subAddCarLabel.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:_subAddCarLabel];
    
    
    
    UIButton *addCarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 140.0/667*mainH, Main_Screen_Width, addButtonHeight)];
    addCarButton.backgroundColor = [UIColor clearColor];
    [addCarButton addTarget:self action:@selector(addCarAction) forControlEvents:(UIControlEventTouchUpInside)];
    [jackHeaderView addSubview:addCarButton];
    
    //车辆提醒等4个按钮
    
    
    UIImageView *minBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 140.0/667*mainH+addButtonHeight, Main_Screen_Width, 110.0/667*mainH)];
    minBackImageView.image = [UIImage imageNamed:@"fourImage"];
    minBackImageView.contentMode = UIViewContentModeScaleAspectFit;
    [jackHeaderView addSubview:minBackImageView];
    NSArray *minTitleArray = @[@"shouye_cheliangtixing",@"jihuo",@"youhuihuodong",@"qiandao"];
//    NSArray *titleArray = @[@"车辆提醒",@"激活卡券",@"优惠活动",@"每日签到"];
    for (int n = 0; n < minTitleArray.count; n ++) {
        
//        UIImageView *minImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50+82 * n, 170+addButtonHeight, 25, 25)];
//        minImageView.image = [UIImage imageNamed:minTitleArray[n]];
//        minImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [jackHeaderView addSubview:minImageView];
//
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25+n*(Main_Screen_Width-50)/4, 210+addButtonHeight, (Main_Screen_Width-50)/4, 30)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor colorFromHex:@"#909090"];
//        label.font = [UIFont systemFontOfSize:13];
//        label.text = titleArray[n];
//        [jackHeaderView addSubview:label];
        
        
        UIButton *minButton = [[UIButton alloc]initWithFrame:CGRectMake(n*Main_Screen_Width/4, 140.0/667*mainH+addButtonHeight, Main_Screen_Width/4, 110.0/667*mainH)];
        minButton.tag = n + 200;
        minButton.backgroundColor = [UIColor clearColor];
        [minButton addTarget:self action:@selector(carReminFourAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [jackHeaderView addSubview:minButton];
    }//@end for
    
    //我是屌丝我要买卡
    
    UIImageView *buyCardImageViwe = [[UIImageView alloc]initWithFrame:CGRectMake(15, 260.0/667*mainH+addButtonHeight, Main_Screen_Width-30, 70.0/667*mainH)];
    buyCardImageViwe.image = [UIImage imageNamed:@"qugouka"];
    buyCardImageViwe.contentMode = UIViewContentModeScaleAspectFit;
    [jackHeaderView addSubview:buyCardImageViwe];
    
    
    UIButton *buyCardButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 250.0/667*mainH+addButtonHeight, Main_Screen_Width, 100.0/667*mainH)];
    buyCardButton.backgroundColor = [UIColor clearColor];
//    [buyCardButton setTitle:@"洗车卡购买入口" forState:(UIControlStateNormal)];
    [buyCardButton addTarget:self action:@selector(toBuyCard) forControlEvents:(UIControlEventTouchUpInside)];
    [jackHeaderView addSubview:buyCardButton];
    
    //8个模块
    UIImageView *eightBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 350.0/667*mainH+addButtonHeight, Main_Screen_Width, 200.0/667*mainH)];
    eightBackImageView.image = [UIImage imageNamed:@"2627eight"];
    eightBackImageView.contentMode = UIViewContentModeScaleAspectFit;
    [jackHeaderView addSubview:eightBackImageView];
    NSArray *carShitArray = @[@"汽车改装",@"汽车美容",@"汽车保险",@"二手车",@"汽车维修",@"汽车清洁",@"车品商城",@"汽车品牌"];
    for (int m = 0; m < carShitArray.count; m ++) {
        UIButton *shitButton = [[UIButton alloc]initWithFrame:CGRectMake(m%4*Main_Screen_Width/4,350.0/667*mainH+addButtonHeight+ m/4*100, Main_Screen_Width/4, 100.0/667*mainH)];
//        NSLog(@"aaaaaaaaaaaa%d",m/4);
        shitButton.tag = 300 + m;
        shitButton.backgroundColor = [UIColor clearColor];
        [shitButton addTarget:self action:@selector(eightButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//        [shitButton setTitle:carShitArray[m] forState:(UIControlStateNormal)];
        [jackHeaderView addSubview:shitButton];
    }
    
    
}

//11.23Jack修改首页布局动作
-(void)fourButtonAction:(UIButton *)sender{
    if (sender.tag == 100) {
        //扫一扫
//        NSLog(@"1");
        NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
        NSString    *stringTime     = [defaults objectForKey:@"setTime"];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *overdate = [dateFormatter dateFromString:stringTime];
        NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
        NSInteger interva1 = [zone1 secondsFromGMTForDate: overdate];
        NSDate*endDate = [overdate dateByAddingTimeInterval: interva1];
        
        //获取当前时间
        NSDate*date = [NSDate date];
        NSTimeZone*zone2 = [NSTimeZone systemTimeZone];
        NSInteger interva2 = [zone2 secondsFromGMTForDate: date];
        NSDate *currentDate = [date dateByAddingTimeInterval: interva2];
        
        NSInteger intString;
        NSTimeInterval interval =[endDate timeIntervalSinceDate:currentDate];
        NSInteger gotime = round(interval);
        NSString *str2 = [[NSString stringWithFormat:@"%ld",(long)gotime] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        intString = [str2 intValue];
        
        if (intString > 0 && intString < 240) {
            
            //正在洗车进入到这里
            DSStartWashingController *start = [[DSStartWashingController alloc]init];
            //        [UdStorage storageObject:dateString forKey:@"setTime"];
            
            start.paynum=[UdStorage getObjectforKey:@"Jprice"];
            start.RemainCount = [UdStorage getObjectforKey:@"RemainCount"];
            start.IntegralNum = [UdStorage getObjectforKey:@"IntegralNum"];
            start.CardType = [UdStorage getObjectforKey:@"CardType"];
            start.CardName =[UdStorage getObjectforKey:@"CardName"];
            //        start.second        = 240;
            start.hidesBottomBarWhenPushed            = YES;
            start.second                    = 240-intString;
            
            [self.navigationController pushViewController:start animated:YES];
            //        [_session stopRunning];
            
        }else {
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
    }else if (sender.tag == 101){
        //卡包
//        NSLog(@"2");
        DSCardGroupController *cardGroupController      = [[DSCardGroupController alloc]init];
        cardGroupController.hidesBottomBarWhenPushed    = YES;
        [self.navigationController pushViewController:cardGroupController animated:YES];
    }else if (sender.tag == 102){
        //会员特权
//        NSLog(@"3");
        DSMemberRightsController *memberRightsVC    = [[DSMemberRightsController alloc]init];
        memberRightsVC.hidesBottomBarWhenPushed     = YES;
        [self.navigationController pushViewController:memberRightsVC animated:YES];
    }else if (sender.tag == 103){
        //积分
//        NSLog(@"4");
        DSMembershipController *membershipController        = [[DSMembershipController alloc]init];
        membershipController.hidesBottomBarWhenPushed       = YES;
        [self.navigationController pushViewController: membershipController animated: YES];
    }
}

//添加爱车获得洗车卡
-(void)addCarAction{
    
    DSMyCarController *new = [[DSMyCarController alloc]init];
    new.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:new animated:YES];
    
//    if ([self.getCarCode isEqualToString:@"0"]) {
//        CYCarInsertViewController *new = [[CYCarInsertViewController alloc]init];
//        new.open=1;
//        new.fromHome = @"1";
//        new.CyTYpe = @"编辑车辆信息";
//        new.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:new animated:YES];
//    }else{
//        CYCarInsertViewController *new = [[CYCarInsertViewController alloc]init];
//        new.open=1;
//        new.fromHome = @"1";
//        new.CyTYpe = @"编辑车辆信息";
//        new.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:new animated:YES];
//    }
    
    
}

//车辆提醒等四个
-(void)carReminFourAction:(UIButton *)sender{
    if (sender.tag == 200) {
        //车辆提醒
        RemindViewController *new = [[RemindViewController alloc]init];
        new.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:new animated:YES];
    }else if (sender.tag == 201){
        //激活卡券
        DSExchangeController *exchangeVC        = [[DSExchangeController alloc]init];
        exchangeVC.hidesBottomBarWhenPushed     = YES;
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }else if (sender.tag == 202){
        //优惠活动
        DSSaleActivityController *saleController    = [[DSSaleActivityController alloc]init];
        saleController.hidesBottomBarWhenPushed     = YES;
        [self.navigationController pushViewController:saleController animated:YES];
    }else if (sender.tag == 203){
        //每日签到
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMdd"];
        NSDate *datenow = [NSDate date];
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        
        if([UdStorage getObjectforKey:@"SignTime"])
        {
            if([[UdStorage getObjectforKey:@"SignTime"] intValue]<[currentTimeString intValue])
            {
                NSDictionary *mulDic = @{
                                         @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                         };
                NSDictionary *params = @{
                                         @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                         @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                         };
                
                [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/AddUserSign",Khttp] success:^(NSDictionary *dict, BOOL success) {
                    
                    if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                    {
                        
                        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                        [inputFormatter setDateFormat:@"yyyy/MM/dd"];
                        NSDate* inputDate = [inputFormatter dateFromString:[[dict objectForKey:@"JsonData"] objectForKey:@"SignTime"]];
                        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                        [outputFormatter setLocale:[NSLocale currentLocale]];
                        [outputFormatter setDateFormat:@"yyyyMMdd"];
                        NSString *targetTime = [outputFormatter stringFromDate:inputDate];
                        
                        [UdStorage storageObject:targetTime forKey:@"SignTime"];
                        
                        
                        APPDELEGATE.currentUser.UserScore = APPDELEGATE.currentUser.UserScore + 10;
                        
                        [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
                        
                        
                        
                        PopupView *view = [PopupView defaultPopupView];
                        view.parentVC = self;
                        
                        [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
                            
                        }];
                    }
                    
                    else
                    {
                        [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
                    }
                    
                    
                    
                } fail:^(NSError *error) {
                    [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
                }];
                
            }
            else
            {
                [self.view showInfo:@"今天已经签过到了" autoHidden:YES interval:2];
            }
        }
        else
        {
            NSDictionary *mulDic = @{
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/AddUserSign",Khttp] success:^(NSDictionary *dict, BOOL success) {
                
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {
                    
                    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                    [inputFormatter setDateFormat:@"yyyy/MM/dd"];
                    NSDate* inputDate = [inputFormatter dateFromString:[[dict objectForKey:@"JsonData"] objectForKey:@"SignTime"]];
                    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                    [outputFormatter setLocale:[NSLocale currentLocale]];
                    [outputFormatter setDateFormat:@"yyyyMMdd"];
                    NSString *targetTime = [outputFormatter stringFromDate:inputDate];
                    
                    [UdStorage storageObject:targetTime forKey:@"SignTime"];
                    
                    APPDELEGATE.currentUser.UserScore = APPDELEGATE.currentUser.UserScore + 10;
                    
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
                    
                    PopupView *view = [PopupView defaultPopupView];
                    view.parentVC = self;
                    
                    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
                        
                    }];
                }
                
                else
                {
                    [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
                }
                
                
                
            } fail:^(NSError *error) {
                [self.view showInfo:@"签到失败" autoHidden:YES interval:2];
            }];
            
        }
    }
}

//滚去购买洗车卡
-(void)toBuyCard{
    self.tabBarController.selectedIndex = 3;
}

//底部八个按钮动作
-(void)eightButtonAction:(UIButton*)sender{
    
    UselessViewController *new = [[UselessViewController alloc]init];
    new.hidesBottomBarWhenPushed = YES;
    
    if (sender.tag == 300) {
        NSLog(@"汽车改装");
        new.getTitleString = @"汽车改装";
    }else if (sender.tag == 301){
        NSLog(@"汽车美容");
        new.getTitleString = @"汽车美容";
    }else if (sender.tag == 302){
        NSLog(@"汽车保险");
        new.getTitleString = @"汽车保险";
    }else if (sender.tag == 303){
        NSLog(@"二手车");
        new.getTitleString = @"二手车";
    }else if (sender.tag == 304){
        NSLog(@"汽车维修");
        new.getTitleString = @"汽车维修";
    }else if (sender.tag == 305){
        NSLog(@"汽车情节");
        new.getTitleString = @"汽车清洁";
    }else if (sender.tag == 306){
        NSLog(@"车品商城");
        new.getTitleString = @"车品商城";
    }else if (sender.tag == 307){
        NSLog(@"汽车品牌");
        new.getTitleString = @"汽车品牌";
    }

    [self.navigationController pushViewController:new animated:YES];
}





@end
