//
//  HowToUpGradeController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/16.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "HowToUpGradeController.h"
#import <Masonry.h>
#import "HYSlider.h"
#import "WayToUpGradeCell.h"
#import "EarnScoreController.h"
#import "DSUpdateRuleController.h"
#import "DSMyCarController.h"
#import "DSUserInfoController.h"

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "HTTPDefine.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"


@interface HowToUpGradeController ()<UITableViewDelegate, UITableViewDataSource,HYSliderDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic, weak) UITableView *wayToEarnScoreView;

@property (nonatomic, strong) NSMutableArray *ScoreData;

@end

static NSString *id_wayToUpCell = @"id_wayToUpCell";

@implementation HowToUpGradeController

- (UITableView *)wayToEarnScoreView {
    
    if (!_wayToEarnScoreView) {
        
        UITableView *wayToEarnScoreView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _wayToEarnScoreView = wayToEarnScoreView;
        [self.view addSubview:_wayToEarnScoreView];
    }
    
    return _wayToEarnScoreView;
}


- (void)drawContent {
    
    [self drawTitle:@"升等级"];
    
    [self drawRightTextButton:@"等级规则" action:@selector(didClickRightBarButton)];
}

- (void)didClickRightBarButton {
    
    DSUpdateRuleController *ruleVC = [[DSUpdateRuleController alloc] init];
    ruleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ruleVC animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
//    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)setupUI {
    
    UIView *headContainView = [[UIView alloc] init];
    headContainView.backgroundColor = [UIColor colorFromHex:@"#0161a1"];
    [self.view addSubview:headContainView];
    
    UILabel *gradeLab = [[UILabel alloc] init];
    gradeLab.text = self.currentLevel;
    gradeLab.textColor = [UIColor colorFromHex:@"#ffffff"];
    gradeLab.font = [UIFont boldSystemFontOfSize:15*Main_Screen_Height/667];
    [self.view addSubview:gradeLab];
    
    //滑块
//    HYSlider *slider = [[HYSlider alloc] initWithFrame:CGRectMake(23*Main_Screen_Height/667, 64 + 68*Main_Screen_Height/667, Main_Screen_Width - 46, 4*Main_Screen_Height/667)];
//    slider.currentValueColor = [UIColor redColor];
//    slider.maxValue = 1000;
//    slider.currentSliderValue = 600;
//    slider.showTextColor = [UIColor redColor];
//    slider.showTouchView = YES;
//    slider.showScrollTextView = YES;
//    slider.touchViewColor = [UIColor redColor];
//    [self.view addSubview:slider];
    
    HYSlider *slider = [[HYSlider alloc]initWithFrame:CGRectMake(35, gradeLab.frame.origin.y+gradeLab.frame.size.height+5, Main_Screen_Width-46, 9)];
    slider.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    slider.currentValueColor = [UIColor colorFromHex:@"#febb02"];
    slider.maxValue = [self.NextLevelScore integerValue];
    slider.currentSliderValue =[self.CurrentScore integerValue];
    slider.showTextColor = [UIColor colorFromHex:@"#febb02"];
    slider.showTouchView = YES;
    slider.showScrollTextView = YES;
    slider.touchViewColor = [UIColor colorFromHex:@"#febb02"];
    slider.delegate = self;
#pragma mark-重至slider的imageview宽度
    CGSize imageWidth=[slider.scrollShowTextLabel boundingRectWithSize:CGSizeMake(10000, 17*Main_Screen_Height/667)];
    
    slider.scrollShowTextLabel.frame=CGRectMake(5*Main_Screen_Width/375, 2*Main_Screen_Height/667, imageWidth.width, 17*Main_Screen_Height/667);
    slider.imageView.frame=CGRectMake(0, -2*Main_Screen_Height/667,imageWidth.width+10*Main_Screen_Height/667,25*Main_Screen_Height/667);
      
    [self.view addSubview:slider];
    UILabel *maxLab = [[UILabel alloc] init];
    
    maxLab.textColor =[UIColor colorFromHex:@"#ffffff"];
    maxLab.textAlignment=NSTextAlignmentRight;
    maxLab.font = [UIFont systemFontOfSize:10];
    NSLog(@"%d",[self.NextLevelScore intValue]-1);
    
    maxLab.text = [NSString stringWithFormat:@"%d",[self.NextLevelScore intValue]-1];
    [self.view addSubview:maxLab];
    
    UIButton *displayBtn = [[UIButton alloc] init];
    displayBtn.userInteractionEnabled = NO;
    NSString *string = [NSString stringWithFormat:@"还需获得%ld积分升级为%@",([self.NextLevelScore integerValue]- [self.CurrentScore integerValue]-1),self.nextLevel];
    [displayBtn setTitle:string forState:UIControlStateNormal];
    [displayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    displayBtn.titleLabel.font = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
    [displayBtn setImage:[UIImage imageNamed:@"xiaohuojian"] forState:UIControlStateNormal];
    displayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [displayBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10*Main_Screen_Height/667, 0, 0)];
    [headContainView addSubview:displayBtn];
    
    //底部
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containView];
    
    UIButton *getMoreBtn = [[UIButton alloc] init];
    [getMoreBtn setTitle:@"如何获得更多积分" forState:UIControlStateNormal];
    [getMoreBtn setTitleColor:[UIColor colorFromHex:@"#4a4a4a"] forState:UIControlStateNormal];
    getMoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [getMoreBtn setImage:[UIImage imageNamed:@"gengduojifen"] forState:UIControlStateNormal];
    [getMoreBtn addTarget:self action:@selector(didClickGetMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:getMoreBtn];
    
    
    
    
    //约束
    [headContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(150*Main_Screen_Height/667);
    }];
    
    [gradeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headContainView).mas_offset(9*Main_Screen_Height/667);
        make.centerX.equalTo(headContainView);
    }];
    
