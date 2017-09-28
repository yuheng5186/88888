//
//  JPCityViewController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/31.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "JPCityViewController.h"

extern NSString * const YZUpdateMenuTitleNote;
static NSString * const ID_cell = @"cell";
static NSString * const DetailID_cell = @"Detailcell";

@interface JPCityViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSDictionary *titleDic;

@property (nonatomic, weak) UITableView *cityTableView;
/**
 *  城市详情tableView
 */
@property (weak, nonatomic) UITableView *cityDetailTableView;

@property (strong, nonatomic) NSString *selectedCategory;

@end

@implementation JPCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    _titleArray = @[@"青岛市",@"苏州市",@"北京市"];
    _titleArray = @[@"青岛市"];
    NSArray *arr = @[@"市南区",@"市北区",@"李沧区",@"崂山区",@"黄岛区",@"城阳区",@"即墨区",@"胶州市",@"平度市", @"莱西市",@"红岛经济区"];
//    NSArray *arr1 = @[@"工业园区",@"高新区",@"相城区"];
//    NSArray *arr2 = @[@"西城区",@"宣武区",@"东城区",@"皇后区"];
//     _titleDic = @{@"青岛市":arr, @"苏州市":arr1, @"北京市":arr2};
    _titleDic = @{@"青岛市":arr};
    
    UITableView *cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height)];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    cityTableView.contentInset  = UIEdgeInsetsMake(0, 0, 480, 0);
    self.cityTableView = cityTableView;
    [self.view addSubview:cityTableView];
    
    
    UITableView *cityDTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, self.view.bounds.size.height)];
    cityDTableView.delegate = self;
    cityDTableView.dataSource = self;
    cityDTableView.contentInset  = UIEdgeInsetsMake(0, 0, 480, 0);

    self.cityDetailTableView = cityDTableView;
    [self.view addSubview:cityDTableView];
    
    [cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID_cell];
    [cityDTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DetailID_cell];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.cityTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.cityTableView didSelectRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.cityTableView) {
        // 左边的类别表格 👈
        return self.titleArray.count;
        
    } else {
        // 右边的类别详情表格 👉
        return [[self.titleDic objectForKey:_selectedCategory] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.cityTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_cell];
        
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor colorFromHex:@"#999999"];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailID_cell];
    
    cell.textLabel.text = [self.titleDic objectForKey:_selectedCategory][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor colorFromHex:@"#999999"];
   [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.cityTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 左边的类别表格 👈
        _selectedCategory = cell.textLabel.text;
        
        // 刷新右边数据
        [self.cityDetailTableView reloadData];
        
        return;
    }
    
    // 选中当前
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":[NSString stringWithFormat:@"%@:%@",_selectedCategory,cell.textLabel.text]}];
    
    
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
