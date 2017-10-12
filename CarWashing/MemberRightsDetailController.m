//
//  MemberRightsDetailController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/22.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MemberRightsDetailController.h"
#import <Masonry.h>

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "DSCardGroupController.h"
#import "CardConfigGrade.h"

@interface MemberRightsDetailController ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *cardNameLab;
    UILabel *invalidLab;
    CardConfigGrade *card;
    MBProgressHUD *HUD;
    UIImageView *cardImgV;
}

@property(nonatomic,strong)UITableView *noticeView;
@property(nonatomic,strong)UIButton *getBtn;
@property (nonatomic, strong) NSMutableDictionary *GradeDetailDic;
@property (nonatomic, strong) NSString *area;

@property (nonatomic, weak) UILabel *noticeLabel;
@property (nonatomic, weak) UILabel *noticeLabelOne;
@property (nonatomic, weak) UILabel *noticeLabeTwo;
@property (nonatomic, weak) UILabel *noticeLabelThree;
@property (nonatomic, weak) UILabel *noticeLabelFour;
@property (nonatomic, weak) UILabel *noticeLabelFive;

@end

@implementation MemberRightsDetailController

- (void)drawNavigation {
    
    [self drawTitle:@"特权详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    card = [[CardConfigGrade alloc]init];
    self.area = @"上海市";
    [self setupUI];
    
    //
    if(self.nextdic == nil)
    {
        
        
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide =YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中";
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        
        
        [self requestCardConfigGradeDetail];
    }
    else
    {
        NSLog(@"---%@",self.nextdic);
        self.GradeDetailDic = [[NSMutableDictionary alloc]initWithDictionary:self.nextdic];
        [self UpdateUI];
    }
    
    
}


- (void)setupUI {
    
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 310*Main_Screen_Height/667)];
    [self.view addSubview:containView];
    
    cardImgV = [[UIImageView alloc] init];
    cardImgV.image = [UIImage imageNamed:@"bg_card"];
    [containView addSubview:cardImgV];
    
    cardNameLab = [[UILabel alloc] init];
    cardNameLab.text = @"体验卡";
    cardNameLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    cardNameLab.font = [UIFont boldSystemFontOfSize:18*Main_Screen_Height/667];
    [cardImgV addSubview:cardNameLab];
    
    UILabel *cardtagLab = [[UILabel alloc] init];
    cardtagLab.text = @"金顶洗车";
    cardtagLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    cardtagLab.font = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
    [cardImgV addSubview:cardtagLab];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.text = @"扫码洗车服务中使用";
    introLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    introLab.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    [cardImgV addSubview:introLab];
    
    invalidLab = [[UILabel alloc] init];
    invalidLab.text = @"有效期：2017-8-10";
    invalidLab.textColor = [UIColor colorFromHex:@"#999999"];
    invalidLab.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    [cardImgV addSubview:invalidLab];
    
    //    UILabel *brandLab = [[UILabel alloc] init];
    //    brandLab.text = @"金顶洗车";
    //    brandLab.font = [UIFont systemFontOfSize:11*Main_Screen_Height/667];
    //    [cardImgV addSubview:brandLab];
    
    self.getBtn = [UIUtil drawDefaultButton:containView title:@"立即领取" target:self action:@selector(didClickGetBtn)];
    
    UIButton *checkCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkCardBtn setTitle:@"查看卡包" forState:UIControlStateNormal];
    [checkCardBtn setTitleColor:[UIColor colorFromHex:@"#999999"] forState:UIControlStateNormal];
    checkCardBtn.titleLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    [checkCardBtn setImage:[UIImage imageNamed:@"chakandaijinquan-jiantou"] forState:UIControlStateNormal];
    checkCardBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -100*Main_Screen_Height/667);
    [checkCardBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -50*Main_Screen_Height/667, 0, 0)];
    
    [checkCardBtn addTarget:self action:@selector(didClickCheckCardBtn) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:checkCardBtn];
    
    
    //约束
    [cardImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView).mas_offset(10*Main_Screen_Height/667);
        make.left.equalTo(containView).mas_offset(22.5*Main_Screen_Height/667);
        make.right.equalTo(containView).mas_offset(-22.5*Main_Screen_Height/667);
        make.height.mas_equalTo(190*Main_Screen_Height/667);
    }];
    
    
    
    //    [brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(cardNameLab);
    //        make.leading.equalTo(cardNameLab.mas_trailing).mas_offset(5*Main_Screen_Height/667);
    //    }];
    //invalidLab有效期
    [invalidLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardImgV.mas_left).mas_offset(20*Main_Screen_Height/667);
        make.bottom.equalTo(cardImgV).mas_offset(-20*Main_Screen_Height/667);
    }];
    
    [cardNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardImgV.mas_top).mas_offset(20*Main_Screen_Height/667);
        make.left.equalTo(cardImgV.mas_left).mas_offset(20*Main_Screen_Height/667);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    //金顶洗车
    [cardtagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardImgV.mas_top).mas_offset(25*Main_Screen_Height/667);
        make.left.equalTo(cardNameLab.mas_right).mas_offset(-20*Main_Screen_Height/667);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    //扫码洗车服务中使用
    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNameLab.mas_bottom).mas_offset(5*Main_Screen_Height/667);
        make.left.equalTo(cardNameLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardImgV.mas_bottom).mas_offset(15*Main_Screen_Height/667);
        make.centerX.equalTo(containView);
        make.width.mas_equalTo(351*Main_Screen_Height/667);
        make.height.mas_equalTo(48*Main_Screen_Height/667);
    }];
    
    [checkCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getBtn.mas_bottom);
        make.centerX.equalTo(containView);
        make.height.mas_equalTo(45*Main_Screen_Height/667);
        make.width.mas_equalTo(100*Main_Screen_Height/667);
    }];
    
    self.noticeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height - 64) style:UITableViewStyleGrouped];
    //noticeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noticeView];
    
    //    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(checkCardBtn.mas_bottom);
    //        make.bottom.equalTo(self.view);
    //        make.width.mas_equalTo(Main_Screen_Width);
    //    }];
    self.noticeView.delegate = self;
    self.noticeView.dataSource = self;
    self.noticeView.estimatedRowHeight = 80;
    self.noticeView.rowHeight = UITableViewAutomaticDimension;
    self.noticeView.estimatedSectionHeaderHeight = 0;
    self.noticeView.estimatedSectionFooterHeight = 0;
    self.noticeView.rowHeight = UITableViewAutomaticDimension;
    self.noticeView.tableHeaderView = containView;
}

