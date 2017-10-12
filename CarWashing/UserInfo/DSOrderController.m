//
//  DSOrderController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSOrderController.h"
#import "OrderCategoryView.h"
#import "AllOrderController.h"
#import "PayOrderController.h"
#import "CommentOrderController.h"
#import <Masonry.h>


@interface DSOrderController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) UIScrollView *orderScrollView;

@property (nonatomic, weak) OrderCategoryView *categoryView;


@end

@implementation DSOrderController

- (void)drawNavigation {
    
    [self drawTitle:@"全部订单"];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)setupUI {
    
    [self setupCategoryView];
    [self setupScrollView];
    
    [self addOrderChildViewControllers];
    
    
}

- (void)addOrderChildViewControllers {
    
    AllOrderController *allVC = [[AllOrderController alloc] init];
    PayOrderController *payVC = [[PayOrderController alloc] init];
    CommentOrderController *commentVC = [[CommentOrderController alloc] init];
    
    [self addChildViewController:allVC];
    [self addChildViewController:payVC];
    [self addChildViewController:commentVC];
    
    [_containerView addSubview:allVC.view];
    [_containerView addSubview:payVC.view];
    [_containerView addSubview:commentVC.view];
    
    [allVC didMoveToParentViewController:self];
    [payVC didMoveToParentViewController:self];
    [commentVC didMoveToParentViewController:self];
    
    
    [allVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.equalTo(_containerView);
        make.size.equalTo(_orderScrollView);
    }];
    
    [payVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_containerView);
        make.leading.equalTo(allVC.view.mas_trailing);
        make.size.equalTo(_orderScrollView);
    }];
    
    [commentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_containerView);
        make.leading.equalTo(payVC.view.mas_trailing);
        make.size.equalTo(_orderScrollView);
    }];
}



#pragma mark - 设置分类视图
- (void)setupCategoryView{
    
    OrderCategoryView *categoryView = [[OrderCategoryView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 44)];
    
    _categoryView = categoryView;
    
    [self.view addSubview:categoryView];
    
    categoryView.categoryBlock = ^(NSInteger index){
        
        //修改scrollView的contentOffset
        [self.orderScrollView setContentOffset:CGPointMake(index * self.orderScrollView.width, 0) animated:YES];
    };
}



#pragma mark - 布局scrollView
- (void)setupScrollView {
    
    
    
    UIScrollView *orderScrollView =  [[UIScrollView alloc] init];
    _orderScrollView = orderScrollView;
    
    orderScrollView.delegate = self;
    orderScrollView.bounces = NO;
    orderScrollView.pagingEnabled = YES;
    
    [self.view addSubview:orderScrollView];
    
    [orderScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_categoryView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    
    //容器视图
    UIView *containerView = [[UIView alloc] init];
    _containerView = containerView;
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    [orderScrollView addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(orderScrollView);
        make.width.equalTo(orderScrollView).multipliedBy(3);
        make.height.equalTo(orderScrollView);
    }];
    
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating) {
        CGFloat offsetX = scrollView.contentOffset.x / 3;
        _categoryView.offsetX = offsetX;
    }
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
