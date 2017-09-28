//
//  DSCardGroupController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSCardGroupController.h"
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
//新增的页面
#import "CYCardTableViewCell.h"
#import "CYCardDeatilListViewController.h"
@interface DSCardGroupController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    MBProgressHUD *HUD;
}

//@property (nonatomic, weak) UIView *containerView;
//
//@property (nonatomic, weak) UIScrollView *cardScrollView;
//
//@property (nonatomic, weak) DiscountCategoryView *categoryView;
@property (nonatomic, weak) UITextField *activateTF;
@property (nonatomic, weak) UIButton *activateBtn;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UITableView *rechargeView;
@property (nonatomic)NSInteger page;
@property (nonatomic, strong) NSMutableArray *CardbagData;

@end

static NSString *CyrechargeCell = @"CyrechargeCell";

@implementation DSCardGroupController

- (UITextField *)activateTF {
    
    if (!_activateTF) {
        
        UITextField *activateTF = [[UITextField alloc] init];
        activateTF.backgroundColor = [UIColor whiteColor];
        activateTF.placeholder = @"  请输入激活码";
        activateTF.font = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
        activateTF.textColor = [UIColor colorFromHex:@"#c8c8c8"];
        activateTF.layer.cornerRadius = Main_Screen_Height*20/667;
        activateTF.layer.borderWidth  = 0.5;
        activateTF.layer.borderColor  = [UIColor colorFromHex:@"#c8c8c8"].CGColor;
        activateTF.clipsToBounds = YES;
        _activateTF = activateTF;
        [self.view addSubview:activateTF];
    }
    
    return _activateTF;
}


- (UIButton *)activateBtn {
    
    if (!_activateBtn) {
        
        UIButton *activateBtn = [[UIButton alloc] init];
        [activateBtn setTitle:@"激活卡" forState:UIControlStateNormal];
        activateBtn.backgroundColor = [UIColor colorFromHex:@"#0161a1"];
        activateBtn.titleLabel.tintColor = [UIColor colorFromHex:@"#ffffff"];
        activateBtn.titleLabel.font = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
        activateBtn.layer.cornerRadius = Main_Screen_Height*20/667;
        activateBtn.clipsToBounds = YES;
        [activateBtn addTarget:self action:@selector(jihuokapian:) forControlEvents:UIControlEventTouchUpInside];
        _activateBtn = activateBtn;
        
        [self.view addSubview:_activateBtn];
    }
    
    return _activateBtn;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)drawNavigation {
    
    [self drawTitle:@"我的卡包"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    
//    [self setupRefresh];
    [self GetCardbagList];
    [self drawBackButtonWithAction:@selector(backButtonClick:)];
}

- (void) backButtonClick:(id)sender {
    
    self.tabBarController.selectedIndex = 0;
    
    NSArray     *array  = self.navigationController.viewControllers;
    NSArray *a = [NSArray arrayWithObject:array[0]];
    
    
    
    if(array.count == 4)
    {
        
        self.navigationController.viewControllers = a;
        
    }
    else
    {
        NSArray     *array1 = [NSArray arrayWithObject:array[0]];
        self.navigationController.viewControllers = array1;
    }
    
}
//-(void)setupRefresh
//{
//    self.rechargeView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        
//        [self headerRereshing];
//        
//    }];
//    
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.rechargeView.mj_header.automaticallyChangeAlpha = YES;
//    
//    [self.rechargeView.mj_header beginRefreshing];
//    
//    // 上拉刷新
//    self.rechargeView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        
//        [self footerRereshing];
//        
//    }];
//}

//- (void)headerRereshing
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        //
//        self.page = 0 ;
//         [self GetCardbagList];
//        
//    });
//}
//
//- (void)footerRereshing
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        
//        self.page++;
////    _CardbagData = [[NSMutableArray alloc]init];
//        [self GetCardbagListMore];
//        
//        
//        //
//        //
//        //
//        //
//        //        // 刷新表格
//        //
//        //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        
//    });
//}
-(void)GetCardbagList
{
    
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/GetCardTypeList",Khttp] success:^(NSDictionary *dict, BOOL success) {
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

//-(void)GetCardbagListMore
//{
//    NSDictionary *mulDic = @{
//                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
//                             @"PageIndex":[NSString stringWithFormat:@"%ld",self.page],
//                             @"PageSize":@10
//                             };
//    NSDictionary *params = @{
//                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
//                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
//                             };
//    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/GetCardInfoList",Khttp] success:^(NSDictionary *dict, BOOL success) {
//        
//        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
//        {
////
//            
//            
//            NSArray *arr = [NSArray array];
//            arr = [dict objectForKey:@"JsonData"];
//           
//            if(arr.count == 0)
//            {
//                //                [self.view showInfo:@"暂无更多数据" autoHidden:YES interval:2];
//                [HUD setHidden:YES];
//                [self.rechargeView reloadData];
//                [self.rechargeView.mj_footer endRefreshing];
//                self.page--;
//            }
//            else
//            {
//                for(NSDictionary *dic in arr)
//                {
//                    CardBag *model = [CardBag new];
//                    [model setValuesForKeysWithDictionary:dic];
//                    [_CardbagData addObject:model];
//                }
//                [HUD setHidden:YES];
//                [self.rechargeView reloadData];
//                [self.rechargeView.mj_footer endRefreshing];
//            }
//            
//            
//            
//        }
//        else
//        {
//            [self.rechargeView.mj_footer endRefreshing];
//             self.page--;
//            [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }
//    } fail:^(NSError *error) {
//        
//        [self.rechargeView.mj_footer endRefreshing];
//        self.page--;
//        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }];
//    
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.activateTF resignFirstResponder];
    
    [self.view endEditing:YES];
}

