//
//  DSScanController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSScanController.h"
#import "DSExchangeController.h"
#import "PopHelpView.h"
#import "LewPopupViewAnimationDrop.h"

#import "DSInputCodeController.h"

#import "DSScanPayController.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "ScanCode.h"

#import "DSStartWashingController.h"


@interface DSScanController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    MBProgressHUD *HUD;
    
}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak)   UIView *maskView;
@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetImageView;
@property (nonatomic, strong) UIButton * flashlight;
@property (nonatomic, strong) UILabel * flashlightSwitch;

@property (nonatomic, strong) UIButton * inputButton;
@property (nonatomic, strong) UILabel * inputLabel;

@property (nonatomic, strong) ScanCode *scan;


@end

@implementation DSScanController



- (void) helpButtonClick:(id)sender {
    
    PopHelpView *view = [PopHelpView defaultPopHelpView:@"一键扫码，快速开启"];
    view.parentVC = self;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
        
    }];
}
- (void) drawContent {

    self.statusView.hidden      = YES;
    self.navigationView.hidden  = YES;
    self.contentView.top        = 0;
    self.contentView.height     = self.view.height;
}
#pragma mark-菜单栏扫码洗车
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;

    UIView *titleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, 64) color:[UIColor colorFromHex:@"#febb02"]];
    titleView.top                      = 0;
    
    UIImageView *imageView  = [[UIImageView alloc]initWithFrame:titleView.frame];
    imageView.image     = [UIImage imageNamed:@"ijanbiantiao"];
    [titleView addSubview:imageView];
    
    
    NSString *titleName              = @"扫码洗车";
    UIFont *titleNameFont            = [UIFont boldSystemFontOfSize:18];
    UILabel *titleNameLabel          = [UIUtil drawLabelInView:titleView frame:[UIUtil textRect:titleName font:titleNameFont] font:titleNameFont text:titleName isCenter:NO];
    titleNameLabel.textColor         = [UIColor whiteColor];
    titleNameLabel.centerX           = titleView.centerX;
    titleNameLabel.centerY           = titleView.centerY +8;
    
    NSString  *helpString     = @"使用帮助";
    UIFont    *helpStringFont = [UIFont systemFontOfSize:Main_Screen_Width*14/375];
    UIButton   *helpButton      = [UIUtil drawButtonInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*80/375, Main_Screen_Height*20/667) text:helpString font:helpStringFont color:[UIColor whiteColor] target:self action:@selector(helpButtonClick:)];
    helpButton.tintColor = [UIColor whiteColor];
    helpButton.centerY   = titleNameLabel.centerY;
    helpButton.right     = Main_Screen_Width -Main_Screen_Width*10/375;
    
    
    //1.扫描区域
    [self setupScanWindowView];
    //2.开始动画
    [self beginScanning];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:@"EnterForeground" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{

    
    /// 先判断摄像头硬件是否好用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        /// 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        /// 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"您已经禁止金顶洗车访问摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:nil];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                self.tabBarController.selectedIndex = 0;

            }];
            [alertC addAction:action];
        }else{
            ////这里是摄像头可以使用的处理逻辑
            [self resumeAnimation];
            [_session startRunning];
        }
    } else {
        /// 硬件问题提示
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机摄像头设备损坏" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_session stopRunning];
}

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

- (void)beginScanning
{
    //获取摄像设备
    //    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
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

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
//        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSString *qaMessage = metadataObject.stringValue;
        
        [self handleScanData:qaMessage];
        
    }
}

- (void)handleScanData:(NSString *)outMessage {
    
    #pragma mark-获取设备编码
    NSString *imei                          = outMessage;
    //处理设备编码
    NSArray *array = [imei componentsSeparatedByString:@":"]; //从字符：中分隔成2个元素的数组
    
    if (array.count==3&&((NSString *)array[1]).length==8) {
        
        [_session stopRunning];

        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide =YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中";
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        
        NSDictionary *mulDic = @{
                                 @"DeviceCode":array[1],
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
         NSLog(@"====%@====",params);
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@ScanCode/DeviceScanCode",Khttp] success:^(NSDictionary *dict, BOOL success) {
            NSLog(@"%@",dict);
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                [_session stopRunning];

                
                NSDictionary *arr = [NSDictionary dictionary];
                arr = [dict objectForKey:@"JsonData"];
                
                self.scan = [[ScanCode alloc]init];
                [self.scan setValuesForKeysWithDictionary:arr];
                    

                __weak typeof(self) weakSelf = self;
                HUD.completionBlock = ^(){
                    //(1.需要支付状态,2.扫描成功)
                    if(weakSelf.scan.ScanCodeState == 1)
                    {
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
                    }
                    else
                    {
                        
                        
                        
                        NSDate*date                     = [NSDate date];
                        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        
                        
                        NSString *dateString        = [dateFormatter stringFromDate:date];
                        NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:dateString forKey:@"setTime"];
                        [defaults synchronize];
                        NSLog(@"setTime ==== %@",[defaults objectForKey:@"setTime"]);
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
                        
                        [weakSelf.navigationController pushViewController:start animated:YES];
                        
                        
                        
                        
                    }
                };
                
                [HUD hide:YES afterDelay:1.f];
            }
            else
            {
                [HUD hide:YES];
                [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];
//                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError *error) {
            NSLog(@"%@",error);
            [HUD hide:YES];
            [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
//            [self.navigationController popViewControllerAnimated:YES];
            
        }];

        
        
        
        
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"扫码错误" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //1.扫描区域
//            [self setupScanWindowView];
//            //2.开始动画
//            [self beginScanning];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:@"EnterForeground" object:nil];
            
            
        }];
        [alertController addAction:OKAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    
    }
}

#pragma mark 恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
        
    }else{
        
        CGFloat scanNetImageViewH = 241*Main_Screen_Height/667;
        CGFloat scanWindowH = _scanWindow.width;
        CGFloat scanNetImageViewW = _scanWindow.width;
        
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 3.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
        _scanWindow.layer.masksToBounds = YES;
    }
}
#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
