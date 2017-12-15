//
//  BusinessViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/19.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "BusinessViewController.h"
#import "SalerListViewCell.h"
#import "YZPullDownMenu.h"
#import "YZMenuButton.h"
#import "YZSortViewController.h"
#import "YZAllCourseViewController.h"
#import "JPCityViewController.h"
#import "BusinessDetailViewController.h"
#import "QWMclistTableViewCell.h"

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "HTTPDefine.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"

#import "CoreLocation/CoreLocation.h"
#import "UIScrollView+EmptyDataSet.h"//第三方空白页


@interface BusinessViewController ()<UITableViewDelegate, UITableViewDataSource,YZPullDownMenuDataSource,CLLocationManagerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    
}

@property (nonatomic, weak) UITableView *salerListView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSMutableDictionary *pramsDic;

@property (nonatomic, strong) NSMutableArray *MerchantData;

@property (nonatomic,strong) NSMutableArray *otherArray;

@property (nonatomic)NSInteger page;

@property (nonatomic)NSInteger weiyi;

@property (nonatomic,strong) NSString *areastr;
@property (nonatomic,strong) NSString *citystr;
@end

static NSString *id_salerListCell = @"salerListViewCell";

@implementation BusinessViewController


- (UITableView *)salerListView {
    if (nil == _salerListView) {
        
        UITableView *salerListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + Main_Screen_Height*44/667, Main_Screen_Width, Main_Screen_Height-64 - Main_Screen_Height*44/667-49)];
        salerListView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _salerListView = salerListView;

        [self.view addSubview:salerListView];
        
    }
    return _salerListView;
}
- (void) drawNavigation {

    [self drawTitle:@"商家"];

}
- (void) drawContent {
    
    self.statusView.hidden      = NO;
    
    self.navigationView.hidden  = NO;
    self.contentView.top        = 0;
    self.contentView.height     = self.view.height;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.areastr=@" ";
    self.citystr=@" ";
    [self setSearchMenu];
    
    
    
    
    
    self.pramsDic = [[NSMutableDictionary alloc]init];
    NSArray *array1 = [[NSArray alloc] initWithObjects:[UdStorage getObjectforKey:@"City"],[UdStorage getObjectforKey:@"Quyu"], nil];
    NSDictionary *dic = @{@"0":array1,@"1":@"全部",@"2":@"默认排序"};
    self.pramsDic  = [NSMutableDictionary dictionaryWithDictionary:dic];
    self.MerchantData = [[NSMutableArray alloc]init];
     self.page = 0;
   
   self.weiyi = 0;
   
    self.otherArray = [[NSMutableArray alloc]init];
    
    
    
    //    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //    [center addObserver:self selector:@selector(noticeupdatexuanze:) name:YZUpdateMenuTitleNote object:nil];
    
    
    NSNotificationCenter *observer = [[NSNotificationCenter defaultCenter] addObserverForName:YZUpdateMenuTitleNote object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        // 获取列
        NSInteger col = [self.childViewControllers indexOfObject:note.object];
       if (col==0) {
          self.citystr=[[self.pramsDic objectForKey:@"0"] objectAtIndex:0];
           self.areastr=[[self.pramsDic objectForKey:@"0"] objectAtIndex:1];//区域
       }
        // 获取所有值
        NSArray *allValues = note.userInfo.allValues;
       NSLog(@"%@",allValues);
        // 不需要设置标题,字典个数大于1，或者有数组
        if (allValues.count > 1 || [allValues.firstObject isKindOfClass:[NSArray class]]) return ;
        
        NSString *str = allValues.firstObject;
        if ([str containsString:@":"]) {
            NSArray *array = [allValues.firstObject componentsSeparatedByString:@":"];
            // 设置按钮标题
            NSLog(@"%@===%@",array,[NSString stringWithFormat:@"%ld",(long)col]);
           self.citystr=array[0];
           self.areastr=array[1];
            [self.pramsDic setValue:array forKey:[NSString stringWithFormat:@"%ld",(long)col]];
        } else {
            // 设置按钮标题
           NSLog(@"%@===%@",allValues.firstObject,[NSString stringWithFormat:@"%ld",(long)col]);
            [self.pramsDic setValue:allValues.firstObject forKey:[NSString stringWithFormat:@"%ld",(long)col]];
        }
      
       
        [self.salerListView.mj_header beginRefreshing];
//        [self headerRereshing];
        
        
        
    }];

    
    
    [self setupUI];
    
    
    
    

}


