//
//  AFNetworkingTool.h
//  AlgorithmicTrading
//
//  Created by tenly11 on 16/12/21.
//  Copyright © 2016年 tenly11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^SuccessImageBlock)(UIImage *images, BOOL success); // 访问成功block

typedef void (^AFNErrorBlock)(NSError *error); // 访问失败block
@interface AFNetworkingTool : NSObject
#pragma mark - 创建请求者
+(AFHTTPSessionManager *)manager;


#pragma mark - GET请求
+ (void)getUserCarShopAndSalesDataForSalesWithUserId:(NSString *)userId date:(NSString *)date selectAreaType:(NSString *)areaType andurl:(NSString *)url Success:(SuccessBlock)success fail:(AFNErrorBlock)fail;
#pragma mark - POST请求
+ (void)loginWithUserAccount:(NSDictionary *)param andurl:(NSString *)url success:(SuccessBlock)success  fail:(AFNErrorBlock)fail;
+ (void)loginWithUserImageAccount:(NSDictionary *)param andurl:(NSString *)url success:(SuccessImageBlock)success  fail:(AFNErrorBlock)fail;
+ (void)post:(NSDictionary *)param andurl:(NSString *)url success:(SuccessBlock)success  fail:(AFNErrorBlock)fail;

#pragma mark - 下载
- (void)downLoadWithUrlString:(NSString *)urlString;
#pragma mark - 上传
- (void)uploadWithUser:(NSString *)userId UrlString:(NSString *)urlString upImg:(UIImage *)upImg;
#pragma mark-网络监听
- (void)AFNetworkStatus;
#pragma mark - GETyou参数请求
+ (void)getUserCarShopAndSalesDataForSalesWithDictionaryParam:(NSDictionary *)param andurl:(NSString *)url Success:(SuccessBlock)success fail:(AFNErrorBlock)fail;
#pragma mark - POST请求token
+ (void)loginWithUserAccountTWO:(NSDictionary *)param andurl:(NSString *)url success:(SuccessBlock)success  fail:(AFNErrorBlock)fail;
#pragma mark - GETyou参数请求token
+ (void)getUserCarShopAndSalesDataForSalesWithDictionaryTwoParam:(NSDictionary *)param andurl:(NSString *)url Success:(SuccessBlock)success fail:(AFNErrorBlock)fail;
#pragma mark - 字典转字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;

+(NSString *)base64convertToJsonData:(NSDictionary *)dict;

@end
