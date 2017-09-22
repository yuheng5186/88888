//
//  User.m
//  ItTest
//
//  Created by administrator on 15/10/9.
//  Copyright (c) 2015年 cw. All rights reserved.
//

#import "User.h"

@implementation User

+(User *)getInstanceByDic:(NSDictionary *)dic
{
    User *u = [[User alloc]init];
    u.Account_Id = [[dic valueForKey:@"Account_Id"] integerValue];
    u.Level_id = [[dic valueForKey:@"Level_id"] integerValue];
    u.UserScore = [[dic valueForKey:@"UserScore"] integerValue];
    
    if([NSNull null] != [dic objectForKey:@"ModifyType"]) {
        u.ModifyType = [[dic objectForKey:@"ModifyType"] integerValue];
    }
    else
    {
        u.ModifyType = 0;
    }
    if([NSNull null] != [dic objectForKey:@"VerCode"]) {
        u.VerCode = [[dic valueForKey:@"VerCode"] integerValue];
    }
    else
    {
        u.VerCode = 0;
    }
    
    if([NSNull null] != [dic objectForKey:@"Name"])
    {
        u.userName = [dic valueForKey:@"Name"];
    }
    else
    {
        
        u.userName = [dic valueForKey:@"Mobile"];
    }
    
    if([NSNull null] != [dic objectForKey:@"UserName"])
    {
        u.Accountname = [dic valueForKey:@"UserName"];
    }
    else
    {
        
        u.Accountname = [dic valueForKey:@"Mobile"];
    }
    
    if([NSNull null] != [dic objectForKey:@"Headimg"])
    {
        u.userImagePath = [dic valueForKey:@"Headimg"];
    }
    else
    {
        
        u.userImagePath = @"";
    }
    
    u.userPhone = [dic valueForKey:@"Mobile"];
    
    if([NSNull null] != [dic objectForKey:@"Sex"])
    {
        u.userSex = [dic valueForKey:@"Sex"];
    }
    else
    {
        
        u.userSex = 0;
    }
    
    if([NSNull null] != [dic objectForKey:@"Age"])
    {
        u.userAge = [dic valueForKey:@"Age"];
    }
    else
    {
        
        u.userAge = 0;
    }
    
    
    if([NSNull null] != [dic objectForKey:@"Hobby"] || [NSNull null] != [dic objectForKey:@"Memo"]||[NSNull null] != [dic objectForKey:@"Occupation"])
    {
        u.userhobby = [dic valueForKey:@"Hobby"];
        u.usermemo = [dic valueForKey:@"Memo"];
        u.useroccupation = [dic valueForKey:@"Occupation"];
    }
    else
    {
        u.userhobby = @"0";
        u.usermemo = @"0";
        u.useroccupation = @"0";
    }
    
    
//    u.token = [dic valueForKey:@"token"];
    return u;
}

@end
