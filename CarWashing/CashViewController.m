//
//  CashViewController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "CashViewController.h"
#import "TicketCashView.h"

@interface CashViewController ()

@property (nonatomic, weak) UIView *containView;

@end

@implementation CashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *dissmissBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    dissmissBtn.alpha = 0.5f;
    dissmissBtn.backgroundColor = [UIColor blackColor];
    
    [dissmissBtn addTarget:self action:@selector(clickDissmissButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dissmissBtn];
    
    TicketCashView *containView = [TicketCashView ticketCashView];
    containView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 195*Main_Screen_Height/667);
    //containView.backgroundColor = [UIColor blueColor];
    self.containView = containView;
    
    [self.view addSubview:containView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //更改视图
    self.containView.frame = CGRectMake(0, Main_Screen_Height - 195*Main_Screen_Height/667, Main_Screen_Width, 195*Main_Screen_Height/667);
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)clickDissmissButton{
    
    //更改视图
    self.containView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 195*Main_Screen_Height/667);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
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
