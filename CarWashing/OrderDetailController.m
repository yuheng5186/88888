//
//  OrderDetailController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderDetailView.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "UdStorage.h"
#import "AFNetworkingTool.h"

#import "BusinessDetailViewController.h"

#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#import "JXMapNavigationView.h"

@interface OrderDetailController ()
{
     MBProgressHUD *HUD;
}
@property (nonatomic, strong) NSDictionary *dic;
#pragma mark - map
@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;

@end

@implementation OrderDetailController

- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}

- (void)drawNavigation {
    
    [self drawTitle:@"订单详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dic = [[NSMutableDictionary alloc]init];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    
    [self setMerChantDetailData];
    
}

-(void)setMerChantDetailData
{
    
    NSDictionary *mulDic = @{
                             @"MerCode":[NSString stringWithFormat:@"%ld",self.MerCode],
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MerChant/GetStoreDetail",Khttp] success:^(NSDictionary *dict, BOOL success) {
        //        NSLog(@"%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            
            [HUD setHidden:YES];
            
            self.dic = [dict objectForKey:@"JsonData"];
            OrderDetailView *detailView = [OrderDetailView orderDetailView];
            detailView.frame = CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height - 64);
            [self.view addSubview:detailView];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,self.dic[@"Img"]];
                NSURL *url=[NSURL URLWithString:ImageURL];
                NSData *data=[NSData dataWithContentsOfURL:url];
                UIImage *img=[UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    detailView.MerChantImgV.image = img;
                });
            });
            
            if([self.dic[@"ShopType"] intValue] == 1)
            {
                detailView.MerChantType.text = @"洗车服务";
            }
            
            detailView.MerChantAdress.text = self.dic[@"MerAddress"];
            
            detailView.MerChantName.text = self.dic[@"MerName"];
            
            detailView.MerChantService.text = self.MerChantService;
            
            detailView.MerChantService.text = self.MerChantService;
            detailView.ShijiPrice.text = [NSString stringWithFormat:@"￥%@",self.ShijiPrice];
            detailView.Jprice.text = [NSString stringWithFormat:@"￥%@",self.Jprice];
            detailView.youhuiprice.text = [NSString stringWithFormat:@"-￥%@",self.youhuiprice];
            detailView.shijiPrice1.text = [NSString stringWithFormat:@"￥%@",self.shijiPrice1];
            detailView.orderid.text = [NSString stringWithFormat:@"订单编号 : %@",self.orderid];
            detailView.ordertime.text = [NSString stringWithFormat:@"订单时间 : %@",self.ordertime];
            detailView.paymethod.text = [NSString stringWithFormat:@"支付方式 : %@",self.paymethod];
            
        }
        else
        {
            [HUD setHidden:YES];
            [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];
        }
        
        
        
        
    } fail:^(NSError *error) {
        
        [HUD setHidden:YES];
        
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
       
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
- (IBAction)DaoHang:(id)sender {
    [self.mapNavigationView showMapNavigationViewWithtargetLatitude:22.488260 targetLongitute:113.915049 toName:@"中海油华英加油站"];
    [self.view addSubview:_mapNavigationView];
}


- (IBAction)GoMerChant:(id)sender {
    
    //跳转商家详情
    BusinessDetailViewController *detailController = [[BusinessDetailViewController alloc] init];
    detailController.hidesBottomBarWhenPushed      = YES;
    detailController.MerCode                       = [[self.dic objectForKey:@"MerCode"] integerValue];
    
    [self.navigationController pushViewController:detailController animated:YES];
    
}





@end
