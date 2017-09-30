//
//  DSDownloadController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/10.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSDownloadController.h"
#import "HYActivityView.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "UdStorage.h"
#import "AFNetworkingTool.h"

@interface DSDownloadController ()<LKAlertViewDelegate>

{
    enum WXScene scene;
    
}
@property (nonatomic, strong) HYActivityView *activityView;
@property (nonatomic, strong) UIImageView *bigImageView;
@end

@implementation DSDownloadController

- (void) drawNavigation {

    [self drawTitle:@"下载金顶洗车"];
    [self drawRightImageButton:@"fenxiang" action:@selector(shareButtonClick:)];
}

- (void) shareButtonClick:(id)sender {

    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        ButtonView *bv ;
        
        bv = [[ButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"btn_share_weixin"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信");
            NSDictionary *mulDic = @{
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                     @"ShareType":@3
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@InviteShare/UserShare",Khttp] success:^(NSDictionary *dict, BOOL success) {
                
                NSLog(@"%@",dict);
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {
                    //创建发送对象实例
                    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
                    sendReq.bText = NO;//不使用文本信息
                    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
                    
                    //创建分享内容对象
                    WXMediaMessage *urlMessage = [WXMediaMessage message];
                    urlMessage.title = [[dict objectForKey:@"JsonData"] objectForKey:@"ShareTitle"];;//分享标题
                    urlMessage.description =[[dict objectForKey:@"JsonData"] objectForKey:@"ShareContent"];;//分享描述
                    [urlMessage setThumbImage:[UIImage imageNamed:@"AppIcon"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
                    
                    //创建多媒体对象
                    WXWebpageObject *webObj = [WXWebpageObject object];
                    webObj.webpageUrl = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"JsonData"] objectForKey:@"InviteShareUrl"]];//分享链接
                    
                    //完成发送对象实例
                    urlMessage.mediaObject = webObj;
                    sendReq.message = urlMessage;
                    
                    //发送分享信息
                    [WXApi sendReq:sendReq];
                    
                }
                else
                {
                    [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                    
                }
                
            } fail:^(NSError *error) {
                [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                
            }];

            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"btn_share_pengyouquan"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
            NSDictionary *mulDic = @{
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                     @"ShareType":@3
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@InviteShare/UserShare",Khttp] success:^(NSDictionary *dict, BOOL success) {
                
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {
                    //创建发送对象实例
                    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
                    sendReq.bText = NO;//不使用文本信息
                    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
                    
                    //创建分享内容对象
                    WXMediaMessage *urlMessage = [WXMediaMessage message];
                    urlMessage.title = [[dict objectForKey:@"JsonData"] objectForKey:@"ShareTitle"];;//分享标题
                    urlMessage.description =[[dict objectForKey:@"JsonData"] objectForKey:@"ShareContent"];;//分享描述
                    [urlMessage setThumbImage:[UIImage imageNamed:@"AppIcon"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
                    
                    //创建多媒体对象
                    WXWebpageObject *webObj = [WXWebpageObject object];
                    webObj.webpageUrl = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"JsonData"] objectForKey:@"InviteShareUrl"]];//分享链接
                    
                    //完成发送对象实例
                    urlMessage.mediaObject = webObj;
                    sendReq.message = urlMessage;
                    
                    //发送分享信息
                    [WXApi sendReq:sendReq];
                    
                }
                else
                {
                    [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                    
                }
                
            } fail:^(NSError *error) {
                [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                
            }];

            
        }];
        [self.activityView addButtonView:bv];
        
    }
    
    [self.activityView show];
}

- (void) drawContent {

    self.contentView.top                = 0;
    self.contentView.height             = self.view.height;
    self.contentView.backgroundColor    = [UIColor colorFromHex:@"#f6f6f6"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubView];
}

- (void) createSubView {

    UIView *titleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*300/375, Main_Screen_Height*375/667) color:[UIColor whiteColor]];
    titleView.top                      = Main_Screen_Height*64/375;
    titleView.centerX                  = Main_Screen_Width/2;
    
    UIImageView *logoImageView  = [UIUtil drawCustomImgViewInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*60/375, Main_Screen_Height*60/667) imageName:@"denglu_icon"];
    logoImageView.top           = Main_Screen_Height*23/667;
    logoImageView.centerX       = titleView.size.width/2;
    
    NSString   *titleString     = @"金顶洗车";

    UIFont     *titleFont       = [UIFont boldSystemFontOfSize:15];
    UILabel *titleLabel         = [UIUtil drawLabelInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*150/375, Main_Screen_Height*30/667) font:titleFont text:titleString isCenter:NO];
    titleLabel.text             = titleString;
    titleLabel.textColor        = [UIColor colorFromHex:@"#4a4a4a"];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.centerX          = logoImageView.centerX;
    titleLabel.top              = logoImageView.bottom +Main_Screen_Height*12/667;
    
    self.bigImageView   = [UIUtil drawCustomImgViewInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*160/375, Main_Screen_Height*160/667) imageName:@"jindingerweima"];
    self.bigImageView.top            = titleLabel.bottom +Main_Screen_Height*28/667;
    self.bigImageView.centerX        = titleView.size.width/2;
    self.bigImageView.userInteractionEnabled    = YES;
    
    UILongPressGestureRecognizer  *tapNewGesture    = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapbigImageViewGesture:)];
    tapNewGesture.minimumPressDuration              = 1.0;
    [self.bigImageView addGestureRecognizer:tapNewGesture];
    
    NSString *showString              = @"长按识别二维码,下载金顶洗车APP";
    UIFont *showStringFont            = [UIFont systemFontOfSize:14];
    UILabel *showLabel          = [UIUtil drawLabelInView:titleView frame:[UIUtil textRect:showString font:showStringFont] font:showStringFont text:showString isCenter:NO];
    showLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
    showLabel.top               = self.bigImageView.bottom +Main_Screen_Height*22/667;
    showLabel.centerX           = self.bigImageView.centerX;
    
}
- (void) tapbigImageViewGesture:(UILongPressGestureRecognizer *)gesture {

    if ([gesture state] == UIGestureRecognizerStateBegan) {
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
        
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(self.bigImageView.image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            //通过对话框的形式呈现
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果"
//                                                            message:scannedResult
//                                                           delegate:self
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"确定", nil];
//            [self.view addSubview:alert];
//            [alert show];
            
            LKAlertView *alartView      = [[LKAlertView alloc]initWithTitle:nil message:@"将跳转到苹果App Store" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
            [alartView show];
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果"
                                                            message:@"不是二维码图片"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [self.view addSubview:alert];
            [alert show];
        }
    }
    //获取选中的照片
//    UIImage *image = info[UIImagePickerControllerEditedImage];
    
//    if (!image) {
//        image = info[UIImagePickerControllerOriginalImage];
//    }
    //初始化  将类型设置为二维码
    
    
}

#pragma mark ---LKAlertViewDelegate---
- (void)alertView:(LKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        
    }else{
        
        NSString * str = @"http://120.78.48.105/appshow/appdown.html";
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
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
