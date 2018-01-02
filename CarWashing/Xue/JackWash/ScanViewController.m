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

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,LKAlertViewDelegate>
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
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
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
            
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"您已经禁止蔷薇爱车访问摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
        _fakeNavigation.backgroundColor = [UIColor colorWithRed:13/255.0 green:98/255.0 blue:159/255.0 alpha:1];
        
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

#pragma mark - 创建扫描图层，无扫描功能
- (void)setupScanWindowView
{
    UIImageView *scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saomakuang"]];
    scanImageView.width = Main_Screen_Width - 65*2*Main_Screen_Height/667;
    scanImageView.height = Main_Screen_Width - 65*2*Main_Screen_Height/667;
    scanImageView.centerX = Main_Screen_Width/2;
    scanImageView.centerY = self.contentView.height/2-50*Main_Screen_Height/667;
    
    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saomiaozhong"]];
    
    [self.contentView addSubview:scanImageView];
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

    if ([imei rangeOfString:@":"].location !=NSNotFound) {
        //洗车设备“：”
        NSArray *array = [imei componentsSeparatedByString:@":"];//获取其中有用的元素
        if ((array.count==3&&((NSString *)array[1]).length==8)) {
            //格式正确,开始下一步
            NSDictionary *mulDic = @{
                                     @"DeviceCode":array[1],
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@ScanCode/DeviceScanCodeQuery",Khttp] success:^(NSDictionary *dict, BOOL success) {
                [HUD hide:YES];
                if ([[dict objectForKey:@"ResultCode"] isEqualToString:@"F000000"]) {
                    NSDictionary *arr = dict[@"JsonData"];
                    //获取到支付状态，价格
                    NSString *stateString = [NSString stringWithFormat:@"%@",arr[@"ScanCodeState"]];
                    NSString *moneyString = [NSString stringWithFormat:@"%@",arr[@"OriginalAmt"]];
                    //给模型赋值
                    self.scan = [[ScanCode alloc]init];
                    [self.scan mj_setKeyValues:arr];
                    if ([stateString isEqualToString:@"1"]) {
                        //需要支付
                        UIAlertController *sureController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前用户无洗车卡，是否在线支付洗车,费用为￥%@",moneyString] preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去支付" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            //////////////广告开始//////////////////
                            NSArray * adverArray = dict[@"JsonData"][@"advList"];
                            if (adverArray.count!=0) {
                                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",dict[@"JsonData"][@"advList"][0][@"AdvertisImg"] ] forKey:@"adverUrl"];
                            }
                            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",dict[@"JsonData"][@"redModel"][@"url"] ] forKey:@"ShareUrl"];
                            ///////////////广告结束/////////////////
                            DSScanPayController *payVC           = [[DSScanPayController alloc]init];
//                            payVC.payType =@":";
                            payVC.hidesBottomBarWhenPushed            = YES;
                            payVC.SerMerChant = weakSelf.scan.DeviceName;
                            payVC.SerProject = weakSelf.scan.ServiceItems;
                            payVC.Jprice = [NSString stringWithFormat:@"￥%@",weakSelf.scan.OriginalAmt];
                            payVC.Xprice = [NSString stringWithFormat:@"￥%@",weakSelf.scan.Amt];
                            payVC.DeviceCode = weakSelf.scan.DeviceCode;
                            payVC.RemainCount = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.RemainCount];
                            payVC.IntegralNum = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.IntegralNum];
                            payVC.CardType = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.CardType];
                            payVC.CardName = weakSelf.scan.CardName;
                            
                            [weakSelf.navigationController pushViewController:payVC animated:YES];
                        }];//@end sureAction
                        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action){
                            [weakSelf.session startRunning];
                        }];//@end cancleAction
                        [sureController addAction:sureAction];
                        [sureController addAction:cancleAction];
                        [self presentViewController:sureController animated:YES completion:nil];
                        
                    }else if ([stateString isEqualToString:@"2"]){
                        //有卡可以直接用洗车卡结算
                        UIAlertController *sureController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否使用%@来支付洗车服务",dict[@"JsonData"][@"CardName"]] preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"使用" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            NSDictionary *mulDic = @{
                                                     @"DeviceCode":array[1],
                                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                                     };
                            NSDictionary *params1 = @{
                                                      @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                                      @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                                      };
                            [AFNetworkingTool post:params1 andurl:[NSString stringWithFormat:@"%@ScanCode/DeviceScanCodeNew",Khttp] success:^(NSDictionary *dict, BOOL success) {
                                if ([[dict objectForKey:@"ResultCode"]isEqualToString:@"F000000"]) {
                                    [HUD hide:YES];
                                    NSDictionary *arr = [NSDictionary dictionary];
                                    arr = [dict objectForKey:@"JsonData"];
                                    weakSelf.scan = [[ScanCode alloc]init];
                                    [weakSelf.scan mj_setKeyValues:arr];
                                    //(1.需要支付状态,2.扫描成功)
                                    if(weakSelf.scan.ScanCodeState == 1)
                                    {
                                        //还是需要支付
                                        DSScanPayController *payVC           = [[DSScanPayController alloc]init];
                                        payVC.hidesBottomBarWhenPushed            = YES;
                                        
                                        payVC.SerMerChant = weakSelf.scan.DeviceName;
                                        payVC.SerProject = weakSelf.scan.ServiceItems;
                                        payVC.Jprice = [NSString stringWithFormat:@"￥%@",weakSelf.scan.OriginalAmt];
                                        payVC.Xprice = [NSString stringWithFormat:@"￥%@",weakSelf.scan.Amt];
                                        payVC.DeviceCode = weakSelf.scan.DeviceCode;
                                        payVC.RemainCount = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.RemainCount];
                                        payVC.IntegralNum = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.IntegralNum];
                                        payVC.CardType = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.CardType];
                                        payVC.CardName = weakSelf.scan.CardName;
                                        [weakSelf.navigationController pushViewController:payVC animated:YES];
                                    }else{
                                        //牛逼，开始大保健
                                        //开始获取当前时间
                                        NSDate *startWashDate = [NSDate date];
                                        //本地化储存开始时间
                                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                        [defaults setObject:startWashDate forKey:@"startTime"];
                                        [defaults synchronize]; //保存变更
                                        self.toGoString = @"";
                                        
//                                        NSDate*date                     = [NSDate date];
//                                        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
//                                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                                        NSString *dateString        = [dateFormatter stringFromDate:date];
//                                        NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
//                                        [defaults setObject:dateString forKey:@"setTime"];
//                                        [defaults synchronize];
                                        
                                        [UdStorage storageObject:[NSString stringWithFormat:@"￥%@",weakSelf.scan.OriginalAmt] forKey:@"Jprice"];
                                        [UdStorage storageObject:[NSString stringWithFormat:@"%ld",weakSelf.scan.RemainCount] forKey:@"RemainCount"];
                                        [UdStorage storageObject:[NSString stringWithFormat:@"%ld",weakSelf.scan.IntegralNum] forKey:@"IntegralNum"];
                                        [UdStorage storageObject:[NSString stringWithFormat:@"%ld",weakSelf.scan.CardType] forKey:@"CardType"];
                                        [UdStorage storageObject:weakSelf.scan.CardName forKey:@"CardName"];
                                        DSStartWashingController *start = [[DSStartWashingController alloc]init];
                                        start.hidesBottomBarWhenPushed            = YES;
                                        start.RemainCount   = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.RemainCount];
                                        start.IntegralNum   = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.IntegralNum];
                                        start.CardType      = [NSString stringWithFormat:@"%ld",weakSelf.scan.CardType];
                                        start.CardName      = weakSelf.scan.CardName;
                                        start.paynum=[NSString stringWithFormat:@"￥%@",weakSelf.scan.OriginalAmt];
                                        start.second        = 240;
                                        NSArray * adverArray = dict[@"JsonData"][@"advList"];
                                        if (adverArray.count!=0) {
//                                            start.adverUrl = [NSString stringWithFormat:@"%@",dict[@"JsonData"][@"advList"][0][@"AdvertisImg"] ];
                                        }
