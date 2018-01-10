//
//  DSMemberRightsController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSMemberRightsController.h"
#import "DSUpdateRuleController.h"
#import <Masonry.h>
#import "HowToUpGradeController.h"
#import "MemberRightsDetailController.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

#import "MemberRightCell.h"

@interface DSMemberRightsController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView         *memberRightsView;
    MBProgressHUD       *HUD;
    UILabel             *membershipNameLabel;
    UIButton            *gradeBtn;
    UIImageView         *membershipImageView;
    UIImageView         *signImageView;
}

@property (nonatomic, strong) NSMutableArray *MembershipprivilegesArray;
@property (nonatomic, strong) NSMutableDictionary *MembershipprivilegesDic;
@property (nonatomic, strong) NSMutableArray *NextMembershipprivilegesArr;
@property (nonatomic, strong) NSMutableArray *CurrentMembershipprivilegesArr;
@property (nonatomic, strong) NSString *area;

@property(strong,nonatomic)UIView *hopeView;

@end

static NSString *id_rightsCell = @"id_rightsCell";

@implementation DSMemberRightsController

- (void)drawNavigation {
    
    [self drawTitle:@"会员特权"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //    [center addObserver:self selector:@selector(noticeupdateCardNum:) name:@"receivesuccess" object:nil];
    [center addObserver:self selector:@selector(noticeupdate:) name:@"Earnsuccess" object:nil];
    [self createSubView];
    self.area = @"上海市";
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    [self GetMembershipprivileges];
    
    [self.view addSubview:self.hopeView];
    
}

-(UIView*)hopeView{
    if (!_hopeView) {
        _hopeView = [[UIView alloc]initWithFrame:CGRectMake(0, 210.0/375*Main_Screen_Width, Main_Screen_Width, 400.0/375*Main_Screen_Width)];
        
        _hopeView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
        titleLabel.text = @"精品专区";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkGrayColor];
        [_hopeView addSubview:titleLabel];
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, Main_Screen_Width, 1)];
        grayView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_hopeView addSubview:grayView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-35, 90, 70, 70)];
        imageView.image = [UIImage imageNamed:@"jingpinzhuanqu"];
        [_hopeView addSubview:imageView];
        
        UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 180, Main_Screen_Width, 20)];
        moreLabel.text = @"更多优惠敬请关注";
        moreLabel.textColor = [UIColor colorFromHex:@"#909090"];
        moreLabel.textAlignment = NSTextAlignmentCenter;
        [_hopeView addSubview:moreLabel];
    }
    return _hopeView;
}




