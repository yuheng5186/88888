//
//  DSSacnController.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BaseController.h"
#import "ZFConst.h"

@interface DSSacnController : BaseController

/** 扫描结果 */
@property (nonatomic, copy) void (^returnScanBarCodeValue)(NSString * barCodeString);

@end
