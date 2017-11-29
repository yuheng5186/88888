//
//  PayOrderController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "PayOrderController.h"
#import "DelayPayCell.h"

#import "UIScrollView+EmptyDataSet.h"//第三方空白页
#import "OrderDetailController.h"

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "HTTPDefine.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"

#import "Order.h"

@interface PayOrderController ()<UITableViewDelegate, UITableViewDataSource, DelayPayCellPushVCDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak) UITableView *payOrderView;

@property (nonatomic)NSInteger page;
@property (nonatomic, strong) NSMutableArray *DelayPayDataArray;


@end

static NSString *id_delayPayCell = @"id_delayPayCell";

@implementation PayOrderController


- (UITableView *)payOrderView {
    if (!_payOrderView) {
        UITableView *payOrderView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.view.bounds.size.height - 64 -44) style:UITableViewStyleGrouped];
        _payOrderView = payOrderView;
        [self.view addSubview:_payOrderView];
    }
    return _payOrderView;
}


- (void) drawContent
{
    self.statusView.hidden      = YES;
    self.navigationView.hidden  = YES;
    self.contentView.top        = 0;
    self.contentView.height     = self.view.height;
    self.contentView.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(goBack) name:@"paysuccess" object:nil];
    self.payOrderView.delegate = self;
    self.payOrderView.dataSource = self;
    
    self.payOrderView.emptyDataSetSource=self;
    self.payOrderView.emptyDataSetDelegate=self;
    
    [self.payOrderView registerNib:[UINib nibWithNibName:@"DelayPayCell" bundle:nil] forCellReuseIdentifier:id_delayPayCell];
    self.payOrderView.rowHeight = 150*Main_Screen_Height/667;
    
    self.page = 0 ;
    
    [self setupRefresh];
    
}
#pragma mark-支付成功回调
-(void)goBack{
   
    [self.payOrderView reloadData];
    
}
-(void)setupRefresh
{
    self.payOrderView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
        [self headerRereshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.payOrderView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.payOrderView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.payOrderView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
        [self footerRereshing];
        
    }];
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self setData];
        
    });
}

- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        self.page++;
        [self setDataMore];
       // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
    });
}

-(void)setData
{
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                 @"PageIndex":@0,
                                 @"PageSize":@10,
                                 @"PayState" :@1
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
    
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@OrderRecords/GetOrderRecordsList",Khttp] success:^(NSDictionary *dict, BOOL success) {
    
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                self.page = 0;
                self.DelayPayDataArray = [[NSMutableArray alloc]init];
                NSArray *arr = [NSArray array];
                arr = [dict objectForKey:@"JsonData"];
                if(arr.count == 0)
                {
                    //                [self.view showInfo:@"暂无更多数据" autoHidden:YES interval:2];
                    [self.payOrderView reloadData];
                    [self.payOrderView.mj_header endRefreshing];
                }
                else
                {
                    
                    for(NSDictionary *dic in arr)
                    {
                        Order *order = [[Order alloc]initWithDictionary:dic error:nil];
                        
                        [self.DelayPayDataArray addObject:order];
                    }
                    
                    [self.payOrderView reloadData];
                    [self.payOrderView.mj_header endRefreshing];
                }

    
            }
            else
            {
                [self.payOrderView showInfo:@"数据请求失败" autoHidden:YES interval:2];
                [self.payOrderView.mj_header endRefreshing];
            }
    
        } fail:^(NSError *error) {
            [self.payOrderView showInfo:@"获取失败" autoHidden:YES interval:2];
            [self.payOrderView.mj_header endRefreshing];
        }];
    
}

