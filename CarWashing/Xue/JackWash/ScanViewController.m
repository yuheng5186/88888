//
//  ScanViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/12/11.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ScanViewController.h"
//#import "WashController.h"
//#import "InputViewController.h"
//上传参数
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "AFNetworkingTool+GetToken.h"
#import "LCMD5Tool.h"

#import "PopHelpView.h"      //帮助按钮动作
#import "LewPopupViewAnimationDrop.h"//帮助按钮动画
#import "DSInputCodeController.h" //手动输入
#import "ScanCode.h"                //最早的坑逼模型
#import "CYModel.h"


#import "DSScanPayController.h" //扫码支付
#import "DSStartWashingController.h"
#import "DSConsumerDetailController.h"

#import "Record.h"      //扫码商家详情
#import "ScanModelJack.h"
#import "MJExtension.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    NSString * Cystr;
    MBProgressHUD *HUD;
}
@property(strong,nonatomic)UIView *fakeNavigation;

@property(strong,nonatomic)UIButton *nextButton;            //模拟扫描二维码成功的动作
@property(strong,nonatomic)UIButton *handWriteButton;       //手动输入机器码
@property(copy,nonatomic)NSString *toGoString;              //进入手动输入可返回扫码

//原UI所涉及到的
@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetImageView;
@property (nonatomic, strong) UIButton * flashlight;
@property (nonatomic, strong) UILabel * flashlightSwitch;
@property (nonatomic, strong) UIButton * inputButton;
@property (nonatomic, strong) UILabel * inputLabel;
@property (nonatomic, strong) AVCaptureSession *session;    //扫描实时显示
@property (nonatomic, strong) ScanCode *scan;               //最早的模型
@property (strong, nonatomic)CYModel *newrc;
@property(nonatomic,copy)Recordinfo *record;                //商家详情模型
//动画相关两个
@property(strong,nonatomic)UIImageView *JackScanImageView;      //上下滚动的动画
@property(copy,nonatomic)NSString *animString;

@end

@implementation ScanViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fakeNavigation];
    
    //初始化toGoString：""不可返回 / "1"可返回
    self.toGoString = @"";
    
    
    //1.扫描区域(没有功能)
    [self setupScanWindowView];
    //2.开始动画
    [self beginScanning];
    //动画相关
//    [self.view addSubview:self.JackScanImageView];
    [self jackAction];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.animString = @"stop";
    if ([self.toGoString isEqualToString:@""]) {
        //扫码成功，开始洗车页面，不会再返回到该页面
        //获取到目前navigation中的controller
        NSMutableArray *viewConArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        //删除了扫描页面的viewcontroller
        [viewConArray removeObject:self];
        self.navigationController.viewControllers = viewConArray;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{

    // 先判断摄像头硬件是否好用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        // 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"您已经禁止金顶洗车访问摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:nil];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                self.tabBarController.selectedIndex = 0;
                
            }];
            [alertC addAction:action];
        }else{
            ////这里是摄像头可以使用的处理逻辑
//            [self resumeAnimation];
            [_session startRunning];
        }
    } else {
        /// 硬件问题提示
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"未检测到摄像头" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertView addAction:sureAction];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
}

#pragma mark - 懒加载fakeNavigation
-(UIView *)fakeNavigation{
    
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
        _fakeNavigation.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"扫码洗车";
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
        
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-90,15, 80, 51)];
        editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [editButton setTitle:@"使用帮助" forState:(UIControlStateNormal)];
        [editButton addTarget:self action:@selector(helpButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_fakeNavigation addSubview:editButton];
        
    }
    return _fakeNavigation;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) helpButtonClick:(id)sender {
    
    PopHelpView *view = [PopHelpView defaultPopHelpView:@"一键扫码，快速开启"];
    view.parentVC = self;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
        
    }];
}

-(UIImageView*)JackScanImageView{
    if (!_JackScanImageView) {
        _JackScanImageView = [[UIImageView alloc]init];
        _JackScanImageView.image = [UIImage imageNamed:@"saomiaozhong"];
        _JackScanImageView.frame = CGRectMake(Main_Screen_Width/2, -250.0/375*Main_Screen_Width, 250.0/375*Main_Screen_Width, 250.0/375*Main_Screen_Width);
        _JackScanImageView.centerX = 125.0/375*Main_Screen_Width;
        //        _JackScanImageView.top = self.scanImageView.top;
        
    }
    return _JackScanImageView;
}

