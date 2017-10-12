//
//  MyCar.m
//  CarWashing
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MyCar.h"

@implementation MyCar

- (instancetype)initWithDictionary:(NSDictionary*)dic {
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (self = [super init]) {
        for (NSString *key in [dic allKeys]) {
            //id类型接收返回值
            id value = dic[key];
            
            //1、处理空类型:防止出现unRecognized selector exception
            if ([value isKindOfClass:[NSNull class]]) {
                [self setValue:nil forKey:key];
            }
            //2、处理对象类型和数组类型
            else if ([value isKindOfClass:[NSArray class]] ||
                     [value isKindOfClass:[NSDictionary class]]) {
                [self setValue:value forKeyPath:key];
            }
            //3、处理非空、非对象数组类型：包括数字，字符串，布尔，全部使用NSString来处理
            else{
                //处理关键字，将关键字转换一下，例如：id
                NSString *rKey = @"";
                if([key isEqualToString:@"id"]){
                    rKey = @"Id";
                }
                if([key isEqualToString:@"description"]){
                    rKey = @"descriptions";
                }
                
                [self setValue:[NSString stringWithFormat:@"%@",value] forKeyPath:rKey];//key
                //                [self setValuesForKeysWithDictionary:nil];
            }
        }
    }
    return self;
}

//+(MyCar *)getInstanceByDic:(NSDictionary *)dic
//{
//    MyCar *new = [[MyCar alloc]init];
//    
//    return new;
//}

#pragma mark 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"setValue--%s",__func__);
}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"setNilValueForKey--%s",__func__);
}

@end
