//
//  UselessViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/24.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "UselessViewController.h"

@interface UselessViewController ()
@property(strong,nonatomic)UIImageView *fakeNavigation;
@end

@implementation UselessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.fakeNavigation];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-150, 150, 300, 300)];
    label.text = @"敬请期待";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView *)fakeNavigation{
    
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
//        _fakeNavigation.image = [UIImage imageNamed:@"cheliangtixingtu"];
        _fakeNavigation.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
        _fakeNavigation.userInteractionEnabled = YES;
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = self.getTitleString;
        fakeTitle.font = [UIFont systemFontOfSize:18 weight:18];
        fakeTitle.textColor = [UIColor whiteColor];
        fakeTitle.textAlignment = NSTextAlignmentCenter;
        [_fakeNavigation addSubview:fakeTitle];
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 32, 19, 19)];
        backImageView.image = [UIImage imageNamed:@"icon_titlebar_arrow"];
        backImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_fakeNavigation addSubview:backImageView];
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 66)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_fakeNavigation addSubview:backButton];
        
        
//        UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-31,30, 19, 19)];
//        buttonImage.image = [UIImage imageNamed:@"bianji"];
//        [_fakeNavigation addSubview:buttonImage];
//        
//        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-66,0, 66, 66)];
//        [editButton addTarget:self action:@selector(editingAction) forControlEvents:(UIControlEventTouchUpInside)];
//        [_fakeNavigation addSubview:editButton];
        
    }
    return _fakeNavigation;
}

-(void)backAction{

    [self.navigationController popViewControllerAnimated:YES];
    
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
