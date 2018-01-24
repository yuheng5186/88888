//
//  HomeAdModel.h
//  CarWashing
//
//  Created by Wuxinglin on 2018/1/16.
//  Copyright © 2018年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeAdModel : NSObject
@property(copy,nonatomic)NSString *ImgUrl;          //显示图片url
@property(copy,nonatomic)NSString *InviteUrl;       //分享出去的链接
@property(copy,nonatomic)NSString *ShareContent;    //分享的内容
@property(copy,nonatomic)NSString *ShareTitle;      //分享的标题
@property(copy,nonatomic)NSString *Url;             //h5的链接
@property(copy,nonatomic)NSString *Title;             //列表中的title
@end
