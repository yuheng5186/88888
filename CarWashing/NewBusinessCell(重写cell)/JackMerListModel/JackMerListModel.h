//
//  JackMerListModel.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/12/29.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JackMerListModel : NSObject
@property(copy,nonatomic)NSString * Area;
@property(copy,nonatomic)NSString * City;
@property(copy,nonatomic)NSString * Img;
@property(copy,nonatomic)NSString * MerAddress;
@property(copy,nonatomic)NSString * MerFlag;
@property(copy,nonatomic)NSString * MerName;
@property(copy,nonatomic)NSString * MerPhone;
@property(copy,nonatomic)NSString * ServiceTime;
@property(copy,nonatomic)NSString * StoreProfile;   //商家简介
@property(assign)NSInteger Iscert;              //是否为V认证
@property(assign)NSInteger MerCode;             //商家编号
@property(assign)NSInteger ServiceCount;
@property(assign)NSInteger ShopType;            //三种类型
@property(assign)double Distance;
@property(assign)double Score;
@property(assign)double Xm;
@property(assign)double Ym
;
@end
