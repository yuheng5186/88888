//
//  CarClubNews.h
//  CarWashing
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarClubNews : NSObject

@property (copy, nonatomic)NSString *Account_Id;
@property NSInteger ActivityCode;//活动编号
@property (copy, nonatomic)NSString *Area;//城市名称
@property (copy, nonatomic)NSString *ActivityName;//活动名称
@property (copy, nonatomic)NSString *Comment;//活动内容
@property NSInteger CommentCount;//评论次数
@property NSInteger GiveCount;//点赞次数
@property (copy, nonatomic)NSString *FromusrName;//文章作者
@property (copy, nonatomic)NSString *FromusrImg;//文章作者
@property (copy, nonatomic)NSString *IndexImg;//首页图片
@property (copy, nonatomic)NSString *ActDate;//创建时间
@property (nonatomic)NSInteger IsGive;//是否点赞
@property (nonatomic)NSInteger PageIndex;
@property (nonatomic)NSInteger PageSize;
@property (nonatomic)NSInteger Readcount;//阅读次数
@property (copy, nonatomic)NSMutableArray *actModelList;//评论集合


- (instancetype)initWithDictionary:(NSDictionary*)dic;

@end
