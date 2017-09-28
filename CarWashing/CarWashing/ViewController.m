//
//  ViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/18.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof (self)weakSelf = self;

    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view2];
    
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.width.equalTo(weakSelf.view.mas_width).multipliedBy(0.5);
        make.height.equalTo(weakSelf.view.mas_height).multipliedBy(0.5);
        
        
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(view1);
        make.top.equalTo(view1.mas_top);
        make.leading.equalTo(view1.mas_trailing);
//        make.trailing.equalTo(weakSelf.view);

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