- (void) createSubView {
    UIView *upView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*130/667) color:[UIColor whiteColor]];
    upView.top                      = 0;
    
    
    UIImage *membershipImage              = [UIImage imageNamed:@"huiyuantou"];
    membershipImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(0, 0, membershipImage.size.width, membershipImage.size.height) imageName:@"huiyuantou"];
    membershipImageView.layer.masksToBounds = YES;
    membershipImageView.layer.cornerRadius  = membershipImage.size.height/2;
    membershipImageView.top               = Main_Screen_Height*15/667;
    membershipImageView.centerX           = upView.centerX;
    
    
    signImageView                           = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(0, 0, Main_Screen_Width*20/375, Main_Screen_Height*20/667) imageName:@"putong"];
    signImageView.layer.masksToBounds       = YES;
    signImageView.layer.cornerRadius        = signImageView.size.height/2;
    signImageView.centerY                   = membershipImageView.centerY +Main_Screen_Height*40/667;
    signImageView.centerX                   = membershipImageView.centerX +Main_Screen_Width*40/667;
    if (Main_Screen_Height == 568) {
        signImageView.centerY                   = membershipImageView.centerY +Main_Screen_Height*40/667;
        signImageView.centerX                   = membershipImageView.centerX +Main_Screen_Width*40/667;
    }
    if (Main_Screen_Height == 667) {
        signImageView.centerY                   = membershipImageView.centerY +Main_Screen_Height*35/667;
        signImageView.centerX                   = membershipImageView.centerX +Main_Screen_Width*35/667;
    }
    if (Main_Screen_Height == 736) {
        signImageView.centerY                   = membershipImageView.centerY +Main_Screen_Height*30/667;
        signImageView.centerX                   = membershipImageView.centerX +Main_Screen_Width*30/667;
    }
    
    
    NSString *membershipName              = @"普通会员";
    UIFont *membershipNameFont            = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    membershipNameLabel          = [UIUtil drawLabelInView:upView frame:[UIUtil textRect:membershipName font:membershipNameFont] font:membershipNameFont text:membershipName isCenter:NO];
    membershipNameLabel.textColor         = [UIColor colorFromHex:@"#999999"];
    membershipNameLabel.top               = membershipImageView.bottom +Main_Screen_Height*10/667;
    membershipNameLabel.centerX           = membershipImageView.centerX;
    
    upView.height       = membershipNameLabel.bottom+Main_Screen_Height*10/667;
    
    
    memberRightsView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    memberRightsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:memberRightsView];
    
    memberRightsView.delegate = self;
    memberRightsView.dataSource = self;
    [memberRightsView registerNib:[UINib nibWithNibName:@"MemberRightCell" bundle:nil] forCellReuseIdentifier:@"JackRightCell"];
    
    //底部
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containView];
    
    gradeBtn = [[UIButton alloc] init];
    [gradeBtn setTitle:@"如何升级到黄金会员" forState:UIControlStateNormal];
    [gradeBtn setTitleColor:[UIColor colorFromHex:@"#4a4a4a"] forState:UIControlStateNormal];
    gradeBtn.titleLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
    [gradeBtn setImage:[UIImage imageNamed:@"xiaohuojian"] forState:UIControlStateNormal];
    [containView addSubview:gradeBtn];
    
    
    [memberRightsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_bottom);
        make.left.right.equalTo(self.view);
        
    }];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(memberRightsView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(49*Main_Screen_Height/667);
    }];
    
    [gradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(containView);
        make.height.mas_equalTo(40*Main_Screen_Height/667);
        make.width.mas_equalTo(250*Main_Screen_Height/667);
    }];
    
    gradeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [gradeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    
    [gradeBtn addTarget:self action:@selector(clickHowToIncreaseGradeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)GetMembershipprivileges
{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             @"GetCardType":@3,
                             
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/GetCardConfigList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            
            _MembershipprivilegesArray = [[NSMutableArray alloc]init];
            _NextMembershipprivilegesArr = [[NSMutableArray alloc]init];
            _CurrentMembershipprivilegesArr = [[NSMutableArray alloc]init];
            
            
            _MembershipprivilegesDic = [dict objectForKey:@"JsonData"];
            
            
            NSArray * arr = [_MembershipprivilegesDic objectForKey:@"cardConfigList"];
            
            for(NSDictionary *dic in arr)
            {
                if([dic[@"CurrentOrNextLevel"] integerValue] == 1)
                {
                    [_CurrentMembershipprivilegesArr addObject:dic];
                }
                else
                {
                    [_NextMembershipprivilegesArr addObject:dic];
                }
            }
            
            [self UpdateUI];
            
            [HUD setHidden:YES];
            
            APPDELEGATE.currentUser.UserScore = [[NSString stringWithFormat:@"%@",_MembershipprivilegesDic[@"UserScore"]] integerValue];
            
            [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
            //判断有没有当前活动
            if (self.CurrentMembershipprivilegesArr.count == 0) {
                //当前等级没有活动
                self.hopeView.hidden = NO;
                memberRightsView.hidden = YES;
            }else{
                //有活动
                self.hopeView.hidden = YES;
                memberRightsView.hidden = NO;
            }
        }
        else
        {
            [HUD setHidden:YES];
            [self.view showInfo:@"信息获取失败，请重试" autoHidden:YES interval:2];
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        [HUD setHidden:YES];
        [self.view showInfo:@"获取失败，请重试" autoHidden:YES interval:2];
        //        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

-(void)UpdateUI
{
    
    //    NSLog(@"%@",_MembershipprivilegesDic);
    //
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,_MembershipprivilegesDic[@"Headimg"]];
    //        NSURL *url=[NSURL URLWithString:ImageURL];
    //        NSData *data=[NSData dataWithContentsOfURL:url];
    //        UIImage *img=[UIImage imageWithData:data];
    //        dispatch_sync(dispatch_get_main_queue(), ^{
    //            membershipImageView.image = img;
    //        });
    //    });
    
    [membershipImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHTTPImg,_MembershipprivilegesDic[@"Headimg"]]] placeholderImage:[UIImage imageNamed:@"huiyuantou"]];
    
    NSUInteger num = [_MembershipprivilegesDic[@"Level_id"] integerValue];
    
    if (num == 1) {
        signImageView.image = [UIImage imageNamed:@"putong"];
        
    }else if (num == 2){
        signImageView.image = [UIImage imageNamed:@"baiyin"];
        
    }else if (num == 3){
        signImageView.image = [UIImage imageNamed:@"huangjin"];
        
    }else if (num == 4){
        signImageView.image = [UIImage imageNamed:@"bojin"];
        
    }else if (num == 5){
        signImageView.image = [UIImage imageNamed:@"zuanshi"];
        
    }else if (num == 6){
        signImageView.image = [UIImage imageNamed:@"heizuan"];
        
    }else {
        signImageView.image = [UIImage imageNamed:@"putong"];
        
        
    }
    
    
    
    if([_MembershipprivilegesDic[@"Level_id"] integerValue] == 1)
    {
        membershipNameLabel.text = @"普通会员";
        [gradeBtn setTitle:@"如何升级到白银会员" forState:UIControlStateNormal];
    }
    else if([_MembershipprivilegesDic[@"Level_id"] integerValue] == 2)
    {
        membershipNameLabel.text = @"白银会员";
        [gradeBtn setTitle:@"如何升级到黄金会员" forState:UIControlStateNormal];
    }
    else if([_MembershipprivilegesDic[@"Level_id"] integerValue] == 3)
    {
        membershipNameLabel.text = @"黄金会员";
        [gradeBtn setTitle:@"如何升级到铂金会员" forState:UIControlStateNormal];
    }
    else if([_MembershipprivilegesDic[@"Level_id"] integerValue] == 4)
    {
        membershipNameLabel.text = @"铂金会员";
        [gradeBtn setTitle:@"如何升级到钻石会员" forState:UIControlStateNormal];
    }
    else if([_MembershipprivilegesDic[@"Level_id"] integerValue] == 5)
    {
        membershipNameLabel.text = @"钻石会员";
        [gradeBtn setTitle:@"如何升级到黑钻会员" forState:UIControlStateNormal];
    }
    else if([_MembershipprivilegesDic[@"Level_id"] integerValue] == 6)
    {
        membershipNameLabel.text = @"黑钻会员";
        [gradeBtn setTitle:@"您已经是黑钻会员" forState:UIControlStateNormal];
    }
    
    [memberRightsView reloadData];
    
}

- (void)clickHowToIncreaseGradeBtn {
    
    NSArray *arr2 = @[@"",@"普通会员",@"白银会员",@"黄金会员",@"铂金会员",@"钻石会员",@"黑钻会员"];
    
    NSUInteger num = [[NSString stringWithFormat:@"%@",_MembershipprivilegesDic[@"Level_id"]] integerValue];
    
    NSUInteger num2 = [[NSString stringWithFormat:@"%@",_MembershipprivilegesDic[@"NextLevel"]] integerValue];
    
    
    HowToUpGradeController *upGradeVC = [[HowToUpGradeController alloc] init];
    upGradeVC.hidesBottomBarWhenPushed = YES;
    
    upGradeVC.currentLevel = arr2[num];
    upGradeVC.nextLevel = arr2[num2];
    upGradeVC.NextLevelScore = [NSString stringWithFormat:@"%@",_MembershipprivilegesDic[@"NextLevelScore"]];
    upGradeVC.CurrentScore = [NSString stringWithFormat:@"%@",_MembershipprivilegesDic[@"UserScore"]];
    
    
    [self.navigationController pushViewController:upGradeVC animated:YES];
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        
        return [_CurrentMembershipprivilegesArr count];
    }
    else
    {
        return [_NextMembershipprivilegesArr count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JackRightCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        //当前级别
        NSDictionary *tempDict = _CurrentMembershipprivilegesArr[indexPath.row];
        cell.titleMemberLabel.text = [NSString stringWithFormat:@"%@*%@",tempDict[@"CardName"],tempDict[@"CardQuantity"]];
    }else{
        //下一级别
        NSDictionary *tempDict = _NextMembershipprivilegesArr[indexPath.row];
        cell.titleMemberLabel.text = [NSString stringWithFormat:@"%@*%@",tempDict[@"CardName"],tempDict[@"CardQuantity"]];
    }
    
    return cell;

    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id_rightsCell];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:id_rightsCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"shengjihoukaquan"];
    
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorFromHex:@"#3a3a3a"];
    
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorFromHex:@"#999999"];
    
    NSString    *string;
    NSString    *detailString;
    if (indexPath.section == 0) {
        if(_CurrentMembershipprivilegesArr.count != 0)
        {
            string = [NSString stringWithFormat:@"%@X%@",[[_CurrentMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"CardName"],[[_CurrentMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"CardQuantity"]];
            detailString    = @"自动扫码洗车可使用，达到该等级当月可领取";
        }
        else
        {
            
        }
        
    }else {
        if(_NextMembershipprivilegesArr.count == 0)
        {
            
        }else
        {
            string = [NSString stringWithFormat:@"%@X%@",[[_NextMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"CardName"],[[_NextMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"CardQuantity"]];
            detailString    = @"自动扫码洗车可使用，达到该等级当月可领取";
        }
        
    }
    UILabel *titleLabel  = [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, 300*Main_Screen_Height/667, 20) font:[UIFont systemFontOfSize:Main_Screen_Height*14/667] text:string isCenter:NO];
    titleLabel.textColor = [UIColor colorFromHex:@"#3a3a3a"];
    //    titleLabel.backgroundColor  = [UIColor redColor];
    titleLabel.top       = 13;
    titleLabel.left      = 70*Main_Screen_Height/667;
    
    UILabel *detailLabel  = [UIUtil drawLabelInView:cell.contentView frame:CGRectMake(0, 0, 300*Main_Screen_Height/667, 30) font:[UIFont systemFontOfSize:Main_Screen_Height*12/667] text:detailString isCenter:NO];
    detailLabel.textColor = [UIColor colorFromHex:@"#999999"];
    //    detailLabel.backgroundColor  = [UIColor redColor];
    detailLabel.numberOfLines   = 2;
    detailLabel.top       = titleLabel.bottom;
    detailLabel.left      = 70*Main_Screen_Height/667;
    return cell;
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        
        
        UIView * footView= [[UIView alloc]init];
        footView.backgroundColor=[UIColor whiteColor];
        //        UIView * lineVIew=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
        //        lineVIew.backgroundColor=RGBAA(239, 239, 239, 1.0);
        //        [footView addSubview:lineVIew];
        
        UIImageView * leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*30/667, 20, 30, 30)];
        leftImage.image=[UIImage imageNamed:@"shengjihoukaquan"];
        [footView addSubview:leftImage];
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300*Main_Screen_Height/667, 20)];
        detailLabel.top       = footView.bottom+25;
        detailLabel.left      = 70*Main_Screen_Height/667;
        detailLabel.textColor = [UIColor colorFromHex:@"#3a3a3a"];
        detailLabel.font = [UIFont systemFontOfSize:Main_Screen_Height*14/667];
        detailLabel.text = @"暂无优惠";
        [footView addSubview:detailLabel];
        return nil;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hederview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    hederview.backgroundColor=[UIColor colorFromHex:@"0xf0f0f0"];
    
    
    
    UIView *hederviews=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 40)];
    hederviews.backgroundColor=[UIColor whiteColor];
    
    
    
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_Screen_Width, 40)];
    
    infoLabel.textColor = [UIColor colorFromHex:@"#3a3a3a"];
    infoLabel.font = [UIFont systemFontOfSize:15];
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, Main_Screen_Width, 1)];
    lineView.backgroundColor=RGBAA(239, 239, 239, 1.0);
    
    
    if (section == 0) {
        infoLabel.text = @"  等级特权";
    }else{
        infoLabel.text = @"  升级后可获得特权";
    }
    
    [hederviews addSubview:infoLabel];
    [hederviews addSubview:lineView];
    [hederview addSubview:hederviews];
    
    return hederview;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return @"我的特权";