- (void)setupUI {
    
//    UIView *titleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, 64) color:[UIColor colorFromHex:@"#0161a1"]];
//    titleView.top                      = 0;
//    
//    NSString *titleName              = @"商家";
//    UIFont *titleNameFont            = [UIFont boldSystemFontOfSize:18];
//    UILabel *titleNameLabel          = [UIUtil drawLabelInView:titleView frame:[UIUtil textRect:titleName font:titleNameFont] font:titleNameFont text:titleName isCenter:NO];
//    titleNameLabel.textColor         = [UIColor whiteColor];
//    titleNameLabel.centerX           = titleView.centerX;
//    titleNameLabel.centerY           = titleView.centerY +8;
    
    //
    self.salerListView.delegate = self;
    self.salerListView.dataSource = self;
    self.salerListView.emptyDataSetSource=self;
    self.salerListView.emptyDataSetDelegate=self;
    self.salerListView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //去掉分割线
//    self.salerListView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
    [self setupRefresh];

}

-(void)setupRefresh
{
    self.salerListView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
        [self headerRereshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.salerListView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.salerListView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.salerListView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
        [self footerRereshing];
        
    }];
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
//
        self.page = 0 ;
        [self setData];
        
    });
}

- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
            self.page++;
            _otherArray = [NSMutableArray new];
            [self setDatamore];
            
        
//
//        
//        
//        
//        // 刷新表格
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
    });
}


#pragma mark - 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.MerchantData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *lab = [[[self.MerchantData objectAtIndex:indexPath.row]objectForKey:@"MerFlag"] componentsSeparatedByString:@","];
    if([[self.MerchantData objectAtIndex:indexPath.row]objectForKey:@"MerFlag"])
    {
        if([lab count] <= 3)
        {
            return 110*Main_Screen_Height/667;
        }
        else if(([lab count] > 3) && ([lab count] <= 6))
        {
            return 125*Main_Screen_Height/667;
        }
        else
        {
            return 140*Main_Screen_Height/667;
        }
        
    }
    else
        return 110*Main_Screen_Height/667;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"Cell";
    [tableView registerClass:[QWMclistTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    QWMclistTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[QWMclistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    [cell setlayoutCell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic=[self.MerchantData objectAtIndex:indexPath.row];
    [cell setUpCellWithDic:dic];
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转商家详情
    BusinessDetailViewController *detailController = [[BusinessDetailViewController alloc] init];
    detailController.hidesBottomBarWhenPushed      = YES;
    detailController.MerCode                       = [[[self.MerchantData objectAtIndex:indexPath.row] objectForKey:@"MerCode"] integerValue];
    detailController.distance                      = [[self.MerchantData objectAtIndex:indexPath.row] objectForKey:@"Distance"];
    [self.navigationController pushViewController:detailController animated:YES];
}




#pragma mark - 搜索下拉
- (void)setSearchMenu {
    
    // 创建下拉菜单
    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height*44/667);
    [self.view addSubview:menu];
    
    
    // 设置下拉菜单代理
    menu.dataSource = self;
    
//    NSArray *array1 = [[NSArray alloc] initWithObjects:@"上海市",@"浦东新区", nil];
//    NSDictionary *dic = @{@"0":array1,@"1":@"普洗-5座轿车",@"2":@"默认排序"};
    
    
  
    
    
    // 初始化标题
    _titles = @[[UdStorage getObjectforKey:@"City"],@"全部",@"默认排序"];
    
//    NSLog(@"%@",self.pramsDic);
    
    // 添加子控制器
    [self setupAllChildViewController];
   
   

   
}


#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    JPCityViewController *cityVC = [[JPCityViewController alloc] init];
    YZAllCourseViewController *allCourse = [[YZAllCourseViewController alloc] init];
    YZSortViewController *sort = [[YZSortViewController alloc] init];
    
    [self addChildViewController:cityVC];
    [self addChildViewController:allCourse];
    [self addChildViewController:sort];
    
}

#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return 3;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHex:@"#999999"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHex:@"#999999"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"shangla"] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
    
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if (index == 0) {
        return 270;
    }
    
    // 第2列 高度
    if (index == 1) {
        return 140;
    }
    
    // 第3列 高度
    return 180;
}

-(void)setData
{
    if([self.areastr isEqualToString:@"全部"]){
        self.areastr = @"";
    }
   
   NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"全部",@"车身外部清洗维护",@"车内清洁-5座轿车",@"车内清洁SUV或7座", nil];
   
    NSInteger index = 0;
   
   if ([array containsObject:[self.pramsDic objectForKey:@"1"]]) {
      
      index = [array indexOfObject:[self.pramsDic objectForKey:@"1"]];
//       NSLog(@"----%ld",(long)index);
   }
   
   
   
   
    NSString *DefaultSort;
    
    if([[self.pramsDic objectForKey:@"2"] isEqualToString:@"默认排序"])
    {
        DefaultSort = @"1";
    }
    else if([[self.pramsDic objectForKey:@"2"] isEqualToString:@"附近优先"])
    {
        DefaultSort = @"2";
    }
    else if([[self.pramsDic objectForKey:@"2"] isEqualToString:@"评分最高"])
    {
        DefaultSort = @"3";
    }
    else
    {
        DefaultSort = @"4";
    }
    
