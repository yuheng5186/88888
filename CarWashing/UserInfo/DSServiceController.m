//
//  DSServiceController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSServiceController.h"
#import "HQSliderView.h"
#import <Masonry.h>
#import "ProblemTitleModel.h"
#import "AnswerModel.h"
#import "HeadView.h"
#import "AnswerCell.h"

@interface DSServiceController ()<UITableViewDelegate, UITableViewDataSource, HQSliderViewDelegate, HeadViewDelegate>


@property (nonatomic, weak) UITableView *serviceListView;

@property (nonatomic, weak) HQSliderView *serviceSliderView;

/** 记录点击的是第几个Button */
@property (nonatomic, assign) NSInteger serviceTag;

@property (nonatomic, strong) NSMutableArray *answersArray;
@property (nonatomic, assign) CGSize textSize;

@end

@implementation DSServiceController

- (NSMutableArray *)answersArray{
    if (_answersArray == nil) {
        self.answersArray = [NSMutableArray array];
    }
    return _answersArray;
}

- (void)drawNavigation {
    
    [self drawTitle:@"客服"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serviceTag = 0;
    
    [self setupUI];
    
    [self loadData];
}


#pragma mark 加载数据
- (void)loadData
{
    //   problemCenter.plist     problemCar.plist   ProblemUse.plist
    
    NSURL *url;
        if (self.serviceTag == 0) {
            url = [[NSBundle mainBundle] URLForResource:@"problemCenter.plist" withExtension:nil];

        }else if (self.serviceTag == 1){
            url = [[NSBundle mainBundle] URLForResource:@"problemCar.plist" withExtension:nil];
        }else{
            url = [[NSBundle mainBundle] URLForResource:@"ProblemUse.plist" withExtension:nil];
        }
    
    
    NSArray *tempArray = [NSArray arrayWithContentsOfURL:url];
    
    self.answersArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        ProblemTitleModel *titleGroup = [ProblemTitleModel friendGroupWithDict:dict];
        [self.answersArray addObject:titleGroup];
    }
    
}


- (void)setupUI {
    
    [self setupTopServiceSliderView];
    
    UITableView *serviceListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65 + 44*Main_Screen_Height/667, Main_Screen_Width, Main_Screen_Height - 64 - (44+51)*Main_Screen_Height/667)];
    serviceListView.delegate = self;
    serviceListView.dataSource = self;
    serviceListView.backgroundColor     = [UIColor clearColor];
    [self.view addSubview:serviceListView];
    self.serviceListView = serviceListView;
    self.serviceListView.sectionHeaderHeight = 50*Main_Screen_Height/667;
    self.serviceListView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //底部电话客服
    UIView *bottomPhoneView = [[UIView alloc] init];
    bottomPhoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomPhoneView];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorFromHex:@"#e6e6e6"];
    [self.view addSubview:lineView];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.backgroundColor = [UIColor whiteColor];
    [phoneBtn setTitle:@"电话客服" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor colorFromHex:@"#4a4a4a"] forState:UIControlStateNormal];
   
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    [phoneBtn setImage:[UIImage imageNamed:@"djjdianhua"] forState:UIControlStateNormal];
    [bottomPhoneView addSubview:phoneBtn];
    
//    [serviceListView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_serviceSliderView.mas_bottom);
//        make.width.mas_equalTo(Main_Screen_Width);
//    }];
    
    [bottomPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50*Main_Screen_Height/667);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomPhoneView.mas_top);
        make.width.mas_equalTo(Main_Screen_Width);
        make.height.mas_equalTo(1*Main_Screen_Height/667);
    }];
    
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomPhoneView);
        make.width.mas_equalTo(100*Main_Screen_Height/667);
        make.height.mas_equalTo(50*Main_Screen_Height/667);
    }];
    
    phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10*Main_Screen_Height/667, 0, 0)];
    
    [phoneBtn addTarget:self action:@selector(showAlertWithMessage:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)showAlertWithMessage:(NSString *)message{
    
    [PhoneHelper dial: @"053258698831"];
}


#pragma mark - 创建上部的SliderView
- (void)setupTopServiceSliderView {
    
    HQSliderView *serviceSliderView = [[HQSliderView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 44*Main_Screen_Height/667)];
    _serviceSliderView = serviceSliderView;
    serviceSliderView.backgroundColor   = [UIColor whiteColor];
    serviceSliderView.titleArr = @[@"常见问题",@"车型疑问",@"APP使用"];
    serviceSliderView.delegate = self;
    [self.view addSubview:serviceSliderView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.answersArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (self.serviceTag == 0) {
    //        return 8;
    //    }else if (self.serviceTag == 1){
    //        return 3;
    //    }else{
    //        return 7;
    //    }
    ProblemTitleModel *titleGroup = self.answersArray[section];
    NSInteger count = titleGroup.isOpened ? titleGroup.infor.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *id_serviceCell = @"id_serviceCell";
    
    AnswerCell * serviceCell = [tableView dequeueReusableCellWithIdentifier:id_serviceCell];
    if (!serviceCell) {
        serviceCell = [[[NSBundle mainBundle] loadNibNamed:@"AnswerCell" owner:self options:nil] lastObject];
    }
    serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ProblemTitleModel *titleGroup = self.answersArray[indexPath.section];
    AnswerModel *answerModel = titleGroup.infor[indexPath.row];
    
    serviceCell.textViewLabel.text = answerModel.answer;
    
    self.textSize = [self getLabelSizeFortextFont:[UIFont systemFontOfSize:15] textLabel:answerModel.answer];
    
    
    //    if (serviceCell == nil) {
    //        serviceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id_serviceCell];
    //    }
    //
    //    if (self.serviceTag == 0) {
    //        serviceCell.textLabel.text = [NSString stringWithFormat:@"全部 --- 第%ld行", indexPath.row];
    //    } else if (self.serviceTag == 1) {
    //        serviceCell.textLabel.text = [NSString stringWithFormat:@"待付款 --- 第%ld行", indexPath.row];
    //    }  else{
    //        serviceCell.textLabel.text = [NSString stringWithFormat:@"待评价 --- 第%ld行", indexPath.row];
    //    }
//    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    return serviceCell;
}

//-(void)viewDidLayoutSubviews
//{
//    if ([serviceListView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [serviceListView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//    
//    if ([serviceListView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [serviceListView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.textSize.height+20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];
    
    headView.delegate = self;
    headView.titleGroup = self.answersArray[section];
    headView.contentView.backgroundColor    = [UIColor whiteColor];
    return headView;
}

- (void)clickHeadView
{
    [self.serviceListView reloadData];
}


- (CGSize)getLabelSizeFortextFont:(UIFont *)font textLabel:(NSString *)text{
    NSDictionary * totalMoneydic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize totalMoneySize =[text boundingRectWithSize:CGSizeMake(Main_Screen_Width-16,2000) options:NSStringDrawingUsesLineFragmentOrigin  attributes:totalMoneydic context:nil].size;
    return totalMoneySize;
}


#pragma mark - 实现HQSliderView的代理
- (void)sliderView:(HQSliderView *)sliderView didClickMenuButton:(UIButton *)button{
    
    self.serviceTag = button.tag;
    [self loadData];
    [self.serviceListView reloadData];
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
