//
//  EarnScoreController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/14.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "EarnScoreController.h"
//#import "MemberRegualrController.h"
#import "WayToUpGradeCell.h"
#import "ScoreDetailController.h"
#import "DSMyCarController.h"
#import "DSUserInfoController.h"
#import "DSAdDetailController.h"

#import "LCMD5Tool.h"
#import "HYActivityView.h"
#import "AFNetworkingTool.h"
#import "HTTPDefine.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"

@interface EarnScoreController ()<UITableViewDelegate,SetTabBarDelegate, UITableViewDataSource>
{
     MBProgressHUD *HUD;
}

@property (nonatomic, weak) UIImageView *adverView;

@property (nonatomic, weak) UITableView *earnWayView;

@property (nonatomic, strong) NSMutableArray *ScoreData;
@property (nonatomic, strong) HYActivityView *activityView;

@end

static NSString *id_earnViewCell = @"id_earnViewCell";

@implementation EarnScoreController


- (UIImageView *)adverView {
    
    if (!_adverView) {
        
        UIImageView *adverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 100*Main_Screen_Height/667)];
        _adverView = adverView;
        adverView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adverViewClick:)];
        [adverView addGestureRecognizer:tap];
        [self.view addSubview:adverView];
    }
    return _adverView;
}


- (UITableView *)earnWayView {
    
    if (!_earnWayView) {
        
        UITableView *earnWayView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 100*Main_Screen_Height/667, Main_Screen_Width, Main_Screen_Height - 64 - 100*Main_Screen_Height/667) style:UITableViewStyleGrouped];
        _earnWayView = earnWayView;
        [self.view addSubview:_earnWayView];
    }
    return _earnWayView;
}


- (void)drawNavigation {
    
    [self drawTitle:@"赚积分"];
    [self drawRightTextButton:@"我的积分" action:@selector(clickMyScoreButton)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self requestGetScore];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adverView.image = [UIImage imageNamed:@"zhuanjifen_banner"];
    
    self.earnWayView.delegate = self;
    self.earnWayView.dataSource = self;
    self.earnWayView.estimatedSectionHeaderHeight = 0;
    self.earnWayView.estimatedSectionFooterHeight = 0;
    self.earnWayView.rowHeight = UITableViewAutomaticDimension;
    self.earnWayView.rowHeight = 90*Main_Screen_Height/667;
    [self.earnWayView registerClass:[WayToUpGradeCell class] forCellReuseIdentifier:id_earnViewCell];
    
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    
//    [self requestGetScore];
    
    
    
}

