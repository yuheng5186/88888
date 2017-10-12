//
//  MemberRegualrController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/27.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MemberRegualrController.h"
#import <Masonry.h>
#import "ScoreCategoryView.h"
#import "ScoreIntroController.h"
#import "ScoreGetController.h"

@interface MemberRegualrController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) UIScrollView *scoreScrollView;

@property (nonatomic, weak) ScoreCategoryView *categoryView;

@end

@implementation MemberRegualrController

- (void)drawNavigation{
    
    [self drawTitle:@"积分规则"];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {
    
    [self setupCategoryView];
    [self setupScrollView];
    
    [self addScoreChildViewControllers];
    
}


- (void)addScoreChildViewControllers{
    
    ScoreIntroController *scoreIntroVC = [[ScoreIntroController alloc] init] ;
    ScoreGetController *scoreGetVC = [[ScoreGetController alloc] init];
    
    [self addChildViewController:scoreIntroVC];
    [self addChildViewController:scoreGetVC];
    
    [_containerView addSubview:scoreIntroVC.view];
    [_containerView addSubview:scoreGetVC.view];
    
    [scoreIntroVC didMoveToParentViewController:self];
    [scoreGetVC didMoveToParentViewController:self];
    
    [scoreIntroVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(_containerView);
        make.size.equalTo(_scoreScrollView);
    }];
    
    [scoreGetVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView);
        make.leading.equalTo(scoreIntroVC.view.mas_trailing);
        make.size.equalTo(_scoreScrollView);
    }];
    
}


#pragma mark - 设置分类视图
- (void)setupCategoryView{
    
    ScoreCategoryView *categoryView = [[ScoreCategoryView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 44)];
    
    _categoryView = categoryView;
    
    [self.view addSubview:categoryView];
    
    categoryView.categoryBlock = ^(NSInteger index){
        
        //修改scrollView的contentOffset
    [self.scoreScrollView setContentOffset:CGPointMake(index * self.scoreScrollView.width, 0) animated:YES];
    };
}



#pragma mark - 布局scrollView
- (void)setupScrollView {
    
    
    
    UIScrollView *shopScrollView =  [[UIScrollView alloc] init];
    _scoreScrollView = shopScrollView;
    
    shopScrollView.delegate = self;
    shopScrollView.bounces = NO;
    shopScrollView.pagingEnabled = YES;
    
    [self.view addSubview:shopScrollView];
    
    [shopScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_categoryView.mas_bottom);
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