-(void)requestCardConfigGradeDetail
{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             @"ConfigCode":self.ConfigCode,
                             @"UseLevel":self.currentUseLevel
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/CardConfigGradeDetail",Khttp] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"--%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            
            self.GradeDetailDic = [[NSMutableDictionary alloc]init];
            
            
            self.GradeDetailDic = [dict objectForKey:@"JsonData"];
            
            [card setValuesForKeysWithDictionary:self.GradeDetailDic];
            
            [self UpdateUI];
            
            [HUD setHidden:YES];
            
        }
        else
        {
            [self.view showInfo:@"信息获取失败请重试" autoHidden:YES interval:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        [self.view showInfo:@"获取失败请重试" autoHidden:YES interval:2];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

-(void)UpdateUI
{
    
    cardImgV.image = [UIImage imageNamed:@"bg_card"];
    if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 1)
    {
        cardNameLab.text = @"体验卡";
    }else if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 2){
        cardNameLab.text = @"月清洁";
    }else if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 3){
        cardNameLab.text = @"季无忧";
    }else if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 4){
        cardNameLab.text = @"半年洗";
    }else if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 5){
        cardNameLab.text = @"年欢洗";
    }else if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 6){
        cardNameLab.text = @"随意行";
    }else if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 7){
        cardNameLab.text = @"52洗车";
    }else if([[_GradeDetailDic objectForKey:@"CardType"] intValue] == 8){
        cardNameLab.text = @"百洗无忧";
    }
    
    
    
    
    
    //    cardNameLab.text = [NSString stringWithFormat:@"本月免费洗车%@次",[_GradeDetailDic objectForKey:@"CardCount"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSDate *newDate = [datenow dateByAddingTimeInterval:60 * 60 * 24 * [[_GradeDetailDic objectForKey:@"ExpiredDay"] intValue]];
    invalidLab.text = [NSString stringWithFormat:@"截止日期:%@",[formatter stringFromDate:newDate]];
    
    NSArray *arr = @[@"",@"普通会员",@"白银会员",@"黄金会员",@"铂金会员",@"钻石会员",@"黑钻会员"];
    
    if([self.currentUseLevel intValue] < [self.nextUseLevel intValue])
    {
        [_getBtn setTitle:[NSString stringWithFormat:@"升级到%@可以获取",[arr objectAtIndex:[self.nextUseLevel intValue]]] forState:UIControlStateNormal];
        [_getBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHex:@"#e6e6e6"]] forState:UIControlStateNormal];
        _getBtn.enabled = NO;
    }
    else
    {
        if([[_GradeDetailDic objectForKey:@"CardQuantity"] intValue] != 0)
        {
            
        }
        else
        {
            [_getBtn setTitle:@"该卡已领取完毕" forState:UIControlStateNormal];
            [_getBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHex:@"#e6e6e6"]] forState:UIControlStateNormal];
            
            _getBtn.enabled = NO;
        }
    }
    
    
    
    
    [_noticeView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *id_noticeCell = @"id_noticeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id_noticeCell];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:id_noticeCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        titleLab.font = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
        [cell.contentView addSubview:titleLab];
        
        UILabel *infosLab = [[UILabel alloc] init];
        infosLab.textColor = [UIColor colorFromHex:@"#999999"];
        infosLab.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        infosLab.numberOfLines = 0;
        titleLab.text = @"特权介绍";
        infosLab.text = [_GradeDetailDic objectForKey:@"Description"];
        [cell.contentView addSubview:infosLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).mas_offset(12*Main_Screen_Height/667);
            make.left.equalTo(cell.contentView).mas_offset(12*Main_Screen_Height/667);
        }];
        
        [infosLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).mas_offset(12*Main_Screen_Height/667);
            make.leading.equalTo(titleLab);
            make.right.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
            make.bottom.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
        }];
        
        
    }else if (indexPath.section == 1) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        titleLab.font = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
        [cell.contentView addSubview:titleLab];
        
        UILabel *infosLab = [[UILabel alloc] init];
        infosLab.textColor = [UIColor colorFromHex:@"#999999"];
        infosLab.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        infosLab.numberOfLines = 0;
        titleLab.text = @"领取对象";
        
        if([self.nextUseLevel integerValue] == 1)
        {
            infosLab.text = @"普通会员";
            
        }
        else if([self.nextUseLevel integerValue] == 2)
        {
            infosLab.text = @"白银会员";
            
        }
        else if([self.nextUseLevel integerValue] == 3)
        {
            infosLab.text = @"黄金会员";
            
        }
        else if([self.nextUseLevel integerValue] == 4)
        {
            infosLab.text = @"铂金会员";
        }
        else if([self.nextUseLevel integerValue] == 5)
        {
            infosLab.text = @"钻石会员";
        }
        else
        {
            infosLab.text = @"黑钻会员";
            
        }
        
        
        [cell.contentView addSubview:infosLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).mas_offset(12*Main_Screen_Height/667);
            make.left.equalTo(cell.contentView).mas_offset(12*Main_Screen_Height/667);
        }];
        
        [infosLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).mas_offset(12*Main_Screen_Height/667);
            make.leading.equalTo(titleLab);
            make.right.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
            make.bottom.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
        }];
        
        
    }else {
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.text = @"使用须知";
        noticeLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        noticeLabel.font = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
        self.noticeLabel = noticeLabel;
        [cell.contentView addSubview:self.noticeLabel];
        
        
        UILabel *noticeLabelOne = [[UILabel alloc] init];
        noticeLabelOne.text = @"1. 下载金顶洗车APP，通过扫码可直接启动洗车机；";
        noticeLabelOne.numberOfLines = 0;
        noticeLabelOne.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelOne.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        self.noticeLabelOne = noticeLabelOne;
        
        [cell.contentView addSubview:self.noticeLabelOne];
        
        
        [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).mas_offset(12*Main_Screen_Height/667);
            make.left.equalTo(cell.contentView).mas_offset(12*Main_Screen_Height/667);
        }];
        
        [self.noticeLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noticeLabel.mas_bottom).mas_offset(12*Main_Screen_Height/667);
            make.leading.equalTo(self.noticeLabel);
            make.right.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
        }];
        
        UILabel *noticeLabelTwo = [[UILabel alloc] init];
        noticeLabelTwo.text = @"2. 整个洗车过程请遵照洗车提示和工作人员引导；";
        noticeLabelTwo.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelTwo.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        self.noticeLabeTwo = noticeLabelTwo;
        [cell.contentView addSubview:self.noticeLabeTwo];
        UILabel *noticeLabelThree = [[UILabel alloc] init];
        noticeLabelThree.text = @"3. 此卡请在有效期内使用，不退卡、不转让、不挂失；";
        noticeLabelThree.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelThree.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        noticeLabelThree.numberOfLines = 0;
        self.noticeLabelThree = noticeLabelThree;
        [cell.contentView addSubview:self.noticeLabelThree];
        UILabel *noticeLabelFour = [[UILabel alloc] init];
        noticeLabelFour.text = @"4. 启动前请确保外置天线、反光镜已经收起，车窗等处于关闭、全车处于隔水状态，自行改装外饰确保不妨碍洗车；";
        noticeLabelFour.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelFour.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        noticeLabelFour.numberOfLines = 0;
        self.noticeLabelFour = noticeLabelFour;
        [cell.contentView addSubview:self.noticeLabelFour];
        UILabel *noticeLabelFive = [[UILabel alloc] init];
        noticeLabelFive.text = @"5. 请不要在洗车过程中随意上下车，若出现问题或者故障可咨询工作人员或拨打客服电话进行咨询";
        noticeLabelFive.textColor = [UIColor colorFromHex:@"#999999"];
        noticeLabelFive.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
        noticeLabelFive.numberOfLines = 0;
        self.noticeLabelFive = noticeLabelFive;
        [cell.contentView addSubview:self.noticeLabelFive];
        
        
        [self.noticeLabeTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noticeLabelOne.mas_bottom).mas_offset(12*Main_Screen_Height/667);
            make.leading.equalTo(self.noticeLabelOne);
            make.right.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
        }];
        
        [self.noticeLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noticeLabeTwo.mas_bottom).mas_offset(12*Main_Screen_Height/667);
            make.leading.equalTo(self.noticeLabeTwo);
            make.right.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
            
        }];
        [self.noticeLabelFour mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noticeLabelThree.mas_bottom).mas_offset(12*Main_Screen_Height/667);
            make.leading.equalTo(self.noticeLabelThree);
            make.right.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
            
        }];
        [self.noticeLabelFive mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noticeLabelFour.mas_bottom).mas_offset(12*Main_Screen_Height/667);
            make.leading.equalTo(self.noticeLabelFour);
            make.right.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
            make.bottom.equalTo(cell.contentView).mas_offset(-12*Main_Screen_Height/667);
        }];
        
        
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}