//    [[self.pramsDic objectForKey:@"0"] objectAtIndex:0]
    //[NSString stringWithFormat:@"10%ld",index+1]
    NSDictionary *mulDic = @{
                             @"City":self.citystr,
                             @"Area":self.areastr,
                             @"ShopType":@1,
                             @"ServiceCode":[NSString stringWithFormat:@"%ld",(long)index],
                             @"DefaultSort":DefaultSort,
                             @"Ym":[UdStorage getObjectforKey:@"Ym"],
                             @"Xm":[UdStorage getObjectforKey:@"Xm"],
                             @"PageIndex":@0,
                             @"PageSize":@10
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MerChant/GetStoreList",Khttp] success:^(NSDictionary *dict, BOOL success) {
//       NSLog(@"%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            [self.MerchantData removeAllObjects];
            
            
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            if(arr.count == 0)
            {
//                [self.view showInfo:@"暂无更多数据" autoHidden:YES interval:2];
                [self.salerListView reloadData];
                [self.salerListView.mj_header endRefreshing];
            }
            else
            {
                [self.MerchantData addObjectsFromArray:arr];
                [self.salerListView reloadData];
                [self.salerListView.mj_header endRefreshing];
            }
            
        }
        else
        {
            [self.view showInfo:@"数据请求失败" autoHidden:YES interval:2];
            [self.salerListView.mj_header endRefreshing];
        }
        
    } fail:^(NSError *error) {
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [self.salerListView.mj_header endRefreshing];
    }];

}

-(void)setDatamore
{
   
   NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"全部",@"车身外部清洗维护",@"车内清洁-5座轿车",@"车内清洁SUV或7座", nil];
   
   NSInteger index;
   
   if ([array containsObject:[self.pramsDic objectForKey:@"1"]]) {
      
      index = [array indexOfObject:[self.pramsDic objectForKey:@"1"]];
      
   }
   
    NSString *DefaultSort;
    
    if([[self.pramsDic objectForKey:@"2"] isEqualToString:@"默认排序"])
    {
        DefaultSort = @"1";
    }
    else if([[self.pramsDic objectForKey:@"2"] isEqualToString:@"附近优先"])
    {
        DefaultSort = @"2";
    }
    else if([[self.pramsDic objectForKey:@"2"] isEqualToString:@"评分最高"])
    {
        DefaultSort = @"3";
    }
    else
    {
        DefaultSort = @"4";
    }
    
//    [[self.pramsDic objectForKey:@"0"] objectAtIndex:0]
    NSDictionary *mulDic = @{
                             @"City":self.citystr,
                             @"Area":self.areastr,
                             @"ShopType":@1,
                             @"ServiceCode":[NSString stringWithFormat:@"10%ld",index+1],
                             @"DefaultSort":DefaultSort,
                             @"Ym":[UdStorage getObjectforKey:@"Ym"],
                             @"Xm":[UdStorage getObjectforKey:@"Xm"],
                             @"PageIndex":[NSString stringWithFormat:@"%ld",self.page],
                             @"PageSize":@10
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MerChant/GetStoreList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
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
                [self.salerListView.mj_footer endRefreshing];
                self.page--;
            }
            else
            {
                [self.MerchantData addObjectsFromArray:arr];
                [self.salerListView reloadData];
                [self.salerListView.mj_footer endRefreshing];
                
            }
            
        }
        else
        {
            [self.view showInfo:@"数据请求失败" autoHidden:YES interval:2];
            [self.salerListView.mj_footer endRefreshing];
            self.page--;
        }
        
    } fail:^(NSError *error) {
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [self.salerListView.mj_footer endRefreshing];
        self.page--;
    }];
    
}


//-(void)noticeupdatexuanze:(NSNotification *)sender{
//    NSInteger col = [self.childViewControllers indexOfObject:sender.object];
//    
//    // 获取所有值
//    NSArray *allValues = note.userInfo.allValues;
//    
//    // 不需要设置标题,字典个数大于1，或者有数组
//    if (allValues.count > 1 || [allValues.firstObject isKindOfClass:[NSArray class]]) return ;
//    
//    
//    
//    [self.pramsDic setValue:allValues.firstObject forKey:[NSString stringWithFormat:@"%ld",(long)col]];
//    
//    [self setData];
//}

-(void)viewWillAppear:(BOOL)animated
{
//    [self setSearchMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 无数据占位
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"Store"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @""];
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
    NSString *text = @"暂时还没有商家信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor colorFromHex: @"#4a4a4a"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//设置占位图空白页的背景色( 图片优先级高于文字)

//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
//}
////设置按钮的文本和按钮的背景图片
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state  {
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
//    return [[NSAttributedString alloc] initWithString:@"马上去洗车" attributes:attributes];
//}
//-(UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
////    return [UIImage imageNamed:@"qxiche"];
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
//   self.weiyi ++ ;
//   if(self.weiyi == 1)
//   {
//      return -64.f;
//   }
//   if(self.weiyi == 2)
//   {
//      return -64.f;
//   }
//   else
//   {
      return 0.f;
//   }
}


@end
