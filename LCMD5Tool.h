//
//  LCMD5Tool.h
//  CarWashing
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCMD5Tool : NSObject

+(NSString *) md5: (NSString *) inPutText;
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

@end