#pragma mark -
- (void)didClickGetBtn {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSDate *newDate = [datenow dateByAddingTimeInterval:60 * 60 * 24 * [[_GradeDetailDic objectForKey:@"ExpiredDay"] intValue]];
    
    
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             @"ConfigCode":self.ConfigCode,
                             @"UseLevel":self.currentUseLevel,
                             @"GetCardType":[NSString stringWithFormat:@"%ld",card.GetCardType],
                             @"Area":card.Area,
                             @"CardCount":[NSString stringWithFormat:@"%ld",card.CardCount],
                             @"CardName":card.CardName,
                             @"CardPrice":[NSString stringWithFormat:@"%@",card.CardPrice],
                             @"CardType":[NSString stringWithFormat:@"%ld",card.CardType],
                             @"Description":card.Description,
                             @"ExpStartDates":[NSString stringWithFormat:@"%@",[formatter stringFromDate:datenow]],
                             @"ExpEndDates":[NSString stringWithFormat:@"%@",[formatter stringFromDate:newDate]],
                             @"Integralnum": @1,
                             };
    
    
    
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/ReceiveCardInfo",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            
            [self.view showInfo:@"领取成功" autoHidden:YES interval:2];
            
            
            
            int num = [[_GradeDetailDic objectForKey:@"CardQuantity"] intValue];
            
            [_GradeDetailDic setObject:[NSString stringWithFormat:@"%d",num-1] forKey:@"CardQuantity"];
            
            //            NSNotification * notice = [NSNotification notificationWithName:@"receivesuccess" object:nil userInfo:nil];
            //            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
            //            self.GradeDetailDic = [dict objectForKey:@"JsonData"];
            if([[_GradeDetailDic objectForKey:@"CardQuantity"] intValue] != 0)
            {
                
            }
            else
            {
                [_getBtn setTitle:@"该卡已领取完毕" forState:UIControlStateNormal];
                _getBtn.enabled = NO;
            }
            
            
        }
        else
        {
            [self.view showInfo:@"领取失败" autoHidden:YES interval:2];
        }
    } fail:^(NSError *error) {
        [self.view showInfo:@"领取失败" autoHidden:YES interval:2];
        
    }];
    
}

- (void)didClickCheckCardBtn {
    DSCardGroupController *cardGroupController      = [[DSCardGroupController alloc]init];
    cardGroupController.hidesBottomBarWhenPushed    = YES;
    [self.navigationController pushViewController:cardGroupController animated:YES];
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