-(void)jackAction{
    if ([self.animString isEqualToString:@"stop"]) {
        return;
    }else{
        [UIView animateWithDuration:3.0 animations:^{
            self.JackScanImageView.frame = CGRectMake(Main_Screen_Width/2, 40.0/375*Main_Screen_Width, 250.0/375*Main_Screen_Width, 250.0/375*Main_Screen_Width);
            self.JackScanImageView.centerX = 125.0/375*Main_Screen_Width;
        } completion:^(BOOL finished) {
            self.JackScanImageView.frame = CGRectMake(Main_Screen_Width/2, -250.0/375*Main_Screen_Width, 250.0/375*Main_Screen_Width, 250.0/375*Main_Screen_Width);
            self.JackScanImageView.centerX = 125.0/375*Main_Screen_Width;
            [self jackAction];
        }];
    }
}


#pragma mark - 创建扫描图层，无扫描功能
- (void)setupScanWindowView
{
    UIImageView *scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saomakuang"]];
    scanImageView.width = Main_Screen_Width - 65*2*Main_Screen_Height/667;
    scanImageView.height = Main_Screen_Width - 65*2*Main_Screen_Height/667;
    scanImageView.centerX = Main_Screen_Width/2;
    scanImageView.centerY = self.contentView.height/2-50*Main_Screen_Height/667;
    
    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saomiaozhong"]];
    scanImageView.clipsToBounds = YES;
    [self.contentView addSubview:scanImageView];
    [scanImageView addSubview:self.JackScanImageView];
    self.scanWindow = scanImageView;
    
    
    NSString *tooltip = @"请对准机器上的二维码";
    
    UIFont *textFont = [UIFont boldSystemFontOfSize:Main_Screen_Height*18/667];
    UILabel *lbl = [UIUtil drawLabelInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, [UIUtil textHeight:tooltip font:textFont]) font:textFont text:tooltip isCenter:YES color:[UIColor whiteColor]];
    lbl.numberOfLines = 0;
    lbl.centerY = scanImageView.top/2;
    lbl.top     = self.scanWindow.bottom +Main_Screen_Height*20/667;
    
    
    self.flashlight     = [UIUtil drawButtonInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*100/375, Main_Screen_Height*50/667) iconName:@"Flashlight_N" target:self action:@selector(flashlightButtonClcik:)];
    self.flashlight.top = lbl.bottom +Main_Screen_Height*50/667;
    self.flashlight.right = scanImageView.right;
    
    NSString  *openString     = @"打开手电筒";
    UIFont    *openStringFont = [UIFont systemFontOfSize:Main_Screen_Height*15/667];
    self.flashlightSwitch     = [UIUtil drawLabelInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*150/375, Main_Screen_Height*20/667) font:openStringFont text:openString isCenter:NO];
    self.flashlightSwitch.textColor = [UIColor whiteColor];
    self.flashlightSwitch.top = self.flashlight.bottom +Main_Screen_Height*10/667;
    self.flashlightSwitch.left  = self.flashlight.left+Main_Screen_Height*10/667;
    
    self.inputButton        = [UIUtil drawButtonInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*100/375, Main_Screen_Height*50/667) iconName:@"shurubianhao" target:self action:@selector(inputButtonClcik:)];
    self.inputButton.top    = lbl.bottom +Main_Screen_Height*50/667;
    self.inputButton.left   = scanImageView.left;
    
    NSString  *inpotString       = @"输入编号开锁";
    UIFont    *inputStringFont   = [UIFont systemFontOfSize:Main_Screen_Height*15/667];
    self.inputLabel             = [UIUtil drawLabelInView:self.contentView frame:[UIUtil textRect:inpotString font:inputStringFont]font:inputStringFont text:inpotString isCenter:NO];
    self.inputLabel.textColor   = [UIColor whiteColor];
    self.inputLabel.top         = self.inputButton.bottom +Main_Screen_Height*10/667;
    self.inputLabel.centerX     = self.inputButton.centerX;
}
- (void) inputButtonClcik:(UIButton *)sender {
    
    //self.toGoString = @"1"        手动输入页面仍可返回到此界面
    self.toGoString = @"1";
    DSInputCodeController    *inputCodeVC     = [[DSInputCodeController alloc]init];
    inputCodeVC.hidesBottomBarWhenPushed         = YES;
    [self.navigationController pushViewController:inputCodeVC animated:YES];
    
}
- (void) flashlightButtonClcik:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"kaishoudiantong"] forState:UIControlStateSelected];
        self.flashlightSwitch.text  = @"关闭手电筒";
        //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        
    }else{
        [sender setImage:[UIImage imageNamed:@"Flashlight_N"] forState:UIControlStateSelected];
        self.flashlightSwitch.text  = @"打开手电筒";
        //关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

#pragma mark-> 实时显示扫描的画面
- (void)beginScanning
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = devices.firstObject;
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == AVCaptureDevicePositionBack ) {
            captureDevice = device;
            break;
        }
    }
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanCrop=[self getScanCrop:self.scanWindow.bounds readerViewBounds:self.contentView.frame];
    output.rectOfInterest = scanCrop;
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.contentView.layer.bounds;
    [self.contentView.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    return CGRectMake(x, y, width, height);
    
}

