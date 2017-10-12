//
//  ShareView.m
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "ShareView.h"
#import "UIView+TYAlertView.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "HTTPDefine.h"
#import "UdStorage.h"
#import "Record.h"
#import "AppDelegate.h"
#import "CoreLocation/CoreLocation.h"
#import "MBProgressHUD.h"

@implementation ShareView



- (IBAction)cancleAction:(id)sender {
    // hide view,or dismiss controller
    [self hideView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

- (IBAction)sinaShare
{
    __weak ShareView *theController = self;
    [self showLoadingView:YES];
    [self hideView];
//    if (![WeiboSDK isWeiboAppInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未安装微博"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    else
//    {
//        UIImage * result;
    
//        NSString *ImageURL=[NSString stringWithFormat:@"http://pic.biodiscover.com/files/%@",self.imagename];
//        NSString *ImageURL=@"https://cdn.pixabay.com/photo/2013/07/30/09/37/dog-168815_960_720.jpg";
//
//        NSURL *url1=[NSURL URLWithString:ImageURL];
//        
//        NSData * data = [NSData dataWithContentsOfURL:url1];
//        
//        result = [UIImage imageWithData:data];
        
        
        
        
        
//        NSString *content = [NSString stringWithFormat:@"%@#http://%@",self.titlename,self.url];
//        
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        
////        UMShareImageObject *m = [UMShareImageObject shareObjectWithTitle:content descr:self.desc thumImage:[UIImage imageNamed:@"user"]];
////        m.thumbImage = [UIImage imageNamed:@"user"];
//        
//        //分享消息对象设置分享内容对象
//        messageObject.text = content;
//               
//        
//        
//        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//            NSString *message = nil;
//            
//            
//            if (!error) {
//                message = [NSString stringWithFormat:@"分享成功"];
//            } else {
//                 message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
//                
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }];
//
//    }
    
}

- (IBAction)qZoneShare {
    __weak ShareView *theController = self;
    [self showLoadingView:YES];
    [self hideView];
//    //创建分享参数
//    if (![QQApiInterface isQQInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未安装QQ空间"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    
//    else
//    {
//        UIImage * result;
//        
//        NSString *ImageURL=[NSString stringWithFormat:@"http://pic.biodiscover.com/files/%@",self.imagename];
//        NSURL *url1=[NSURL URLWithString:ImageURL];
//        
//        NSData * data = [NSData dataWithContentsOfURL:url1];
//        
//        result = [UIImage imageWithData:data];
//        
//        
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        
//        //创建网页内容对象
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titlename descr:self.desc thumImage:result];
//        //设置网页地址
//        shareObject.webpageUrl =self.url;
//        
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//        
//        
//        
//        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//            NSString *message = nil;
//            
//            
//            if (!error) {
//                message = [NSString stringWithFormat:@"分享成功"];
//            } else {
//                message = [NSString stringWithFormat:@"分享失败"];
//                
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }];
//
//    }
//    
    
   }

- (IBAction)qqShare {

    [self showLoadingView:YES];
    
    //创建分享参数
    [self hideView];
//    //创建分享参数
//    if (![QQApiInterface isQQInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未安装QQ"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    
//    else
//    {
//        UIImage * result;
//        
//        NSString *ImageURL=[NSString stringWithFormat:@"http://pic.biodiscover.com/files/%@",self.imagename];
//        NSURL *url1=[NSURL URLWithString:ImageURL];
//        
//        NSData * data = [NSData dataWithContentsOfURL:url1];
//        
//        result = [UIImage imageWithData:data];
//        
//        
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        
//        //创建网页内容对象
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titlename descr:self.desc thumImage:result];
//        //设置网页地址
//        shareObject.webpageUrl =self.url;
//        
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//        
//        
//        
//        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//            NSString *message = nil;
//            
//            
//            if (!error) {
//                message = [NSString stringWithFormat:@"分享成功"];
//            } else {
//                message = [NSString stringWithFormat:@"分享失败"];
//                
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }];
//        
//    }
//
//
//    
}

- (IBAction)weixinShare {

    __weak ShareView *theController = self;
    [self showLoadingView:YES];
    
//    创建分享参数
    [self hideView];
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text                = @"简单文本分享测试";
    req.bText               = YES;
    // 目标场景
    // 发送到聊天界面  WXSceneSession
    // 发送到朋友圈    WXSceneTimeline
    // 发送到微信收藏  WXSceneFavorite
    req.scene               = WXSceneSession;
    [WXApi sendReq:req];
    
    
//    if (![WXApi isWXAppInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未安装微信"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    else
//    {
//        
//    
//    
//    
//    UIImage * result;
//    
//    NSString *ImageURL=[NSString stringWithFormat:@"http://pic.biodiscover.com/files/%@",self.imagename];
//    NSURL *url1=[NSURL URLWithString:ImageURL];
//    
//    NSData * data = [NSData dataWithContentsOfURL:url1];
//    
//    result = [UIImage imageWithData:data];
//    
//    
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titlename descr:self.desc thumImage:result];
//    //设置网页地址
//    shareObject.webpageUrl =self.url;
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    
//    
//    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        NSString *message = nil;
//        
//        
//        if (!error) {
//            message = [NSString stringWithFormat:@"分享成功"];
//        } else {
//            message = [NSString stringWithFormat:@"分享失败"];
//            
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }];
//
//}
}

- (IBAction)pyqShare {
    __weak ShareView *theController = self;
    [self showLoadingView:YES];
//
    //创建分享参数
    [self hideView];
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text                = @"简单文本分享测试";
    req.bText               = YES;
    // 目标场景
    // 发送到聊天界面  WXSceneSession
    // 发送到朋友圈    WXSceneTimeline
    // 发送到微信收藏  WXSceneFavorite
    req.scene               = WXSceneTimeline;
    [WXApi sendReq:req];
    
    
    
//    //创建分享参数
//    if (![WXApi isWXAppInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未安装微信"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    else
//    {
//        
//        UIImage * result;
//        
//        NSString *ImageURL=[NSString stringWithFormat:@"http://pic.biodiscover.com/files/%@",self.imagename];
//        NSURL *url1=[NSURL URLWithString:ImageURL];
//        
//        NSData * data = [NSData dataWithContentsOfURL:url1];
//        
//        result = [UIImage imageWithData:data];
//        
//        
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        
//        //创建网页内容对象
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titlename descr:self.desc thumImage:result];
//        //设置网页地址
//        shareObject.webpageUrl =self.url;
//        
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//        
//        
//        
//        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//            NSString *message = nil;
//            
//            
//            if (!error) {
//                message = [NSString stringWithFormat:@"分享成功"];
//            } else {
//                message = [NSString stringWithFormat:@"分享失败"];
//                
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }];
//    }
    
}






@end