- (void)setupUI {
    
    //    [self setupCategoryView];
    //    [self setupScrollView];
    //
    //    [self addCardChildViewControllers];
    
    
    UIView *titleView                  = [UIUtil drawLineInView:self.view frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*60/667) color:[UIColor whiteColor]];
//    titleView.top                      = 64;
    self.titleView=titleView;
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(64);
       make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(Main_Screen_Height*60/667);
        
    }];
    
    [self.activateTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).mas_offset(Main_Screen_Width*10/375);
        make.top.equalTo(titleView).mas_offset(Main_Screen_Height*10/667);
        make.width.mas_equalTo(Main_Screen_Width*270/375);
        make.height.mas_equalTo(Main_Screen_Height*40/667);
    }];
    
    [self.activateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_equalTo(-Main_Screen_Width*10/375);
        make.top.equalTo(titleView).mas_equalTo(Main_Screen_Height*10/667);
        make.width.mas_equalTo(Main_Screen_Width*75/375);
        make.height.mas_equalTo(Main_Screen_Height*40/667);
    }];
    
    
    [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).mas_offset(0);
//        make.left.equalTo(self.view).mas_offset(Main_Screen_Width*22.5/375);
//        make.right.equalTo(self.view).mas_offset(-Main_Screen_Width*22.5/375);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.height-Main_Screen_Height*60/667-Main_Screen_Height*64/667);
    }];
//    self.rechargeView.top   =titleView.bottom+Main_Screen_Height*10/667;
    self.rechargeView.delegate = self;
    self.rechargeView.dataSource = self;
//    self.rechargeView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    
//    [self.rechargeView registerNib:[UINib nibWithNibName:@"RechargeCell" bundle:nil] forCellReuseIdentifier:id_rechargeCell];
    self.rechargeView.rowHeight = Main_Screen_Height*160/667;
    self.rechargeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rechargeView.backgroundColor = [UIColor clearColor];
    self.rechargeView.showsVerticalScrollIndicator = NO;
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(_activateTF.frame.origin.x,_activateTF.frame.origin.y,15.0, _activateTF.frame.size.height)];
    _activateTF.leftView = blankView;
    _activateTF.leftViewMode =UITextFieldViewModeAlways;
    
}




//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return [_CardbagData count];
////    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_CardbagData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CYCardTableViewCell * cell = [_rechargeView dequeueReusableCellWithIdentifier:CyrechargeCell];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CYCardTableViewCell" owner:self options:nil]lastObject];
    }
    CardBag * model = _CardbagData[indexPath.row];
    [cell configCell:model];
//    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:id_rechargeCell forIndexPath:indexPath];
//    cell.contentView.backgroundColor = self.view.backgroundColor;
//    cell.backgroundColor = self.view.backgroundColor;
//    
//    CardBag *card = (CardBag *)[_CardbagData objectAtIndex:indexPath.section];
//    
//    
//    if(card.CardType == 1)
//    {
//        cell.backgroundImgV.image = [UIImage imageNamed:@"qw_tiyanka"];
//        
//        if(card.CardUseState == 2)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_tiyanka"];
//            
//        }
//        else if(card.CardUseState == 3)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_tiyanka"];
//        }
//        
//        
//    }else if(card.CardType == 2)
//    {
//        cell.backgroundImgV.image = [UIImage imageNamed:@"qw_yueka"];
//        
//        if(card.CardUseState == 2)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_yueka"];
//            
//        }
//        else if(card.CardUseState == 3)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_yueka"];
//        }
//        
//    }else if(card.CardType == 3)
//    {
//        cell.backgroundImgV.image = [UIImage imageNamed:@"qw_cika"];
//        
//        if(card.CardUseState == 2)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_cika"];
//            
//        }
//        else if(card.CardUseState == 3)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_cika"];
//        }
//        
//    }else if(card.CardType == 4)
//    {
//        cell.backgroundImgV.image = [UIImage imageNamed:@"qw_nianka"];
//        
//        if(card.CardUseState == 2)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_nianka"];
//            
//        }
//        else if(card.CardUseState == 3)
//        {
//            cell.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_nianka"];
//        }
//        
//    }
//    
//    cell.CardnameLabel.text = [NSString stringWithFormat:@"免费洗车%ld次",card.CardCount];
//    
//    cell.CardTimeLabel.text = [NSString stringWithFormat:@"截止日期: %@",[self DateZhuan:card.ExpEndDates]];
//    
////    if(card.CardUseState == 2)
////    {
////        cell.CardnameLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////        cell.tagLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////        cell.CarddesLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////        cell.backgroundImgV.image = [UIImage imageNamed:@"qw_yishiyong_cika"];
////        
////    }
////    else if(card.CardUseState == 3)
////    {
////        cell.CardnameLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////        cell.tagLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////        cell.CarddesLabel.textColor = [UIColor colorFromHex:@"#ffffff"];
////        cell.backgroundImgV.image = [UIImage imageNamed:@"qw_guoqi_cika"];
////    }
    
    

    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return Main_Screen_Height*22.5/667;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    
