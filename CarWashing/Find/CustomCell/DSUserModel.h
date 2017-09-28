//
//  DSUserModel.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSUserModel : JSONModel

@property (nonatomic, copy) NSString *Account_Id;
@property (nonatomic)NSInteger ActivityCode;
@property (nonatomic, copy) NSString *Comment;
@property (nonatomic)NSInteger CommentCode;
@property (nonatomic, copy) NSString *CommentDate;
@property (nonatomic, copy) NSString *CommentUserImg;
@property (nonatomic, copy) NSString *CommentUserName;
@property (nonatomic) id<Optional> IsAudite;
@property (nonatomic) NSInteger IsGive;
@property (nonatomic) NSInteger PageIndex;

@property (nonatomic) id<Optional> PageSize;

@property (nonatomic) NSInteger Support;
@end