//获取到扫描的信息
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSString *qaMessage = metadataObject.stringValue;
        [self handleScanData:qaMessage];
    }
}

#pragma mark-> 开始使用获取到的信息
- (void)handleScanData:(NSString *)outMessage{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    
    //停止调用相机
    [_session stopRunning];
    
    //获取到的信息
    NSString *imei = outMessage;
    NSArray *array = [imei componentsSeparatedByString:@":"];//获取其中有用的元素
    if ((array.count==3&&((NSString *)array[1]).length==8)) {
        //二维码规则正确
        NSDictionary *mulDic = @{
                                 @"DeviceCode":array[1],
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@ScanCode/DeviceScanCode",Khttp] success:^(NSDictionary *dict, BOOL success) {
            [HUD hide:YES];
            if ([[dict objectForKey:@"ResultCode"] isEqualToString:@"F000000"]) {
                //机器号码正确,需要判断是否需要支付
                NSLog(@"%@",dict);
                NSDictionary *tempDict = dict[@"JsonData"];
                ScanModelJack *scanModel = [ScanModelJack mj_objectWithKeyValues:tempDict];
                if (scanModel.ScanCodeState == 1) {
                    //需要支付
                    DSScanPayController *payVC           = [[DSScanPayController alloc]init];
                    payVC.hidesBottomBarWhenPushed            = YES;
                    payVC.SerMerChant = [NSString stringWithFormat:@"%@",scanModel.DeviceName];
                    payVC.SerProject = [NSString stringWithFormat:@"%@",scanModel.ServiceItems];
                    payVC.Jprice = [NSString stringWithFormat:@"¥%.2f",scanModel.OriginalAmt];
                    //花费实际价格
                    payVC.Xprice = [NSString stringWithFormat:@"¥%.2f",scanModel.Amt];
                    payVC.DeviceCode = [NSString stringWithFormat:@"%@",scanModel.DeviceCode];
                    //存下空的卡片名称和实际支付的金额
                    [UdStorage storageObject:scanModel.CardName forKey:@"CardName"];
                    [UdStorage storageObject:[NSString stringWithFormat:@"¥%.2f",scanModel.Amt] forKey:@"realPayAmount"];
                    [weakSelf.navigationController pushViewController:payVC animated:YES];
                }else{
                    //有卡，直接扣卡
                    //开始获取当前时间
                    NSDate *startWashDate = [NSDate date];
                    //本地化储存开始时间
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:startWashDate forKey:@"startTime"];
                    [defaults synchronize]; //保存变更
                    self.toGoString = @"";
                    //原价
                    [UdStorage storageObject:[NSString stringWithFormat:@"￥%.2f",scanModel.OriginalAmt] forKey:@"Jprice"];
                    //剩余次数
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",(long)scanModel.RemainCount] forKey:@"RemainCount"];
                    //积分数量
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",(long)scanModel.IntegralNum] forKey:@"IntegralNum"];
                    //卡片类型
                    [UdStorage storageObject:[NSString stringWithFormat:@"%ld",(long)scanModel.CardType] forKey:@"CardType"];
                    //卡片名称（判断依据）
                    [UdStorage storageObject:scanModel.CardName forKey:@"CardName"];
                    
                    DSStartWashingController *start = [[DSStartWashingController alloc]init];
                    //测试
                    start.CardName = [UdStorage getObjectforKey:@"CardName"];
                    start.hidesBottomBarWhenPushed            = YES;
                    
                    start.RemainCount   = [NSString stringWithFormat:@"%ld",(long)scanModel.RemainCount];
                    start.IntegralNum   = [NSString stringWithFormat:@"%ld",(long)scanModel.IntegralNum];
                    start.CardType      = [NSString stringWithFormat:@"%ld",(long)scanModel.CardType];
                    start.CardName      = [NSString stringWithFormat:@"%@",scanModel.CardName];
                    start.paynum=[NSString stringWithFormat:@"￥%f",scanModel.Amt];
                    start.second        = 240;
                    
                    
                    [weakSelf.navigationController pushViewController:start animated:YES];
                }
            }else{
                //机器编号不存在，返回00007
                [HUD hide:YES];
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"洗车机编号不存在" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.session startRunning];
                }];
                [alertView addAction:sureAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        } fail:^(NSError *error) {
            //网络错误
            [HUD hide:YES];
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"网络错误，请稍后重试" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.session startRunning];
            }];
            [alertView addAction:sureAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }];

    }else{
        //无效二维码
        [HUD hide:YES];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"非可识别二维码，请扫描可用二维码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.session startRunning];
        }];
        [alertView addAction:sureAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    NSLog(@"相机扫描页面被释放！");
}



@end
