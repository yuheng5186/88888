//
//  Order.m
//  CarWashing
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "Order.h"

@implementation Order
//如果不想每一条属性都添加，我们也可以在.m文件中重写方法
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end
