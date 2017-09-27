//
//  DSActivityModel.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/9.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSActivityModel.h"

@implementation DSActivityModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    
    DSActivityModel * model = [[self alloc] init];
    
    //KVC字典转模型
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    // 这里对没有定义的键值对不进行任何操作
    
}

@end
