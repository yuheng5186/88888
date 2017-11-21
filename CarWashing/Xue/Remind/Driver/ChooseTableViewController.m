//
//  ChooseTableViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/13.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ChooseTableViewController.h"

@interface ChooseTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UIImageView *fakeNavigation;
@property(strong,nonatomic)UITableView *licenseTypeTableView;
@property(strong,nonatomic)NSArray *licenseTypeArray;
@end

@implementation ChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.licenseTypeArray = @[@"A1",@"A2",@"A3",@"B1",@"B2",@"C1",@"C2",@"C3",@"C4",@"C5"];
    [self.view addSubview:self.fakeNavigation];
    [self.view addSubview:self.licenseTypeTableView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)cancleAction{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 懒加载
-(UIImageView *)fakeNavigation{
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
        _fakeNavigation.image = [UIImage imageNamed:@"ijanbiantiao"];
        _fakeNavigation.userInteractionEnabled = YES;
        
        UILabel *fakeTitle = [[UILabel alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100, 26, 200, 30)];
        fakeTitle.text = @"选择驾照类型";
        fakeTitle.font = [UIFont systemFontOfSize:18 weight:18];
        fakeTitle.textColor = [UIColor whiteColor];
        fakeTitle.textAlignment = NSTextAlignmentCenter;
        [_fakeNavigation addSubview:fakeTitle];
        
        //取消按钮
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 26, 66, 30)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [backButton addTarget:self action:@selector(cancleAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_fakeNavigation addSubview:backButton];
        
        
    }
    return _fakeNavigation;
}

#pragma mark - 懒加载TableView
-(UITableView *)licenseTypeTableView{
    if (!_licenseTypeTableView) {
        _licenseTypeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, Main_Screen_Width, Main_Screen_Height-66) style:(UITableViewStylePlain)];
        _licenseTypeTableView.delegate = self;
        _licenseTypeTableView.dataSource = self;

    }
    return _licenseTypeTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _licenseTypeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _licenseTypeArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *typeString = self.licenseTypeArray[indexPath.row];
//    NSLog(@"传回%@",typeString);
    //2.调用闭包传回值
    self.deliverBlock(typeString);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
