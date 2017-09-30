//
//  DSAdDetailController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSAdDetailController.h"
#import "HYActivityView.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "UdStorage.h"
#import "AFNetworkingTool.h"
@interface DSAdDetailController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    enum WXScene scene;
    
}
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation DSAdDetailController

- (void)drawNavigation {
    
//    [self drawTitle:@"广告详情"];
    [self drawRightImageButton:@"fenxiang" action:@selector(shareButtonClick:)];
}

- (void) shareButtonClick:(id)sender {
    
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        ButtonView *bv ;
//        活动类型1将参数【2个参数】拼接到Url（活动详情的后面）
//        ,类型2将参数【1个参数】拼接到Url（活动详情的后面）
//        类型 3将参数【一个参数】拼接到InviteUrl(分享链接的后面)
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
                    NSDictionary *dictnew=[dict objectForKey:@"JsonData"];
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
                    webObj.webpageUrl = [NSString stringWithFormat:@"%@",self.shareurlstr];//分享链接
                    
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSMutableString *str = [NSMutableString string];
    // 3.根据标签类型获取指定标签的元素
    [str appendString:@"var header = document.getElementsByTagName(\"header\")[0];"];
    [str appendString:@"header.parentNode.removeChild(header);"];// 移除头部的导航栏
    [str appendString:@"var content = document.getElementById('wrap');"];
    [str appendString:@"content.style.paddingTop = '0px';"];
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    
    [self drawTitle: title];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height - 64)];
    webView.opaque = NO;
    webView.delegate = self;
    
    [webView sizeToFit];
    
    [self.view addSubview:webView];
    NSLog(@"%@",self.urlstr);
    NSURL * url                     = [NSURL URLWithString:self.urlstr];
    NSURLRequest* request           = [NSURLRequest requestWithURL: url];
    
    [webView loadRequest:request];
    webView.backgroundColor         = [UIColor clearColor];
    webView.scrollView.contentInset = UIEdgeInsetsMake (0.0f, 0.0f, 80.0f, 0.0f);
    
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