//                                        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",dict[@"JsonData"][@"redModel"][@"url"] ] forKey:@"ShareUrl"];
//                                        start.ShareUrl = [NSString stringWithFormat:@"%@",dict[@"JsonData"][@"redModel"][@"url"] ];
                                        [weakSelf.navigationController pushViewController:start animated:YES];
                                    }//大保健结束
                                }else{
                                    //!F000000
                                    
                                }
                            } fail:^(NSError *error) {
                                //网络错误
                                [HUD hide:YES];
                                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"网络错误，请稍后重试或检查网络" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                                [alertView addAction:sureAction];
                                [self presentViewController:alertView animated:YES completion:nil];
                            }];//alartAction内部请求数据结束
                        }];//alartAction-确定动作结束
                        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action){
                            [weakSelf.session startRunning];
                        }];
                        [sureController addAction:sureAction];
                        [sureController addAction:cancleAction];
                        [weakSelf presentViewController:sureController animated:YES completion:nil];
                    }//判断是否有卡支付结束
                }//@end-AF数据请求成功
            } fail:^(NSError *error) {
                //网络错误
                [HUD hide:YES];
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"网络错误，请稍后重试或检查网络" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                [alertView addAction:sureAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }else{
            //二维码有问题
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"非可识别二维码，请扫描可用二维码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertView addAction:sureAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }else if ([imei rangeOfString:@"#"].location !=NSNotFound){
        //商家“#”
        
        NSArray *array = [imei componentsSeparatedByString:@"#"];//获取其中有用的元素
        Cystr = [NSString stringWithFormat:@"%@",array[1]];
        if ((array.count==3&&((NSString *)array[1]).length==4)) {
            //格式正确
            NSDictionary *mulDic = @{
                                     @"DeviceCode":array[1],
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@ScanCode/ScanQuery",Khttp] success:^(NSDictionary *dict, BOOL success) {
                [HUD hide:YES];
                if ([[dict objectForKey:@"ResultCode"] isEqualToString:@"F000000"]) {
                    //
                    NSDictionary *arr = [NSDictionary dictionary];
                    arr = [dict objectForKey:@"JsonData"];
                    
                    self.scan = [[ScanCode alloc]init];
                    [self.scan mj_setKeyValues:arr];
                    
                    /////////////////////////////////////////
                    UIAlertController *sureController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认支付商家服务"] preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            //(1.需要支付状态,2.扫描成功)
                    if(weakSelf.scan.ScanCodeState == 1){
                        DSScanPayController *payVC           = [[DSScanPayController alloc]init];
//                        payVC.payType =@"#";
                        payVC.hidesBottomBarWhenPushed            = YES;
                                
                        payVC.SerMerChant = weakSelf.scan.DeviceName;
                        payVC.SerProject = weakSelf.scan.ServiceItems;
                        payVC.Jprice = [NSString stringWithFormat:@"￥%@",weakSelf.scan.OriginalAmt];
                        payVC.Xprice = [NSString stringWithFormat:@"￥%@",weakSelf.scan.Amt];
                                
                        payVC.DeviceCode = weakSelf.scan.DeviceCode;
                                
                        payVC.RemainCount = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.RemainCount];
                        payVC.IntegralNum = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.IntegralNum];
                        payVC.CardType = [NSString stringWithFormat:@"%ld",(long)weakSelf.scan.CardType];
                        payVC.CardName = weakSelf.scan.CardName;
                                
                        [weakSelf.navigationController pushViewController:payVC animated:YES];
                    }else{
                        LKAlertView *alartView      = [[LKAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否使用%@来支付洗车服务",dict[@"JsonData"][@"CardName"]] delegate:weakSelf cancelButtonTitle:@"否" otherButtonTitles:@"是"];
                        alartView.tag               = 110;
                        [alartView show];
                    }
                        }];
                        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action){
                            [weakSelf.session stopRunning];
                            [weakSelf.session startRunning];
                        }];
                        [sureController addAction:sureAction];
                        [sureController addAction:cancleAction];
                        [weakSelf presentViewController:sureController animated:YES completion:nil];
                        ////////////////////////////////////////
                }else{
                    //  != F00000
                    //网络错误
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"网络错误，请稍后重试或检查网络" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                    [alertView addAction:sureAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                }//  @end != F00000
            } fail:^(NSError *error) {
                //网络错误
                [HUD hide:YES];
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"网络错误，请稍后重试或检查网络" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                [alertView addAction:sureAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }else{
            //二维码有问题
            [HUD hide:YES];
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"非可识别二维码，请扫描可用二维码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertView addAction:sureAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }else{
        //输入不合规则
        [HUD hide:YES];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"非可识别二维码，请扫描可用二维码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertView addAction:sureAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void)alertView:(LKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 110) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide =YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中";
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        
//        if (buttonIndex == 0) {//否
//            self.tabBarController.selectedIndex=0;
//        }else{
            NSDictionary *mulDic = @{
                                     @"DeviceCode":Cystr,
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            __weak typeof(self) weakSelf = self;
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@ScanCode/MerchantScanCode",Khttp] success:^(NSDictionary *dict, BOOL success) {
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]]){
                    weakSelf.newrc = [[CYModel alloc]initWithDictionary:[dict objectForKey:@"JsonData"] error:nil];
                    DSConsumerDetailController *detaleController    = [[DSConsumerDetailController alloc]init];
                    detaleController.hidesBottomBarWhenPushed       = YES;
//                    detaleController.showType = 2;
//                    detaleController.CYrecord                       = self.newrc;
                    [self.navigationController pushViewController:detaleController animated:YES];
                }
            } fail:^(NSError *error) {
                [weakSelf.view showInfo:@"卡信息获取失败" autoHidden:YES interval:2];
            }];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 模拟扫描二维码成功
