//
//  Carcircle.h
//  CarWashing
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Carcircle : NSObject

@property (copy, nonatomic)NSString *userName;
@property (copy, nonatomic)NSString *Accountname;


@property (copy, nonatomic)NSString *userImagePath;
@property (copy, nonatomic)NSString *userPhone;
//@property (copy, nonatomic)NSString *userPassword;
@property (copy, nonatomic)NSString *userSex;
@property (copy, nonatomic)NSString *userAge;
//@property (copy, nonatomic)NSString *token;
//@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSString *userhobby;
@property (copy, nonatomic)NSString *usermemo;
@property (copy, nonatomic)NSString *useroccupation;

- (instancetype)initWithDictionary:(NSDictionary*)dic;

+(Carcircle *)getInstanceByDic:(NSDictionary *)dic;

@end
