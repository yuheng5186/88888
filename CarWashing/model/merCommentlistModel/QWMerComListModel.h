//
//  QWMerComListModel.h
//  QWCarWashing
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface QWMerComListModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *Account_Id,*CommentContent,*CommentDate,*FromuserImg,*FromuserName,*PageSize;
@property(nonatomic,assign)int ComCode,MerCode,OrderId,Score,SerCode,PageIndex;
@end