//    }else {
//
//        return @"升级后可获得特权";
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MemberRightsDetailController *VC = [[MemberRightsDetailController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    if(indexPath.section == 0)
    {
        VC.ConfigCode = [[_CurrentMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"ConfigCode"];
        VC.nextUseLevel = [[_CurrentMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"UseLevel"];
        
    }
    else
    {
        VC.ConfigCode = [[_NextMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"ConfigCode"];
        VC.nextUseLevel = [[_NextMembershipprivilegesArr objectAtIndex:indexPath.row] objectForKey:@"UseLevel"];
        VC.nextdic = [_NextMembershipprivilegesArr objectAtIndex:indexPath.row];
    }
    VC.currentUseLevel =_MembershipprivilegesDic[@"Level_id"];
    [self.navigationController pushViewController:VC animated:YES];
}

//-(void)noticeupdateCardNum:(NSNotification *)sender{
//
//}

-(void)noticeupdate:(NSNotification *)sender{
    [self GetMembershipprivileges];
}

#pragma mark -------button click------

- (void) updateMemberClick:(id)sender {
    
    
}
- (void) updateRuleClick:(id)sender {
    
    DSUpdateRuleController *updateRuleController  = [[DSUpdateRuleController alloc]init];
    updateRuleController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:updateRuleController animated:YES];
    
}

//#pragma mark -------tapGesture click------
//- (void) tapSymbolButtonClick:(id)sender {
//
//
//}
//
//- (void) tapDiscountButtonClick:(id)sender {
//
//
//}
//- (void) tapMaintainButtonClick:(id)sender {
//
//
//}
//
//- (void) tapGoodsButtonClick:(id)sender {
//
//
//}

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
