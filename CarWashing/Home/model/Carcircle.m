//
//  Carcircle.m
//  CarWashing
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "Carcircle.h"

@implementation Carcircle

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

+(Carcircle *)getInstanceByDic:(NSDictionary *)dic
{
    
    Carcircle *cc = [[Carcircle alloc]init];
    
    
    
    if (dic.count == 0) {
        NSLog(@"无法解析为model属性，因为该字典为空");
        return nil;
    }
    
    
    NSMutableString *strM = [NSMutableString string];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *className = NSStringFromClass([obj class]) ;
        NSLog(@"className:%@/n", className);
        if ([className isEqualToString:@"__NSCFString"] | [className isEqualToString:@"__NSCFConstantString"] | [className isEqualToString:@"NSTaggedPointerString"]) {
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFArray"] |
                  [className isEqualToString:@"__NSArray0"] |
                  [className isEqualToString:@"__NSArrayI"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSArray *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFDictionary"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSDictionary *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFNumber"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSNumber *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFBoolean"]){
            [strM appendFormat:@"@property (nonatomic, assign) BOOL   %@;\n",key];
        }else if ([className isEqualToString:@"NSDecimalNumber"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\n",[NSString stringWithFormat:@"%@",key]];
        }
        else if ([className isEqualToString:@"NSNull"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\n",[NSString stringWithFormat:@"%@",key]];
        }else if ([className isEqualToString:@"__NSArrayM"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSMutableArray *%@;\n",[NSString stringWithFormat:@"%@",key]];
        }
        
    }];
    NSLog(@"\n%@\n",strM);
    
    return cc;
}

@end
