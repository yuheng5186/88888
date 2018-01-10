//
//  CYCardDeatilListViewController.m
//  CarWashing
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CYCardDeatilListViewController.h"
#import <Masonry.h>
//#import "DiscountCategoryView.h"
//#import "DiscountController.h"
//#import "RechargeController.h"
#import "RechargeCell.h"
#import "RechargeDetailController.h"
#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "CardBag.h"
#import "UIScrollView+EmptyDataSet.h"//第三方空白页
@interface CYCardDeatilListViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UITableView *rechargeView;
@property (nonatomic)NSInteger page;
@property (nonatomic, strong) NSMutableArray *CardbagData;
@end

static NSString *id_rechargeCell = @"id_rechargeCell";
@implementation CYCardDeatilListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    
    [self setupRefresh];
    [self drawBackButtonWithAction:@selector(backButtonClick:)];
}
-(void)setupRefresh
{
    self.rechargeView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）

        [self headerRereshing];

    }];

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.rechargeView.mj_header.automaticallyChangeAlpha = YES;

    [self.rechargeView.mj_header beginRefreshing];

    // 上拉刷新
    self.rechargeView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）

        [self footerRereshing];

    }];
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        //
        self.page = 0 ;
         [self GetCardbagList];

    });
}

- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        self.page++;
//    _CardbagData = [[NSMutableArray alloc]init];
        [self GetCardbagListMore];


    });
}
-(void)GetCardbagList
{
    
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             @"GetCardType":@(self.GetCardType),
                             @"PageIndex":[NSString stringWithFormat:@"%ld",self.page],
                             @"PageSize":@10
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    NSLog(@"-参数-%@",mulDic);
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/GetCardInfoList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"---%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            _CardbagData = [[NSMutableArray alloc]init];
            
            
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            
            if(arr.count == 0)
            {
                //                [self.view showInfo:@"暂无更多数据" autoHidden:YES interval:2];
                [HUD setHidden:YES];
                [self.rechargeView reloadData];
                [self.rechargeView.mj_header endRefreshing];
            }
            else
            {
                for(NSDictionary *dic in arr)
                {
                    CardBag *model = [CardBag new];
                    [model setValuesForKeysWithDictionary:dic];
                    [_CardbagData addObject:model];
                }
                //                for(NSDictionary *dic in arr)
                //                {
                //                    CardBag *model = [CardBag new];
                //                    [model setValuesForKeysWithDictionary:dic];
                //
                //                }
                [HUD setHidden:YES];
                [self.rechargeView reloadData];
                [self.rechargeView.mj_header endRefreshing];
            }
            
            
            
        }
        else
        {
            [self.rechargeView.mj_header endRefreshing];
            [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        
        [self.rechargeView.mj_header endRefreshing];
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

-(void)GetCardbagListMore
{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                            @"GetCardType":@(self.GetCardType),
                             @"PageIndex":[NSString stringWithFormat:@"%ld",self.page],
                             @"PageSize":@10
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    NSLog(@"--%@",params);
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/GetCardInfoList",Khttp] success:^(NSDictionary *dict, BOOL success) {

        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
//


            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];

            if(arr.count == 0)
            {
                //                [self.view showInfo:@"暂无更多数据" autoHidden:YES interval:2];
                [HUD setHidden:YES];
                [self.rechargeView reloadData];
                [self.rechargeView.mj_footer endRefreshing];
                self.page--;
            }
            else
            {
                for(NSDictionary *dic in arr)
                {
                    CardBag *model = [CardBag new];
                    [model setValuesForKeysWithDictionary:dic];
                    [_CardbagData addObject:model];
                }
                [HUD setHidden:YES];
                [self.rechargeView reloadData];
                [self.rechargeView.mj_footer endRefreshing];
            }
        }
        else
        {
            [self.rechargeView.mj_footer endRefreshing];
             self.page--;
            [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];

            [self.navigationController popViewControllerAnimated:YES];

        }
    } fail:^(NSError *error) {

        [self.rechargeView.mj_footer endRefreshing];
        self.page--;
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)drawNavigation {
    
    [self drawTitle:@"我的卡包"];
    
}
- (void)setupUI {
    
    [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(64);
        make.left.equalTo(self.view).mas_offset(Main_Screen_Width*22.5/375);
        make.right.equalTo(self.view).mas_offset(-Main_Screen_Width*22.5/375);
        make.height.mas_equalTo(Main_Screen_Height-64);
    }];
    //    self.rechargeView.top   =titleView.bottom+Main_Screen_Height*10/667;
    self.rechargeView.delegate = self;
    self.rechargeView.dataSource = self;
