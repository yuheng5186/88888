//
//  DSAdDetailController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"

@interface DSAdDetailController : BaseController
@property(nonatomic,strong)NSString *urlstr;
@property(nonatomic,strong)NSString *shareurlstr;
@property(nonatomic,assign)NSInteger AactivityCode;//卡编号
@property(nonatomic,assign)NSInteger *AactivityType;//活动类型
//修改分享到微信以及朋友圈时内容写死
@property(nonatomic,copy)NSString *jackShareContent;
@property(nonatomic,copy)NSString *jackShareTitle;
@end
