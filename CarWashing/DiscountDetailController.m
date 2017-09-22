//
//  DiscountDetailController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DiscountDetailController.h"
#import "DiscountDetailView.h"

@interface DiscountDetailController ()

@property (nonatomic, weak) DiscountDetailView *detailView;

@end

@implementation DiscountDetailController

- (DiscountDetailView *)detailView {
    
    if (_detailView == nil) {
        
        DiscountDetailView *detailView = [DiscountDetailView discountDetailView];
        
        _detailView = detailView;
        [self.view addSubview:_detailView];
    }
    return _detailView;
}

- (void)drawNavigation {
    
    [self drawTitle:@"优惠券详情"];
}


- (void) drawContent
{
//    self.statusView.backgroundColor     = [UIColor grayColor];
//    self.navigationView.backgroundColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.detailView.frame = CGRectMake(0, 64, Main_Screen_Width, 400*Main_Screen_Height/667);
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
