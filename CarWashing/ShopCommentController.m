//
//  ShopCommentController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ShopCommentController.h"
#import "BusinessEstimateCell.h"
#import "UIScrollView+EmptyDataSet.h"//第三方空白页
#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface ShopCommentController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak) UITableView *commentListView;

@property (nonatomic, strong) NSMutableArray *MerchantCommentListData;

@property (nonatomic)NSInteger page;
@property (nonatomic,copy) NSMutableArray <QWMerComListModel *> *MerComList;

@end

static NSString *id_commentShopCell = @"id_commentShopCell";

@implementation ShopCommentController

- (UITableView *)commentListView{
    if (_commentListView == nil) {
        UITableView *commenListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height-44*Main_Screen_Height/667-64) style:UITableViewStyleGrouped];
        _commentListView = commenListView;
        [self.view addSubview:commenListView];
    }
    return _commentListView;
}
-(NSMutableArray<QWMerComListModel *> *)MerComList{
    if (_MerComList==nil) {
        _MerComList=[NSMutableArray arrayWithCapacity:0];
    }
    return _MerComList;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MerchantCommentListData = [[NSMutableArray alloc]init];
    
    
    self.commentListView.delegate = self;
    self.commentListView.dataSource = self;
#pragma maek-空白页
    self.commentListView.emptyDataSetSource = self;
    self.commentListView.emptyDataSetDelegate = self;
    //可以去除tableView的多余的线，否则会影响美观
    self.commentListView.tableFooterView = [UIView new];
    [self.commentListView registerNib:[UINib nibWithNibName:@"BusinessEstimateCell" bundle:nil] forCellReuseIdentifier:id_commentShopCell];
    self.commentListView.rowHeight = 110*Main_Screen_Height/667;
    
    [self setupRefresh];
}

-(void)setupRefresh
{
    self.commentListView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
        [self headerRereshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.commentListView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.commentListView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.commentListView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
        [self footerRereshing];
        
    }];
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _MerchantCommentListData = [NSMutableArray new];

        self.page = 0 ;

        [self GetCommentDetail];
        
    });
}


- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(_MerchantCommentListData.count == 0)
        {
            [self GetCommentDetail];
        }
        else
        {
            self.page++;
            [self GetCommentDetailmore];
            
        }
        
        
        
        
        // 刷新表格
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
    });
}


-(void)GetCommentDetail
{
    NSDictionary *mulDic = @{
                             @"MerCode":[NSString stringWithFormat:@"%d",[self.dic[@"MerCode"] intValue]],
                             @"PageIndex":[NSString stringWithFormat:@"%ld",self.page],
                             @"PageSize":@10
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    NSLog(@"%@",params);
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MerChant/GetCommentDetail",Khttp] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            NSLog(@"%@",dict);
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            for (NSDictionary *dict in arr) {
                QWMerComListModel *comlistmodel=[[QWMerComListModel alloc]initWithDictionary:dict error:nil];
                [self.MerComList addObject:comlistmodel];
            }
            [self.MerchantCommentListData addObjectsFromArray:arr];
            [_commentListView.mj_header endRefreshing];
            [_commentListView reloadData];
        }
        else
        {
            [self.view showInfo:@"商家评论信息获取失败" autoHidden:YES interval:2];
            [_commentListView.mj_header endRefreshing];
        }
        
        
        
        
    } fail:^(NSError *error) {
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [_commentListView.mj_header endRefreshing];
    }];

}

-(void)GetCommentDetailmore
{
    NSDictionary *mulDic = @{
                             @"MerCode":[NSString stringWithFormat:@"%d",[self.dic[@"MerCode"] intValue]],
                             @"PageIndex":[NSString stringWithFormat:@"%ld",self.page],
                             @"PageSize":@10
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MerChant/GetCommentDetail",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            NSLog(@"%@",dict);
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            if(arr.count == 0)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.removeFromSuperViewOnHide =YES;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"无更多数据";
                hud.minSize = CGSizeMake(132.f, 108.0f);
                [hud hide:YES afterDelay:3];
                [_commentListView.mj_footer endRefreshing];
                self.page--;
            }
            else
            {
                for (NSDictionary *dict in arr) {
                    QWMerComListModel *comlistmodel=[[QWMerComListModel alloc]initWithDictionary:dict error:nil];
                    [self.MerComList addObject:comlistmodel];
                }
                [self.MerchantCommentListData addObjectsFromArray:arr];
                [_commentListView.mj_footer endRefreshing];
                [_commentListView reloadData];
            }
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"无更多数据";
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hide:YES afterDelay:3];
            [_commentListView.mj_footer endRefreshing];
            self.page--;
        }
        
        
        
        
    } fail:^(NSError *error) {
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [_commentListView.mj_header endRefreshing];
        self.page--;
    }];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.MerchantCommentListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessEstimateCell *commentCell = [tableView dequeueReusableCellWithIdentifier:id_commentShopCell forIndexPath:indexPath];
    
    if (self.MerComList.count!=0) {
        NSLog(@"-------%@====%@====-----",self.MerComList[indexPath.row],self.MerchantCommentListData[indexPath.row]);
        QWMerComListModel *comlistmodel=self.MerComList[indexPath.row];
        commentCell.model =comlistmodel;
    }
    
    
    return commentCell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *commentTitleLabel = [[UILabel alloc] init];
    commentTitleLabel.text = [NSString stringWithFormat:@"  评论(%ld)",[self.MerchantCommentListData count]];
    commentTitleLabel.backgroundColor = [UIColor whiteColor];
    commentTitleLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    commentTitleLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    
    return commentTitleLabel;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40*Main_Screen_Height/667;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.MerchantCommentListData.count == 0)
    {
        return 0;
    }
    else
    {
         return 120*Main_Screen_Height/667;
//           QWMerComListModel *comlistmodel=self.MerComList[indexPath.row];
//        return [self.commentListView cellHeightForIndexPath:indexPath model:comlistmodel keyPath:@"model" cellClass:[BusinessEstimateCell class] contentViewWidth:[self cellContentViewWith]]+23*Main_Screen_Height/667;
    }
//    return 126*Main_Screen_Height/667;

}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma mark - 无数据占位
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"pinglun_kongbai"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"pinglun_kongbai"];
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
    NSString *text = @"暂无评价";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor colorFromHex:@"#4a4a4a"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//设置占位图空白页的背景色( 图片优先级高于文字)

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
}

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
    return -64.f;
}
@end