-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 150, 100, 30)];
        _nextButton.backgroundColor = [UIColor orangeColor];
        [_nextButton setTitle:@"第二页" forState:(UIControlStateNormal)];
        [_nextButton addTarget:self action:@selector(scanButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextButton;
}

//模拟扫描二维码成功的动作
//-(void)scanButtonAction{
//
//    //付款成功进入第三个
//    //标注toGoString左滑不会返回到该页面
//    self.toGoString = @"";
//
//    //开始获取当前时间
//    NSDate *startWashDate = [NSDate date];
//    //本地化储存开始时间
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:startWashDate forKey:@"startTime"];
//    [defaults synchronize]; //保存变更
//
//    WashController *new = [[WashController alloc]init];
//    [self.navigationController pushViewController:new animated:YES];
//}

//#pragma mark - 手动输入机器码
//-(UIButton*)handWriteButton{
//    if (!_handWriteButton) {
//        _handWriteButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, 150, 30)];
//        _handWriteButton.backgroundColor = [UIColor purpleColor];
//        [_handWriteButton setTitle:@"我要手动输入" forState:(UIControlStateNormal)];
//        [_handWriteButton addTarget:self action:@selector(handButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
//    }
//    return _handWriteButton;
//}

//-(void)handButtonAction{
//
//    self.toGoString = @"1";
//    InputViewController *new = [[InputViewController alloc]init];
//    [self.navigationController pushViewController:new animated:YES];
//}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    NSLog(@"相机扫描页面被释放！");
}



@end
