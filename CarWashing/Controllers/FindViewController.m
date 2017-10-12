//
//  FindViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/19.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "FindViewController.h"
#import "DSSaleActivityController.h"
#import "DSCarClubController.h"
#import "DSCarTravellingController.h"
#import "DSWheelGroupController.h"
#import "ActivityListCell.h"
#import <Masonry.h>

#import "DSActivityModel.h"

@interface FindViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DSSegmentView *segmentView;
@property (nonatomic, weak) UIScrollView *shopScrollView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation FindViewController

- (void) drawNavigation {

    [self drawTitle:@"发现"];
}
- (void) drawContent {
    self.contentView.top        = 0;
    self.contentView.height     = self.view.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray * array = @[
                        @{
                            @"nickName":@"杨芳学",
                            @"graide":@"16",
                            @"content":@"天使天使天使天使天使天使天使天使天使天"
                            },
                        @{
                            @"nickName":@"杨芳学",
                            @"graide":@"16",
                            @"content":@"天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天"
                            },
                        @{
                            @"nickName":@"杨芳学",
                            @"graide":@"16",
                            @"content":@"天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天"
                            },
                        @{
                            @"nickName":@"杨芳学",
                            @"graide":@"16",
                            @"content":@"天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使天使"
                            },
                        ];
    
    
    for (NSDictionary * dict in array) {
        
        DSActivityModel * model = [DSActivityModel modelWithDict:dict];
        
        [self.dataArray addObject:model];
    }
    
    
    
    
    
    
    [self createSubView];
    
    [self setupCategoryView];
    [self setupScrollView];
    
    [self addChildViewControllers];
    
    [self.tableView reloadData];

}

- (void) createSubView {

//    UIView *titleView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*58/667) color:[UIColor whiteColor]];
//    titleView.top                      = 0;
//    
//    NSString *titleName              = @"发现";
//    UIFont *titleNameFont            = [UIFont boldSystemFontOfSize:18];
//    UILabel *titleNameLabel          = [UIUtil drawLabelInView:titleView frame:[UIUtil textRect:titleName font:titleNameFont] font:titleNameFont text:titleName isCenter:NO];
//    titleNameLabel.textColor         = [UIColor blackColor];
//    titleNameLabel.centerX           = titleView.centerX;
//    titleNameLabel.centerY           = titleView.centerY +Main_Screen_Height*10/667;
    
//    UIView *upView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*90/667) color:[UIColor whiteColor]];
//    upView.top                      = titleView.bottom+1;
    
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height) style:UITableViewStylePlain];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.top              = self.contentView.bottom;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityListCell" bundle:nil] forCellReuseIdentifier:@"ActivityListCell"];
    
    self.tableView.rowHeight        = 200;
    
    [self.contentView addSubview:self.tableView];
    

    

}

- (void)addChildViewControllers{
    
    DSCarClubController *carClubController      = [[DSCarClubController alloc]init];
    [self addChildViewController:carClubController];
    
    DSCarTravellingController   *carTravelController    = [[DSCarTravellingController alloc]init];
    [self addChildViewController:carTravelController];
    
    [_containerView addSubview:carClubController.view];
    [_containerView addSubview:carTravelController.view];
    
    [carClubController didMoveToParentViewController:self];
    [carTravelController didMoveToParentViewController:self];
    
    [carClubController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(_containerView);
        make.size.equalTo(_shopScrollView);
    }];
    
    [carTravelController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView);
        make.leading.equalTo(carClubController.view.mas_trailing);
        make.size.equalTo(_shopScrollView);
    }];
}



//设置分类视图
- (void)setupCategoryView {
    
    DSSegmentView *segmentView = [[DSSegmentView alloc] init];
    
    _segmentView = segmentView;
    
    [self.view addSubview:segmentView];
    
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(64);
        make.height.mas_equalTo(44*Main_Screen_Height/667);
    }];
    
    //给block赋值
    segmentView.categoryBlock = ^(NSInteger index){
        
        //修改scrollView的contentOffset
        [self.shopScrollView setContentOffset:CGPointMake(index * self.shopScrollView.width, 0) animated:YES];
    };
    
    
}

#pragma mark - 布局scrollView
- (void)setupScrollView {
    
    UIScrollView *shopScrollView =  [[UIScrollView alloc] init];
    _shopScrollView = shopScrollView;
    
    shopScrollView.delegate = self;
    shopScrollView.bounces = NO;
    shopScrollView.pagingEnabled = YES;
    
    [self.view addSubview:shopScrollView];
    
    [shopScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segmentView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    
    //容器视图
    UIView *containerView = [[UIView alloc] init];
    _containerView = containerView;
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    [shopScrollView addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(shopScrollView);
        make.width.equalTo(shopScrollView).multipliedBy(2);
        make.height.equalTo(shopScrollView);
    }];
    
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating) {
        CGFloat offsetX = scrollView.contentOffset.x / 2;
        _segmentView.offsetX = offsetX;
    }
}
#pragma mark -------tapGesture click------

- (void) tapSaleButtonClick:(id)sender {

    DSSaleActivityController *saleController    = [[DSSaleActivityController alloc]init];
    saleController.hidesBottomBarWhenPushed     = YES;
    [self.navigationController pushViewController:saleController animated:YES];
    
}

- (void) tapCarClubButtonClick:(id)sender {
    DSCarClubController *carClubController      = [[DSCarClubController alloc]init];
    carClubController.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:carClubController animated:YES];
    
}

- (void) tapCarTravelButtonClick:(id)sender {
    DSCarTravellingController   *carTravelController    = [[DSCarTravellingController alloc]init];
    carTravelController.hidesBottomBarWhenPushed        = YES;
    [self.navigationController pushViewController:carTravelController animated:YES];
    
}

- (void) tapWheelButtonClick:(id)sender {
    DSWheelGroupController *wheelController     = [[DSWheelGroupController alloc]init];
    wheelController.hidesBottomBarWhenPushed    = YES;
    [self.navigationController pushViewController:wheelController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark --

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListCell" forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.activityImageView.image    = [UIImage imageNamed:@"faxiantu1"];

    }
    cell.activityImageView.image    = [UIImage imageNamed:@"faxiantu"];
    
    return cell;
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