//    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(gradeLab.mas_bottom).mas_offset(44);
//        make.left.equalTo(headContainView).mas_offset(23);
//        make.right.equalTo(headContainView).mas_offset(-23);
//        make.height.mas_equalTo(4);
//    }];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gradeLab.mas_bottom).mas_offset(35);
        make.left.equalTo(headContainView).mas_offset(23);
        make.right.equalTo(headContainView).mas_offset(-23);
        make.width.mas_equalTo(Main_Screen_Width-46);
        make.height.mas_equalTo(9);
    }];
    [maxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).mas_offset(5);
        //        make.left.equalTo(headContainView).mas_offset(23);
        make.right.equalTo(slider);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(9);
    }];
    
    [displayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).mas_offset(10);
        make.centerX.equalTo(headContainView);
        make.width.mas_equalTo(250);
        make.bottom.equalTo(headContainView).mas_offset(10);
    }];

    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(49*Main_Screen_Height/667);
    }];
    
    [getMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(containView);
        make.height.mas_equalTo(40*Main_Screen_Height/667);
        make.width.mas_equalTo(250*Main_Screen_Height/667);
    }];
    
    getMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [getMoreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    
    
    self.wayToEarnScoreView.delegate = self;
    self.wayToEarnScoreView.dataSource = self;
    self.wayToEarnScoreView.rowHeight = 90*Main_Screen_Height/667;
    
    [_wayToEarnScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headContainView.mas_bottom);
        make.right.left.equalTo(headContainView);
        make.height.mas_equalTo(Main_Screen_Height - 64 - 150*Main_Screen_Height/667 - 49*Main_Screen_Height/667);
    }];
    
    [self.wayToEarnScoreView registerClass:[WayToUpGradeCell class] forCellReuseIdentifier:id_wayToUpCell];
    
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    [self requestGetScore];
    
}

-(void)requestGetScore
{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Integral/EarnIntegral",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            self.ScoreData = [[NSMutableArray alloc]init];
            
            NSArray *arr = [NSArray array];
            arr = [dict objectForKey:@"JsonData"];
            if(arr.count == 0)
            {
                [HUD setHidden:YES];
                [self.view showInfo:@"暂无数据" autoHidden:YES interval:2];
            }
            else
            {
                [self.ScoreData addObjectsFromArray:arr];
                [self.wayToEarnScoreView reloadData];
                [HUD setHidden:YES];
            }
            
        }
        else
        {
            [HUD setHidden:YES];
            [self.view showInfo:@"数据请求失败,请重试" autoHidden:YES interval:2];
//            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSError *error) {
        [HUD setHidden:YES];
        [self.view showInfo:@"获取失败,请重试" autoHidden:YES interval:2];
//         [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.ScoreData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WayToUpGradeCell *wayCell = [tableView dequeueReusableCellWithIdentifier:id_wayToUpCell forIndexPath:indexPath];
    
    NSArray *arr2 = @[@"wanshangerenxinxi",@"xinyonghuzhuce",@"yaoqinghaoyou",@"wanshancheliangxinxi",@"wanshangerenxinxi"];
    NSInteger num = [[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegType"] integerValue];
    
    
    
    wayCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arr2[num]]];
    wayCell.waysLab.text = [[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegName"];
    
    if([NSNull null] != [[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegDesc"])
    {
        wayCell.wayToLab.text = [NSString stringWithFormat:@"%@",[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegDesc"]];
    }
    else
    {
        wayCell.wayToLab.text = @"";
    }
    
    
    
    wayCell.valuesLab.text = [NSString stringWithFormat:@"+%d积分",[[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IntegralNum"] intValue]];
    
    if([[[self.ScoreData objectAtIndex:indexPath.row] objectForKey:@"IsComplete"] intValue] == 1)
    {
        
        [wayCell.goButton setTitle:@"已完成" forState:UIControlStateNormal];
        [wayCell.goButton setBackgroundColor:[UIColor colorFromHex:@"#e6e6e6"]];

        wayCell.goButton.enabled = NO;
        
    }
    else
    {
        wayCell.goButton.tag = indexPath.row;
        [wayCell.goButton addTarget:self action:@selector(gotoearnScore:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    wayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    
    
    
    return wayCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10*Main_Screen_Height/667;
}

-(void)gotoearnScore:(UIButton *)btn
{
 
    
    
    if([[[self.ScoreData objectAtIndex:btn.tag] objectForKey:@"IntegType"] intValue] == 2)
    {
        self.tabBarController.selectedIndex = 4;
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
        
        
        
    }
    else if([[[self.ScoreData objectAtIndex:btn.tag] objectForKey:@"IntegType"] intValue] == 3)
    {
        DSMyCarController *myCarController                  = [[DSMyCarController alloc]init];
        myCarController.hidesBottomBarWhenPushed            = YES;
        [self.navigationController pushViewController:myCarController animated:YES];
    }
    else if([[[self.ScoreData objectAtIndex:btn.tag] objectForKey:@"IntegType"] intValue] == 4)
    {
        DSUserInfoController *userInfoController    = [[DSUserInfoController alloc]init];
        userInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoController animated:YES];
    }
    
    
    
}



#pragma mark - 点击底部按钮
- (void)didClickGetMoreBtn {
    
    EarnScoreController *earnScoreVC = [[EarnScoreController alloc] init];
    earnScoreVC.hidesBottomBarWhenPushed = YES;
    earnScoreVC.CurrentScore = self.CurrentScore;
    
    [self.navigationController pushViewController:earnScoreVC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
