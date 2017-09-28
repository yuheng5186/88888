//
//  AFNetworkingTool+GetToken.h
//  AlgorithmicTrading
//
//  Created by 陈专念 on 2017/5/8.
//  Copyright © 2017年 tenly11. All rights reserved.
//

#import "AFNetworkingTool.h"

@interface AFNetworkingTool (GetToken)
+ (void)getTokenRequestSuccess:(void(^)(NSString *token))success;
@end
