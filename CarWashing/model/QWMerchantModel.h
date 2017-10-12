//
//  QWMerchantModel.h
//  QWCarWashing
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QWMerComListModel.h"
@interface QWMerSerListModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *CurrentPrice,*OriginalPrice,*SerComment,*SerName;
@property(nonatomic,assign)int MerCode,SerCode;
@end
@interface QWMerchantModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *Area,*City,*Img,*MerAddress,*MerFlag,*MerName,*MerPhone,*ServiceTime,*StoreProfile,*MerCode;
@property(nonatomic,assign)CGFloat Distance,Score,Xm,Ym;//距离
@property(nonatomic,assign)int Iscert,ServiceCount,ShopType,IsCollection;
@property(nonatomic,strong)NSArray <QWMerComListModel *> *MerComList;
@property(nonatomic,strong)NSArray <QWMerSerListModel *> *MerSerList;
@end
