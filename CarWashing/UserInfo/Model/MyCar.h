//
//  MyCar.h
//  CarWashing
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCar : NSObject

@property (copy, nonatomic)NSString *Account_Id;
@property (copy, nonatomic)NSString *CarBrand;//车辆品牌
@property (copy, nonatomic)NSString *CarType;//车系
@property NSInteger CarCode;
@property (copy, nonatomic)NSString *ChassisNum;//车架号
@property NSInteger IsDefaultFav;//是否默认
@property NSInteger Manufacture;//生产年份
@property (copy, nonatomic)NSString *PlateNumber;//车牌号
@property (copy, nonatomic)NSString *DepartureTime;//上路时间
@property (copy, nonatomic)NSString *EngineNum;//发动机编号
@property (copy, nonatomic)NSString *Img;//车辆图片
@property (copy, nonatomic)NSString *Province;//车辆图片
@property (nonatomic)NSInteger Mileage;//行驶里程
@property (nonatomic)NSInteger ModifyType;

- (instancetype)initWithDictionary:(NSDictionary*)dic;
//+(MyCar *)getInstanceByDic:(NSDictionary *)dic;

@end
