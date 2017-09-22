//
//  UdStorage.h
//  AlgorithmicTrading
//
//  Created by tenly11 on 17/8/4.
//  Copyright © 2017年 tenly11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdStorage : NSObject
//Storage:存储
// NSUserDefaults 存储数据   获取数据
+(void)storageObject:(id)object forKey:(NSString*)key;

+(id)getObjectforKey:(NSString*)key;

@end