//    self.rechargeView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    [self.rechargeView registerNib:[UINib nibWithNibName:@"RechargeCell" bundle:nil] forCellReuseIdentifier:id_rechargeCell];
    self.rechargeView.rowHeight = 190;
    self.rechargeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rechargeView.backgroundColor = [UIColor clearColor];
    self.rechargeView.showsVerticalScrollIndicator = NO;
    
}

- (UITableView *)rechargeView {
    
    if (!_rechargeView) {
        
        UITableView *rechargeView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rechargeView = rechargeView;
        _rechargeView.emptyDataSetSource=self;
        _rechargeView.emptyDataSetDelegate=self;
//        _rechargeView.tableHeaderView   = [UIView new];
//        _rechargeView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_rechargeView];
    }
    return _rechargeView;
}
- (void) backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [_CardbagData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:id_rechargeCell forIndexPath:indexPath];

    cell.backgroundColor=RGBAA(242, 242, 242, 1.0);
    CardBag *card = (CardBag *)[_CardbagData objectAtIndex:indexPath.section];
    
//    bg_yiguoqi
//    bg_yishiyong
    

        if ([card.CardName isEqualToString:@"体验卡"]) {
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }else if ([card.CardName isEqualToString:@"月清洁"]){
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }else if ([card.CardName isEqualToString:@"季无忧"]){
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }else if ([card.CardName isEqualToString:@"半年洗"]){
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }else if ([card.CardName isEqualToString:@"年欢洗"]){
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }else if ([card.CardName isEqualToString:@"随意行"]){
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }else if ([card.CardName isEqualToString:@"52洗车"]){
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }else if ([card.CardName isEqualToString:@"百洗无忧"]){
            if (card.CardUseState ==1) {//使用中
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_card"];
            }else  if (card.CardUseState ==2) {//已使用
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yishiyong"];
            }else  if (card.CardUseState ==3) {//已过期
                cell.backgroundImgV.image = [UIImage imageNamed:@"bg_yiguoqi"];
            }
        }
    
    
    
        cell.CarddesLabel.text = [NSString stringWithFormat:@"免费洗车%ld次",card.CardCount];
        cell.CardnameLabel.text = card.CardName;
        cell.CardTimeLabel.text = [NSString stringWithFormat:@"有效期: %@",[self DateZhuan:card.ExpEndDates]];
    
//        if(card.CardUseState == 2)
//        {
//            cell.CardnameLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////            cell.tagLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
//            cell.CarddesLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_cika"];
//    
//        }
//        else if(card.CardUseState == 3)
//        {
//            cell.CardnameLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////            cell.tagLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
//            cell.CarddesLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_cika"];
//        }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==_CardbagData.count-1) {
        return 20;
    }
    return Main_Screen_Height*0/667;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CardBag *card = (CardBag *)[_CardbagData objectAtIndex:indexPath.section];
    RechargeDetailController *rechargeDetailVC = [[RechargeDetailController alloc] init];
    rechargeDetailVC.hidesBottomBarWhenPushed = YES;
    rechargeDetailVC.card = card;
    [self.navigationController pushViewController:rechargeDetailVC animated:YES];
    
}
-(NSString *)DateZhuan:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
    NSDateFormatter*outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString*str = [outputFormatter stringFromDate:inputDate];
    return str;
}
@end