-(void)setDataMore
{
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                 @"PageIndex":[NSString stringWithFormat:@"%ld",self.page],
                                 @"PageSize":@10,
                                 @"PayState" :@1
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
    
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@OrderRecords/GetOrderRecordsList",Khttp] success:^(NSDictionary *dict, BOOL success) {
    
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
    
                NSArray *arr = [NSArray array];
                arr = [dict objectForKey:@"JsonData"];
                if(arr.count == 0)
                {
                    [self.payOrderView showInfo:@"暂无更多数据" autoHidden:YES interval:2];
                    self.page--;
                    [self.payOrderView reloadData];
                    [self.payOrderView.mj_footer endRefreshing];
                }
                else
                {
                    for(NSDictionary *dic in arr)
                    {
                        Order *order = [[Order alloc]init];
                        [order setValuesForKeysWithDictionary:dic];
                        [self.DelayPayDataArray addObject:order];
                    }
                    
                    [self.payOrderView reloadData];
                    [self.payOrderView.mj_footer endRefreshing];
                }
    
            }
            else
            {
                self.page--;
                [self.payOrderView showInfo:@"数据请求失败" autoHidden:YES interval:2];
                [self.payOrderView.mj_footer endRefreshing];
            }
            
        } fail:^(NSError *error) {
            self.page--;
            [self.payOrderView showInfo:@"获取失败" autoHidden:YES interval:2];
            [self.payOrderView.mj_footer endRefreshing];
        }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.DelayPayDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Order *order = (Order *)[self.DelayPayDataArray objectAtIndex:indexPath.section];
    
    DelayPayCell *delayCell = [tableView dequeueReusableCellWithIdentifier:id_delayPayCell forIndexPath:indexPath];
    delayCell.delegate = self;
    
    delayCell.orderLabel.text = [NSString stringWithFormat:@"订单号: %@",order.OrderCode];
    delayCell.priceLabel.text = [NSString stringWithFormat:@"￥%@",order.PaypriceAmount];
    delayCell.washTypeLabel.text = order.SerName;
    
    delayCell.SerMerChant = order.SerName;
    delayCell.Jprice = [NSString stringWithFormat:@"￥%@",order.PayableAmount];
    delayCell.Xprice = [NSString stringWithFormat:@"￥%@",order.PaypriceAmount];
    
    delayCell.SCode = [NSString stringWithFormat:@"%ld",order.SerCode];
    delayCell.MCode = [NSString stringWithFormat:@"%ld",order.MerCode];
    delayCell.OrderCode = order.OrderCode;
    
    
    return delayCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Order *order = (Order *)[self.DelayPayDataArray objectAtIndex:indexPath.section];
    //
    //    if(order.PayState == 3)
    //    {
    OrderDetailController *orderDetailVC = [[OrderDetailController alloc] init];
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    
    
    orderDetailVC.MerCode = order.MerCode;
    
    orderDetailVC.MerChantService = order.SerName;
    
    
    orderDetailVC.ShijiPrice = [NSString stringWithFormat:@"%@",order.PaypriceAmount];
    orderDetailVC.Jprice = [NSString stringWithFormat:@"%@",order.PayableAmount];
    orderDetailVC.youhuiprice = [NSString stringWithFormat:@"%@",order.DeductionAmount];
    orderDetailVC.shijiPrice1 = [NSString stringWithFormat:@"%@",order.PaypriceAmount];
    orderDetailVC.orderid = order.OrderCode;
    orderDetailVC.ordertime = order.PayTimes;
    orderDetailVC.paymethod = @"微信支付";
    if(order.PayMethod == 2)
    {
        orderDetailVC.paymethod = @"支付宝支付";
    }
    
    
    
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    //    }
    
    
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10*Main_Screen_Height/667;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}




#pragma mark - DelayPay的代理
- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self.navigationController pushViewController:viewController animated:animated];
}

#pragma mark - 无数据占位
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"dingdan_kongbai"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"dingdan_kongbai"];
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
    NSString *text = @"你还没有订单信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor colorFromHex: @"#4a4a4a"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//设置占位图空白页的背景色( 图片优先级高于文字)

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
}
//设置按钮的文本和按钮的背景图片
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state  {
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
//    return [[NSAttributedString alloc] initWithString:@"马上去洗车" attributes:attributes];
//}
//-(UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//    return [UIImage imageNamed:@"qxiche"];
//}
//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    return [UIImage imageNamed:@"qxiche"];
//}
//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}
//是否允许点击，默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
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
    return NSLog(@"空白页按钮点击事件");
}
/**
 *  调整垂直位置
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -64.f-44;
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
