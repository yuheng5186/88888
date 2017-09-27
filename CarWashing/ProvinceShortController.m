//
//  ProvinceShortController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/11.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ProvinceShortController.h"

@interface ProvinceShortController ()

@property (nonatomic, weak) UIView *containView;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ProvinceShortController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *dissmissBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    dissmissBtn.alpha = 0.5f;
    dissmissBtn.backgroundColor = [UIColor blackColor];
    
    [dissmissBtn addTarget:self action:@selector(clickDissmissButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dissmissBtn];
    
    UIView *containView = [[UIView alloc] init];
    containView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 195*Main_Screen_Height/667);
    containView.backgroundColor = [UIColor whiteColor];
    self.containView = containView;
    [self.view addSubview:containView];
    
    [self addProvinceButton];
}

- (void)addProvinceButton {
    
    NSArray *titleArray = @[@"沪",@"京",@"津",@"渝",@"冀",@"豫",@"云",@"辽",@"黑",@"湘",@"鲁",@"新",@"苏",@"浙",@"赣",@"鄂",@"桂",@"甘",@"晋",@"蒙",@"陕",@"吉",@"闽",@"粤",@"贵",@"青",@"藏",@"川",@"宁",@"琼"];
    _titleArray = titleArray;
    
    for (int i = 0 ; i < titleArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [self.containView addSubview:btn];
        
        [btn setTitle:titleArray[btn.tag] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorFromHex:@"#868686"];
        [btn addTarget:self action:@selector(clickProvinceButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        NSInteger row = i / 8;
        NSInteger col = i % 8;
        
        //间距
        CGFloat margin = (Main_Screen_Width - (30*Main_Screen_Height/667 * 8)) / (8 + 1);
        
        //x
        CGFloat btnX = margin + (30*Main_Screen_Height/667 + margin) * col;
        CGFloat btnY = margin + (30*Main_Screen_Height/667 + margin) * row;
        
        btn.frame = CGRectMake(btnX, btnY, 30*Main_Screen_Height/667, 30*Main_Screen_Height/667);
    }
}

//传回省份简称
- (void)clickProvinceButton:(UIButton *)provinceBtn {
    
    if (_provinceBlock) {
        
        _provinceBlock(_titleArray[provinceBtn.tag]);
    }
    
    //更改视图
    self.containView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 195*Main_Screen_Height/667);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
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