//    return Main_Screen_Height*0/667;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.activateTF resignFirstResponder];

    CardBag *card = (CardBag *)[_CardbagData objectAtIndex:indexPath.row];
    CYCardDeatilListViewController *rechargeDetailVC = [[CYCardDeatilListViewController alloc] init];
    rechargeDetailVC.hidesBottomBarWhenPushed = YES;
    rechargeDetailVC.GetCardType = card.Type;
    [self.navigationController pushViewController:rechargeDetailVC animated:YES];
    
}

-(void)jihuokapian:(UIButton *)btn
{
    
    if(_activateTF.text.length == 0)
    {
        [self.view showInfo:@"请输入激活码" autoHidden:YES interval:2];
    }
    else
    {
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                 @"ActivationCode":_activateTF.text
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/ActivationCard",Khttp] success:^(NSDictionary *dict, BOOL success) {
            
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                if([[[dict objectForKey:@"JsonData"] objectForKey:@"Activationstate"] integerValue] == 3)
                {
                    [self.view showInfo:@"对不起，该卡不存在" autoHidden:YES interval:2];
                }
                else if([[[dict objectForKey:@"JsonData"] objectForKey:@"Activationstate"] integerValue] == 1)
                {
                    [self.view showInfo:@"激活成功" autoHidden:YES interval:2];
                    [self GetCardbagList];
                }
                else if([[[dict objectForKey:@"JsonData"]objectForKey:@"Activationstate"] integerValue] == 2)
                {
                    if([[[dict objectForKey:@"JsonData"] objectForKey:@"CardUseState"] integerValue] == 1)
                    {
                        [self.view showInfo:@"对不起，该卡已被激活" autoHidden:YES interval:2];
                    }
                    else if([[[dict objectForKey:@"JsonData"] objectForKey:@"CardUseState"] integerValue] == 2)
                    {
                        [self.view showInfo:@"对不起，该卡已被使用" autoHidden:YES interval:2];
                    }
                    else{
                        [self.view showInfo:@"对不起，该卡已失效" autoHidden:YES interval:2];
                    }
                    
                    
                }
                else
                {
                    [self.view showInfo:@"激活失败" autoHidden:YES interval:2];
                }
                
                
                
            }
            else
            {
                [self.view showInfo:@"激活失败" autoHidden:YES interval:2];
            }
        } fail:^(NSError *error) {
            [self.view showInfo:@"激活失败" autoHidden:YES interval:2];
            
        }];

    }
    
    
}




#pragma mark - 无数据占位
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"kabao_kongbai"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"kabao_kongbai"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0,   1.0)];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}
//设置文字（上图下面的文字，我这个图片默认没有这个文字的）是富文本样式，扩展性很强！

//这个是设置标题文字的
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"客官你还没有办理过卡";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor colorFromHex:@"#4a4a4a"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//设置按钮的文本和按钮的背景图片
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state  {
    //    NSLog(@"buttonTitleForEmptyDataSet:点击上传照片");
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    return [[NSAttributedString alloc] initWithString:@"去购卡" attributes:attributes];
}
#pragma mark-背景图片
//-(UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//
//    return [UIImage imageNamed:@"mashangxiche-"];
//}
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [UIImage imageNamed:@"qgouka"];
}
//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}
//是否允许点击，默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
//图片是否要动画效果，默认NO
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
    return YES;
}
//空白页点击事件
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    NSLog(@"空白页点击事件");
}
//空白页按钮点击事件
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    self.tabBarController.selectedIndex = 3;
}
/**
 *  调整垂直位置
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return (-64.f)*Main_Screen_Height/667;
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
