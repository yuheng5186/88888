//
//  AFNetworkingTool+GetToken.m
//  AlgorithmicTrading
//
//  Created by 陈专念 on 2017/5/8.
//  Copyright © 2017年 tenly11. All rights reserved.
//

#import "AFNetworkingTool+GetToken.h"
#import "loginViewController.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
@implementation AFNetworkingTool (GetToken)
//获取token
//+ (void)getTokenRequestSuccess:(void(^)(NSString *token))success{
//
//    [self AFNetworkingGetDateWithSuccess:^(NSString *token) {
//        if(success){
//            success(token);
//        }
//    }];
//}

//#pragma mark-获取系统时间
//+(void)AFNetworkingGetDateWithSuccess:(void(^)(NSString *token))successBlock{
//    //获取系统时间
//    [AFNetworkingTool loginWithUserAccount:nil andurl:[NSString stringWithFormat:@"%@/Api/Index/servertimeApi",UrlStr] success:^(NSDictionary *dict, BOOL success) {
//        
//        NSString *systemTime=[dict objectForKey:@"time"];
//        // 登陆获取token
//        [self AFNetworkingWithlogintime:systemTime getTokenSuccessBlock:^(NSString *token) {
//            //将获取到的token传给Block
//            if(successBlock){
//                successBlock(token);
//            }
//        }];
//        
//    } fail:^(NSError *error) {
////        [MBProgressHUD showMsg:error.localizedDescription duration:1 imgName:@"failure"];
//    }];
//    
//    
//}

//#pragma mark-获取token
//+ (void)AFNetworkingWithlogintime:(NSString *)logintime getTokenSuccessBlock:(void(^)(NSString *token))successBlock
//{
//    
////    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *phone = [UdStorage getObjectforKey:@"phone"];
//    NSString *password = [UdStorage getObjectforKey:@"password"];
//    
//    NSDictionary *param=@{@"username":phone,@"password":password,@"logintime":logintime};
//    [AFNetworkingTool loginWithUserAccount:param andurl:[NSString stringWithFormat:@"%@/Api/User/loginApi",UrlStr] success:^(NSDictionary *dict, BOOL success) {
//        if ([[dict objectForKey:@"status"] isKindOfClass:[NSString class]]) {
//           
////            [MBProgressHUD showMsg:[dict objectForKey:@"status"] duration:1 imgName:nil];
//        }else{
//        //将获取到得token返回
//        if(successBlock){
//            if ([dict objectForKey:@"token"]==nil) {
////                [MBProgressHUD showMsg:@"账号或者密码失效请退出重新登陆！" duration:1 imgName:nil];
//            }
//            successBlock([dict objectForKey:@"token"]);
//        }
//        }
//    } fail:^(NSError *error) {
////        [MBProgressHUD showMsg:error.localizedDescription duration:1 imgName:@"failure"];
//    }];
//}
@end
