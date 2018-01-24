//
//  DSSaleActivityController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/21.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSSaleActivityController.h"
#import "DSUserRightDetailController.h"
#import "UIScrollView+EmptyDataSet.h"//第三方空白页
#import <Masonry.h>

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "DSSalaActivityCell.h"

@interface DSSaleActivityController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *CouponListData;

@property (nonatomic)NSInteger page;

@property (nonatomic, strong) NSString *area;

@end

static NSString *cellStatic = @"cellStatic";

@implementation DSSaleActivityController

- (void)drawNavigation {
    
    [self drawTitle:@"优惠活动"];
    
}

//- (void) drawContent {
//
//    self.contentView.top                = self.statusView.bottom;
//    self.contentView.backgroundColor    = [UIColor colorFromHex:@"#111112"];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubView];
}
- (void) createSubView {
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width,Main_Screen_Height-64) style:UITableViewStyleGrouped];
//    self.tableView.top              = 0;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.emptyDataSetDelegate=self;
    self.tableView.emptyDataSetSource=self;
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.tableFooterView = [UIView new];
//    self.tableView.tableFooterView = [UIView new];
//    self.tableView.scrollEnabled    = NO;
//    self.tableView.tableFooterView  = [UIView new];
//    self.tableView.tableHeaderView  = [UIView new];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;

    [self.tableView registerClass:[DSSalaActivityCell class] forCellReuseIdentifier:cellStatic];
    
    [self.view addSubview:self.tableView];
    _CouponListData = [[NSMutableArray alloc]init];
     self.area = @"青岛市";
    
    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.removeFromSuperViewOnHide =YES;
//    HUD.mode = MBProgressHUDModeIndeterminate;
//    HUD.labelText = @"加载中";
//    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    
//   [self GetCouponList];
    [self setupRefresh];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)setupRefresh
{
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
        [self headerRereshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
//    // 上拉刷新
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//
//        [self footerRereshing];
//
//    }];
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _CouponListData = [NSMutableArray new];
        
        self.page = 0 ;
        
        [self GetCouponList];
        
    });
}


- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(_CouponListData.count == 0)
        {
            [self GetCouponList];
        }
        else
        {
            self.page++;
//            [self GetCouponListmore];
            
        }
        
        
        
        
        // 刷新表格
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
    });
}

-(void)GetCouponList
{
    NSDictionary *mulDic = @{
                             @"GetCardType":@2,
                             @"Area":self.area
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/GetCardConfigList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            
        {
            [self.tableView.mj_header endRefreshing];
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            [_CouponListData addObjectsFromArray:arr];
            [self.tableView reloadData];
             [HUD setHidden:YES];
        }
        else
        {
            [self.tableView.mj_header endRefreshing];
            [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_CouponListData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*Main_Screen_Height/667;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    return 10.0f*Main_Screen_Height/667;
//}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.01f*Main_Screen_Height/667;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] init];
    
    NSString *title     = [[_CouponListData objectAtIndex:section] objectForKey:@"CreateTime"];
    UIFont *titleFont   = [UIFont systemFontOfSize:14];
    
    UILabel *titleLabel     = [UIUtil drawLabelInView:view frame:CGRectMake(0, 0, Main_Screen_Width*150/375, 40.01f*Main_Screen_Height/667) font:titleFont text:title isCenter:YES];
    titleLabel.centerX  = Main_Screen_Width/2;
    titleLabel.textColor    = [UIColor colorFromHex:@"#999999"];
    [view addSubview:titleLabel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DSSalaActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    }
    cell.backgroundColor    = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *backV = [[UIImageView alloc] init];
    [cell.contentView addSubview:backV];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
    titleLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    [cell.contentView addSubview:titleLab];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    introLab.textColor = [UIColor colorFromHex:@"#999999"];
    [cell.contentView addSubview:introLab];
    
    UIImageView *markV = [[UIImageView alloc] init];
    markV.image = [UIImage imageNamed:@"dianjitiaozhuan"];
    [cell.contentView addSubview:markV];
    
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(cell.contentView);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).mas_offset(28*Main_Screen_Height/667);
        make.top.equalTo(cell.contentView).mas_offset(20*Main_Screen_Height/667);
    }];
    
    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLab);
        make.top.equalTo(titleLab.mas_bottom).mas_offset(12*Main_Screen_Height/667);
    }];
    
    [markV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(introLab);
        make.leading.equalTo(introLab.mas_trailing).mas_offset(20*Main_Screen_Height/667);
    }];
    
    
    NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,[[_CouponListData objectAtIndex:indexPath.section] objectForKey:@"Img"]];
    NSURL *url=[NSURL URLWithString:ImageURL];
    [backV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"yonghuzhuanxiangditu"]];
    
    titleLab.text = [[_CouponListData objectAtIndex:indexPath.section] objectForKey:@"Description"];
    introLab.text = [NSString stringWithFormat:@"免费获得洗车%@一张",[[_CouponListData objectAtIndex:indexPath.section] objectForKey:@"CardName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DSUserRightDetailController *rightController    = [[DSUserRightDetailController alloc]init];
    rightController.hidesBottomBarWhenPushed        = YES;
    rightController.ConfigCode                      = [[_CouponListData objectAtIndex:indexPath.section] objectForKey:@"ConfigCode"];
    [self.navigationController pushViewController:rightController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = Main_Screen_Height*6/667;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, Main_Screen_Width*10/375, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = [UIColor cyanColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
}


#pragma mark - 无数据占位
/**
 *  调整垂直位置
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -64.f;
}

//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"youhuihuodong_kongbai"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"youhuihuodong_kongbai"];
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
    NSString *text = @"活动正在赶来";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
