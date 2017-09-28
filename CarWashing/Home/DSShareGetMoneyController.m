//
//  DSShareGetMoneyController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/10.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSShareGetMoneyController.h"
#import "WeixinSessionActivity.h"
#import "WeixinTimelineActivity.h"
#import "HYActivityView.h"
#import "ShareView.h"
#import "UIView+TYAlertView.h"
#import "TYAlertController+BlurEffects.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "UdStorage.h"
#import "AFNetworkingTool.h"

#import "ShareWeChatController.h"

@interface DSShareGetMoneyController ()
{
    
    NSString *title;
    UIImage *image;
    NSURL *url;
    enum WXScene scene;
    
    NSArray *activity;
}
@property (nonatomic, strong) HYActivityView *activityView;

@end

@implementation DSShareGetMoneyController

- (void) drawNavigation {

    [self drawTitle:@"分享赚钱"];
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
    
    activity = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];

}

- (void) createSubView {
    
//    UIView *titleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*375/667) color:[UIColor colorFromHex:@"#f6f6f6"]];
//    titleView.top                      = Main_Screen_Height*64/375;
//    titleView.centerX                  = Main_Screen_Width/2;
    
//    UIImageView *logoImageView  = [UIUtil drawCustomImgViewInView:titleView frame:CGRectMake(0, 0, Main_Screen_Width*40/375, Main_Screen_Height*40/667) imageName:@"WechatIMG3"];
//    logoImageView.top           = Main_Screen_Height*23/667;
//    logoImageView.centerX       = titleView.size.width/2;
    
//    NSString   *titleString     = @"推荐得“洗车卡”";
//    
//    UIFont     *titleFont       = [UIFont boldSystemFontOfSize:25*Main_Screen_Height/667];
//    UILabel *titleLabel         = [UIUtil drawLabelInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width*300/375, Main_Screen_Height*60/667) font:titleFont text:titleString isCenter:NO];
//    titleLabel.text             = titleString;
//    titleLabel.textColor        = [UIColor colorFromHex:@"#545454"];
//    titleLabel.textAlignment    = NSTextAlignmentCenter;
//    titleLabel.centerX          = self.contentView.centerX;
//    titleLabel.top              = Main_Screen_Height*100/667;
//    
//    
//    NSString *showString              = @"邀请新人完成注册，即可获得价值99元洗车卡";
//    UIFont *showStringFont            = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
//    UILabel *showLabel          = [UIUtil drawLabelInView:self.contentView frame:[UIUtil textRect:showString font:showStringFont] font:showStringFont text:showString isCenter:NO];
//    showLabel.textColor         = [UIColor colorFromHex:@"#4a4a4a"];
//    showLabel.textAlignment     = NSTextAlignmentCenter;
//    showLabel.top               = titleLabel.bottom +Main_Screen_Height*14/667;
//    showLabel.centerX           = titleLabel.centerX;
    
    UIImageView *bigImageView   = [UIUtil drawCustomImgViewInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64) imageName:@"fenxiangzhuanqian"];
    bigImageView.top            = self.navigationView.bottom;
    bigImageView.centerX        = self.contentView.centerX;
    
//    UIButton    *getMoneyButton = [UIUtil drawDefaultButton:self.contentView title:@"立即邀请，新人可获得99元洗车卡" target:self action:@selector(getMoneyButtonClick:)];
//    NSString *string   = @"立即邀请，新人可获得99元洗车卡";
    UIFont  *stringFont = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    UIButton    *getMoneyButton = [UIUtil drawButtonInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width -Main_Screen_Width*60/375, Main_Screen_Height*40/667) text:@"邀请好友，一起获得免费洗车卡" font:stringFont color:[UIColor whiteColor] target:self action:@selector(getMoneyButtonClick:)];
    getMoneyButton.backgroundColor  = [UIColor colorFromHex:@"#0161a1"];
//    [getMoneyButton setBackgroundImage:[UIImage imageNamed:@"yaoqinganniu"] forState:UIControlStateNormal];
    getMoneyButton.layer.cornerRadius   = 5*Main_Screen_Height/667;
    getMoneyButton.bottom          = Main_Screen_Height -Main_Screen_Height*95/667;
    getMoneyButton.centerX      = self.contentView.centerX;
//    getMoneyButton.width        = Main_Screen_Width - Main_Screen_Width*40/375;
    
}

- (void) getMoneyButtonClick:(id)sender {
    
//    ShareWeChatController *shareVC = [[ShareWeChatController alloc] init];
//    
//    shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:shareVC animated:NO completion:nil];
    
    
    
//    ShareView *shareView = [ShareView createViewFromNib];
//    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
//    
//    [alertController setBlurEffectWithView:self.view];
//    alertController.alertView.width     = Main_Screen_Width;
//    alertController.alertView.height    = Main_Screen_Height*230/667;
//    if (Main_Screen_Height == 568) {
        //alertController.alertViewOriginY    = self.contentView.height- alertController.alertView.height;
//
//    }else if(Main_Screen_Height == 667){
//        alertController.alertViewOriginY    = self.contentView.height- Main_Screen_Height*180/667;
//
//        
//    }else if(Main_Screen_Height == 736){
//        alertController.alertViewOriginY    = self.contentView.height- Main_Screen_Height*160/667;
//
//    }else{
//        
//    }
    //[alertController setBlurEffectWithView:(UIView *)view style:(BlurEffectStyle)blurStyle];
    //[self presentViewController:alertController animated:YES completion:nil];

//        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[@"这里是标题", [UIImage imageNamed:@"zensong"], [NSURL URLWithString:@"http://www.google.com"]] applicationActivities:activity];
//        activityView.excludedActivityTypes = @[UIActivityTypeAirDrop];
//        [self presentViewController:activityView animated:YES completion:nil];
    
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        ButtonView *bv ;
        
        bv = [[ButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"btn_share_weixin"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信");
            NSDictionary *mulDic = @{
                                     @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                     @"ShareType":@2
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
                    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
                    
                    //创建分享内容对象
                    WXMediaMessage *urlMessage = [WXMediaMessage message];
                    urlMessage.title = [[dict objectForKey:@"JsonData"] objectForKey:@"ShareTitle"];;//分享标题
                    urlMessage.description =[[dict objectForKey:@"JsonData"] objectForKey:@"ShareContent"];;//分享描述
                    [urlMessage setThumbImage:[UIImage imageNamed:@"loginIcon"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
                    
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
                                     @"ShareType":@2
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
                    [urlMessage setThumbImage:[UIImage imageNamed:@"loginIcon"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
                    
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

- (void)setThumbImage:(SendMessageToWXReq *)req
{
    if (image) {
        CGFloat width = 100.0f*Main_Screen_Height/667;
        CGFloat height = image.size.height * 100.0f*Main_Screen_Height/667 / image.size.width;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [req.message setThumbImage:scaledImage];
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