-(void)requestGetScore
{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Integral/EarnIntegral",Khttp] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            self.ScoreData = [[NSMutableArray alloc]init];
            
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            if(arr.count == 0)
            {
                [HUD setHidden:YES];
                [self.view showInfo:@"暂无数据" autoHidden:YES interval:2];
            
            }
            else
            {
                [self.ScoreData addObjectsFromArray:arr];
                [self.earnWayView reloadData];
                [HUD setHidden:YES];
            }
            
        }
        else
        {
            [self.view showInfo:@"数据请求失败请重试" autoHidden:YES interval:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSError *error) {
        [self.view showInfo:@"获取失败请重试" autoHidden:YES interval:2];
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.ScoreData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WayToUpGradeCell *earnScoreCell = [tableView dequeueReusableCellWithIdentifier:id_earnViewCell forIndexPath:indexPath];
    
    
    
    NSArray *arr2 = @[@"wanshangerenxinxi",@"xinyonghuzhuce",@"yaoqinghaoyou",@"wanshancheliangxinxi",@"wanshangerenxinxi"];
    
    NSInteger num = [[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegType"] integerValue];
    
    
    
    earnScoreCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arr2[num]]];
    earnScoreCell.waysLab.text = [[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegName"];
    
    if([NSNull null] != [[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegDesc"])
    {
        earnScoreCell.wayToLab.text = [NSString stringWithFormat:@"%@",[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegDesc"]];
    }
    else
    {
        earnScoreCell.wayToLab.text = @"";
    }
    
    
    
    earnScoreCell.valuesLab.text = [NSString stringWithFormat:@"+%d积分",[[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegralNum"] intValue]];
    
    if([[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IsComplete"] intValue] == 1)
    {
        
        [earnScoreCell.goButton setTitle:@"已完成" forState:UIControlStateNormal];
        [earnScoreCell.goButton setBackgroundColor:[UIColor colorFromHex:@"#e6e6e6"]];

        earnScoreCell.goButton.enabled = NO;
        
    }
    else
    {
        earnScoreCell.goButton.tag = indexPath.row;
        [earnScoreCell.goButton addTarget:self action:@selector(gotoearnScore:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    earnScoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return earnScoreCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10*Main_Screen_Height/667;
}



- (void)clickMyScoreButton{
    
    ScoreDetailController *scoreController = [[ScoreDetailController alloc] init];
    scoreController.hidesBottomBarWhenPushed = YES;
    scoreController.CurrentScore = self.CurrentScore;
    [self.navigationController pushViewController:scoreController animated:YES];
    
}

-(void)gotoearnScore:(UIButton *)btn
{
    if([[[self.ScoreData objectAtIndex:btn.tag] objectForKey:@"IntegType"] intValue] == 2)
    {
//        self.tabBarController.selectedIndex = 4;
//        [self.navigationController popToRootViewControllerAnimated:YES];
        if (!self.activityView)
        {
            self.activityView = [[HYActivityView alloc]initWithTitle:@"" referView:self.view];
            self.activityView.delegate = self;
            //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
            self.activityView.numberOfButtonPerLine = 6;
            
            ButtonView *bv ;
            
            bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"btn_share_weixin"] handler:^(ButtonView *buttonView){
                NSLog(@"点击微信");
                NSDictionary *mulDic = @{
                                         @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                         @"ShareType":@3
                                         };
                NSDictionary *params = @{
                                         @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                         @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                         };
                
                [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@InviteShare/UserShare",Khttp] success:^(NSDictionary *dict, BOOL success) {
                    NSLog(@"%@",dict);
                    if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                    {
                        //创建发送对象实例
                        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
                        sendReq.bText = NO;//不使用文本信息
                        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
                        
                        //创建分享内容对象
                        WXMediaMessage *urlMessage = [WXMediaMessage message];
                        urlMessage.title = [[dict objectForKey:@"JsonData"] objectForKey:@"ShareTitle"];//分享标题
                        urlMessage.description = [[dict objectForKey:@"JsonData"] objectForKey:@"ShareContent"];//分享描述
                        [urlMessage setThumbImage:[UIImage imageNamed:@"denglu_icon"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
                        
                        //创建多媒体对象
                        WXWebpageObject *webObj = [WXWebpageObject object];
                        webObj.webpageUrl = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"JsonData"] objectForKey:@"InviteShareUrl"]];//分享链接
                        
                        //完成发送对象实例
                        urlMessage.mediaObject = webObj;
                        sendReq.message = urlMessage;
                        
                        //发送分享信息
                        [WXApi sendReq:sendReq];
                        
                    }
                    else
                    {
                        [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                        
                    }
                    
                } fail:^(NSError *error) {
                    [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                    
                }];
                
                self.tabBarController.tabBar.hidden = NO;
                
            }];
            [self.activityView addButtonView:bv];
            
            bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"btn_share_pengyouquan"] handler:^(ButtonView *buttonView){
                NSLog(@"点击微信朋友圈");
                NSDictionary *mulDic = @{
                                         @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                         @"ShareType":@3
                                         };
                NSDictionary *params = @{
                                         @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                         @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                         };
                
                [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@InviteShare/UserShare",Khttp] success:^(NSDictionary *dict, BOOL success) {
                    
                    if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                    {
                        //创建发送对象实例
                        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
                        sendReq.bText = NO;//不使用文本信息
                        sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
                        
                        //创建分享内容对象
                        WXMediaMessage *urlMessage = [WXMediaMessage message];
                        urlMessage.title = [[dict objectForKey:@"JsonData"] objectForKey:@"ShareTitle"];//分享标题
                        urlMessage.description = [[dict objectForKey:@"JsonData"] objectForKey:@"ShareContent"];//分享描述
                        [urlMessage setThumbImage:[UIImage imageNamed:@"denglu_icon"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
                        
                        //创建多媒体对象
                        WXWebpageObject *webObj = [WXWebpageObject object];
                        webObj.webpageUrl = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"JsonData"] objectForKey:@"InviteShareUrl"]];//分享链接
                        
                        //完成发送对象实例
                        urlMessage.mediaObject = webObj;
                        sendReq.message = urlMessage;
                        
                        //发送分享信息
                        [WXApi sendReq:sendReq];
                        
                    }
                    else
                    {
                        [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                        
                    }
                    
                } fail:^(NSError *error) {
                    [self.view showInfo:@"分享失败，请重试" autoHidden:YES interval:2];
                    
                }];
                
                self.tabBarController.tabBar.hidden = NO;
                
            }];
            [self.activityView addButtonView:bv];
            
            
        }
        self.tabBarController.tabBar.hidden = YES;
        
        [self.activityView show];
    }
    else if([[[self.ScoreData objectAtIndex:btn.tag] objectForKey:@"IntegType"] intValue] == 3)
    {
        DSMyCarController *myCarController                  = [[DSMyCarController alloc]init];
        myCarController.hidesBottomBarWhenPushed            = YES;
        [self.navigationController pushViewController:myCarController animated:YES];
    }
    else if([[[self.ScoreData objectAtIndex:btn.tag] objectForKey:@"IntegType"] intValue] == 4)
    {
        DSUserInfoController *userInfoController    = [[DSUserInfoController alloc]init];
        userInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoController animated:YES];
    }
}
#pragma mark ----banner点击-----
//banner点击
-(void)adverViewClick:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"hah");
//    DSAdDetailController *viewVC = [[DSAdDetailController alloc]init];
//    viewVC.urlstr=HOMEURL;
//    viewVC.shareurlstr=HOMEINTURL;
//    viewVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
