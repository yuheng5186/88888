//
//  ShopViewController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopIntroController.h"
#import "ShopCommentController.h"
#import <Masonry.h>
#import "ShopCategoryView.h"


@interface ShopViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) UIScrollView *shopScrollView;

@property (nonatomic, weak) ShopCategoryView *categoryView;

@end

@implementation ShopViewController

- (void)drawNavigation {
    
    [self drawTitle:self.dic[@"MerName"]];
    
}

- (void) drawContent
{
    
    self.contentView.height             = self.view.height;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCategoryView];
    [self setupScrollView];
    
    [self addChildViewControllers];
    
    
}

- (void)addChildViewControllers{
    
    //门店简介
    ShopIntroController *introController = [[ShopIntroController alloc] init];
    introController.dic = self.dic;
    [self addChildViewController:introController];
    
    //门店评价
    ShopCommentController *commentController = [[ShopCommentController alloc] init];
    commentController.dic=self.dic;
    [self addChildViewController:commentController];
    
    [_containerView addSubview:introController.view];
    [_containerView addSubview:commentController.view];
    
    [introController didMoveToParentViewController:self];
    [commentController didMoveToParentViewController:self];
    
    [introController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(_containerView);
        make.size.equalTo(_shopScrollView);
    }];
    
    [commentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView);
        make.leading.equalTo(introController.view.mas_trailing);
        make.size.equalTo(_shopScrollView);
    }];
}



//设置分类视图
- (void)setupCategoryView {
    
    ShopCategoryView *categoryView = [[ShopCategoryView alloc] init];
    categoryView.backgroundColor    = [UIColor whiteColor];
    _categoryView = categoryView;
    
    [self.view addSubview:categoryView];
    
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(64);
        make.height.mas_equalTo(44*Main_Screen_Height/667);
    }];
    
    //给block赋值
    categoryView.categoryBlock = ^(NSInteger index){
        
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
        make.top.equalTo(_categoryView.mas_bottom).mas_offset(1);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    
    //容器视图
    UIView *containerView = [[UIView alloc] init];
    _containerView = containerView;
    containerView.backgroundColor =[UIColor colorWithHex:0xf0f0f0];
    
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
        _categoryView.offsetX = offsetX;
    }
}


- (void)viewDidLayoutSubviews {
    
    if (self.isComment) {
        
        [self.categoryView.buttonArray[1] sendActionsForControlEvents:UIControlEventTouchUpInside];

    }
//    else
//    {
//        [self.categoryView.buttonArray[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
//    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
