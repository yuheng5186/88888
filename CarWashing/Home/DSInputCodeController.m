//
//  DSInputCodeController.m
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/8/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSInputCodeController.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "AFNetworkingTool.h"
#import "ScanCode.h"
#import "LCMD5Tool.h"
#import "DSScanPayController.h"

#import "DSScanPayController.h"

#import "HTTPDefine.h"
#import "DSStartWashingController.h"
@interface DSInputCodeController ()

{
    //输入控件
    TFGridInputView *_inputView;
    UIButton *_textGetButton;
    

        MBProgressHUD *HUD;
        
}

@property (nonatomic, strong) UIButton * flashlightButton;
@property (nonatomic, strong) UILabel * flashlightLabel;
@property (nonatomic, strong) ScanCode *scan;
@end

@implementation DSInputCodeController

- (void) drawNavigation {

    [self drawTitle:@"编号开锁"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubView];
}

- (void) createSubView {
    self.contentView.backgroundColor   = [UIColor whiteColor];

    //使用默认大小会拉大高宽，虽然设置100，但实际是6*40+(6+1)*8 = 296，参考布局规则
    _inputView = [[TFGridInputView alloc] initWithFrame:CGRectMake(Main_Screen_Width*10/375, Main_Screen_Height*120/667, 35, 35) row:1 column:8];
    
    _inputView.keyboardType = UIKeyboardTypeNumberPad;
    //构建一个样式，并调整各种格式
    TFGridInputViewCellStyle *style = [[TFGridInputViewCellStyle alloc] init];
    style.backColor = [UIColor whiteColor];
    style.textColor = [UIColor blackColor];
    style.font      = [UIFont systemFontOfSize:18];
    [_inputView setStyle:style forState:(TFGridInputViewCellStateEmpty)];
    
    _inputView.DIVBorderColor = [UIColor colorFromHex:@"#0161a1"];
    _inputView.DIVBorderWidth = 0.5;
    
    
    [self.view addSubview:_inputView];
    
    NSString  *inpotString       = @"确认您输入的洗车机编码正确?";
    UIFont    *inputStringFont   = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
    UILabel   *inputLabel             = [UIUtil drawLabelInView:self.view frame:[UIUtil textRect:inpotString font:inputStringFont]font:inputStringFont text:inpotString isCenter:NO];
    inputLabel.textColor   = [UIColor colorFromHex:@"#b4b4b4"];
    inputLabel.top         = _inputView.bottom +Main_Screen_Height*40/667;
    inputLabel.centerX     = Main_Screen_Width/2;
    
    
    UIButton    *washingButton  = [UIUtil drawDefaultButton:self.view title:@"立即洗车" target:self action:@selector(getInputViewText)];
    washingButton.width         = Main_Screen_Width*280/375;
    washingButton.layer.cornerRadius    = washingButton.height/2;
    washingButton.top           = inputLabel.bottom +Main_Screen_Height*40/667;
    washingButton.centerX       = Main_Screen_Width/2;
    
    
    self.flashlightButton     = [UIUtil drawButtonInView:self.view frame:CGRectMake(0, 0, Main_Screen_Width*100/375, Main_Screen_Height*50/667) iconName:@"qw_shoudiantong" target:self action:@selector(flashlightButtonButtonClcik:)];
    self.flashlightButton.top = washingButton.bottom +Main_Screen_Height*30/667;
    self.flashlightButton.centerX   = Main_Screen_Width/2;;
    
    NSString  *openString           = @"手电筒";
    UIFont    *openStringFont       = [UIFont systemFontOfSize:Main_Screen_Height*12/667];
    self.flashlightLabel            = [UIUtil drawLabelInView:self.view frame:CGRectMake(0, 0, Main_Screen_Width*150/375, Main_Screen_Height*20/667) font:openStringFont text:openString isCenter:NO];
    self.flashlightLabel.textColor  = [UIColor colorFromHex:@"#999999"];
    self.flashlightLabel.top        = self.flashlightButton.bottom;
    self.flashlightLabel.textAlignment  = NSTextAlignmentCenter;
    self.flashlightLabel.centerX    = Main_Screen_Width/2;
    
    
    
    
}

- (void) flashlightButtonButtonClcik:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"kaishoudiantong"] forState:UIControlStateSelected];
        self.flashlightLabel.text  = @"手电筒";
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
        [sender setImage:[UIImage imageNamed:@"qw_shoudiantong"] forState:UIControlStateSelected];
        self.flashlightLabel.text  = @"手电筒";
        //关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
#pragma mark-编号开锁
-(void)getInputViewText{
    
//    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
//    NSString    *stringTime     = [defaults objectForKey:@"setTime"];
//    
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *overdate = [dateFormatter dateFromString:stringTime];
//    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
//    NSInteger interva1 = [zone1 secondsFromGMTForDate: overdate];
//    NSDate*endDate = [overdate dateByAddingTimeInterval: interva1];
//    
//    //获取当前时间
//    NSDate*date = [NSDate date];
//    NSTimeZone*zone2 = [NSTimeZone systemTimeZone];
//    NSInteger interva2 = [zone2 secondsFromGMTForDate: date];
//    NSDate *currentDate = [date dateByAddingTimeInterval: interva2];
//    
//    NSInteger intString;
//    NSTimeInterval interval =[endDate timeIntervalSinceDate:currentDate];
//    NSInteger gotime = round(interval);
//    NSString *str2 = [[NSString stringWithFormat:@"%ld",(long)gotime] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    intString = [str2 intValue];
//    
//    if (intString > 0 && intString < 240) {
//        
//        DSStartWashingController *start = [[DSStartWashingController alloc]init];
//        start.paynum=[UdStorage getObjectforKey:@"Jprice"];
//        start.RemainCount = [UdStorage getObjectforKey:@"RemainCount"];
//        start.IntegralNum = [UdStorage getObjectforKey:@"IntegralNum"];
//        start.CardType = [UdStorage getObjectforKey:@"CardType"];
//        start.CardName =[UdStorage getObjectforKey:@"CardName"];
//        start.hidesBottomBarWhenPushed            = YES;
//        start.second                    = 240-intString;
//        
//        [self.navigationController pushViewController:start animated:YES];
//        
//    }else {
//        self.tabBarController.selectedIndex = 2;
//        //
//        //
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//    }
    
    
    
    [_textGetButton setTitle:_inputView.text forState:(UIControlStateNormal)];
#pragma mark-获取设备编码
   
    if (_inputView.text != nil) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide =YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中";
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        
        NSDictionary *mulDic = @{
                                 @"DeviceCode":_inputView.text,
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
                        
                        payVC.RemainCount = [NSString stringWithFormat:@"%ld",weakSelf.scan.RemainCount];
                        payVC.IntegralNum = [NSString stringWithFormat:@"%ld",weakSelf.scan.IntegralNum];
                        payVC.CardType = [NSString stringWithFormat:@"%ld",weakSelf.scan.CardType];
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
                        
                        start.RemainCount = [NSString stringWithFormat:@"%ld",weakSelf.scan.RemainCount];
                        start.IntegralNum = [NSString stringWithFormat:@"%ld",weakSelf.scan.IntegralNum];
                        start.CardType = [NSString stringWithFormat:@"%ld",weakSelf.scan.CardType];
                        start.CardName = weakSelf.scan.CardName;
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
        
          
    }
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
