//
//  ChooseInsurenceViewController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/11/13.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ChooseInsurenceViewController.h"

@interface ChooseInsurenceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UIView *fakeNavigation;
@property(strong,nonatomic)UITableView *licenseTypeTableView;
@property(strong,nonatomic)NSArray *licenseTypeArray;
@end

@implementation ChooseInsurenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.licenseTypeArray = @[@"中国人寿财产保险",@"平安保险",@"太平洋保险",@"中华联合",@"大地保险",@"华安保险",@"天安保险",@"大众保险",@"永安保险",@"太平保险",@"华泰保险",@"安邦保险",@"阳光保险",@"永城保险",@"中银保险",@"都邦保险",@"渤海保险",@"民安保险",@"中国人民保险",@"安盛保险"];
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
-(UIView *)fakeNavigation{
    if (!_fakeNavigation) {
        _fakeNavigation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
        _fakeNavigation.backgroundColor = [UIColor colorWithRed:13/255.0 green:98/255.0 blue:159/255.0 alpha:1];
        
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sendString = self.licenseTypeArray[indexPath.row];
    self.deliverBlock(sendString);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
