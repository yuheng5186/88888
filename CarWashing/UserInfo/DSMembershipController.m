 //
//  DSMembershipController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSMembershipController.h"
#import "MemberView.h"
#import "DSMemberRightsController.h"
#import "ScoreDetailController.h"
#import <Masonry.h>
#import "WashCarTicketController.h"
#import "GoodsExchangeCell.h"
#import "EarnScoreController.h"
#import "HowToUpGradeController.h"

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "HTTPDefine.h"
#import "UIImageView+WebCache.h"
#import "Card.h"
#import "AppDelegate.h"


@interface DSMembershipController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    MemberView *memberShipView;
}

@property (nonatomic, weak) UITableView *exchangListView;

@property (nonatomic, strong) NSMutableDictionary *MembershipUserScore;

@property (nonatomic, strong) NSMutableArray *MembershipUserScoreArray;

@property (nonatomic, weak) UIView *containView;

@end

static NSString *id_exchangeCell = @"id_exchangeCell";

@implementation DSMembershipController

- (UITableView *)exchangListView {
    
    if (!_exchangListView) {
        
        UITableView *exchangeListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height - 64) style:UITableViewStyleGrouped];
        _exchangListView = exchangeListView;
        _exchangListView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        [self.view addSubview:_exchangListView];
    }
    
    return _exchangListView;
}


- (UIView *)containView {
    
    if (!_containView) {
        
        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 230*Main_Screen_Height/667)];
        _containView = containView;
        [self.view addSubview:_containView];
    }
    
    return _containView;
}



- (void)drawNavigation {
    
    [self drawTitle:@"金顶会员"];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHex:@"ffca2a"];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticeupdate:) name:@"updatenamesuccess" object:nil];
    [center addObserver:self selector:@selector(noticeupdate:) name:@"updateheadimgsuccess" object:nil];
    [center addObserver:self selector:@selector(noticeupdate:) name:@"updatecard" object:nil];
    [center addObserver:self selector:@selector(noticeupdate:) name:@"Earnsuccess" object:nil];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    [self GetMembershipUserScore];
}


- (void)setupUI {
    
    
    self.containView.backgroundColor = [UIColor whiteColor];
    
    memberShipView = [MemberView memberView];
    memberShipView.frame = CGRectMake(0, 64, Main_Screen_Width, 140*Main_Screen_Height/667);
    
    
    [self.containView addSubview:memberShipView];
    
    
    UIView *exchangeView = [[UIView alloc] init];
    
    [self.containView addSubview:exchangeView];
    
    UILabel *exchangeLabel = [[UILabel alloc] init];
    exchangeLabel.text = @"精品兑换";
    exchangeLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    exchangeLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    [exchangeView addSubview:exchangeLabel];
    
    UIView *separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor clearColor];
//    separateView.backgroundColor = [UIColor colorFromHex:@"#fafafa"];
    [self.containView addSubview:separateView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorFromHex:@"#eaeaea"];
    [self.containView addSubview:lineView];
    
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    UICollectionView *goodsView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    //    goodsView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:goodsView];
    //
    self.exchangListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.exchangListView.delegate = self;
    self.exchangListView.dataSource = self;
    self.exchangListView.rowHeight = 190*Main_Screen_Height/667;
    self.exchangListView.backgroundColor = [UIColor whiteColor];
    self.exchangListView.showsVerticalScrollIndicator = NO;
    
    [self.exchangListView registerClass:[GoodsExchangeCell class] forCellReuseIdentifier:id_exchangeCell];
    
    UIImageView *presentImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-35, 300.0/667*Main_Screen_Height, 70, 70)];
    presentImage.image = [UIImage imageNamed:@"jingpinzhuanqu"];
    presentImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.containView addSubview:presentImage];
    
    UILabel *comingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 380.0/667*Main_Screen_Height, Main_Screen_Width, 30)];
    comingLabel.text = @"敬请期待";
    comingLabel.textColor = [UIColor grayColor];
    comingLabel.textAlignment = NSTextAlignmentCenter;
    [self.containView addSubview:comingLabel];
    //约束
    
    [memberShipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView);
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(175*Main_Screen_Height/667);
    }];
    
    [exchangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(memberShipView.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(40*Main_Screen_Height/667);
    }];
    
    [exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(exchangeView);
    }];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(memberShipView.mas_bottom);
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(10*Main_Screen_Height/667);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_containView.mas_bottom);
        make.left.right.equalTo(self.containView);
        make.height.mas_equalTo(1);
    }];
    
//    [_exchangListView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView.mas_bottom);
//        make.bottom.equalTo(self.view);
//        make.left.equalTo(self.view).mas_equalTo(30*Main_Screen_Height/667);
//        make.right.equalTo(self.view).mas_equalTo(-30*Main_Screen_Height/667);
//    }];
    
    _exchangListView.tableHeaderView = _containView;
}


-(void)GetMembershipUserScore
{
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             @"GetCardType":@5,
                             
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/GetCardConfigList",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            _MembershipUserScore = [[NSMutableDictionary alloc]init];
            _MembershipUserScoreArray = [[NSMutableArray alloc]init];
            
            
            _MembershipUserScore = [dict objectForKey:@"JsonData"];
            
            
            NSArray * arr = [_MembershipUserScore objectForKey:@"cardConfigList"];
            
            for(NSDictionary *dic in arr)
            {
                Card *card = [[Card alloc]init];
                [card setValuesForKeysWithDictionary:dic];
                [_MembershipUserScoreArray addObject:card];
            }

            [memberShipView.UserImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHTTPImg,_MembershipUserScore[@"Headimg"]]] placeholderImage:[UIImage imageNamed:@"huiyuantou"]];
            
            memberShipView.phoneLabel.text = [NSString stringWithFormat:@"%@",_MembershipUserScore[@"Name"]];
//            [memberShipView.ScoreBtn setTitle:[NSString stringWithFormat:@"%@分",_MembershipUserScore[@"UserScore"]] forState:UIControlStateNormal];
            
             NSArray *arr2 = @[@"",@"普通会员",@"白银会员",@"黄金会员",@"铂金会员",@"钻石会员",@"黑钻会员"];
            
            NSUInteger num = [[NSString stringWithFormat:@"%@",_MembershipUserScore[@"Level_id"]] integerValue];
            
            if (num == 1) {
                [memberShipView.signLabel setImage:[UIImage imageNamed:@"putongJ"]];

            }else if (num == 2){
                [memberShipView.signLabel setImage:[UIImage imageNamed:@"baiyinJ"]];

            }else if (num == 3){
                [memberShipView.signLabel setImage:[UIImage imageNamed:@"huangjinJ"]];
                
            }else if (num == 4){
                [memberShipView.signLabel setImage:[UIImage imageNamed:@"bojinJ"]];
                
            }else if (num == 5){
                [memberShipView.signLabel setImage:[UIImage imageNamed:@"zuanshiJ"]];
                
            }else if (num == 6){
                [memberShipView.signLabel setImage:[UIImage imageNamed:@"heizuanJ"]];
                
            }else {
                [memberShipView.signLabel setImage:[UIImage imageNamed:@"putongJ"]];
                
            }
            
//            [memberShipView.LevelBtn setTitle:[arr2 objectAtIndex:num] forState:UIControlStateNormal];
            
            [_exchangListView reloadData];
            
            [HUD setHidden:YES];
            
            
            
            APPDELEGATE.currentUser.UserScore = [[NSString stringWithFormat:@"%@",_MembershipUserScore[@"UserScore"]] integerValue];
            
            [UdStorage storageObject:[NSString stringWithFormat:@"%ld",APPDELEGATE.currentUser.UserScore] forKey:@"UserScore"];
            
        }
        else
        {
             [HUD setHidden:YES];
            [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];
            
//            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
         [HUD setHidden:YES];
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
//        [self.navigationController popViewControllerAnimated:YES];
        
    }];

}

#pragma mark - 点击赚积分
- (IBAction)clickEarnScoreBtn:(UIButton *)sender {
    
    ScoreDetailController *scoreVC = [[ScoreDetailController alloc] init];
    scoreVC.hidesBottomBarWhenPushed = YES;
    scoreVC.CurrentScore = [NSString stringWithFormat:@"%@",_MembershipUserScore[@"UserScore"]];
    
    [self.navigationController pushViewController:scoreVC animated:YES];
    

}

#pragma mark - 我的积分
- (IBAction)clickUpgradeBtn:(UIButton *)sender {
    
    EarnScoreController *earnScoreVC    = [[EarnScoreController alloc] init];
    earnScoreVC.hidesBottomBarWhenPushed  = YES;
    earnScoreVC.CurrentScore = [NSString stringWithFormat:@"%@",_MembershipUserScore[@"UserScore"]];
    [self.navigationController pushViewController:earnScoreVC animated:YES];

    
}


#pragma mark - 点击会员按钮
- (IBAction)clickMemberButton:(UIButton *)sender {
    
    DSMemberRightsController *rightsController = [[DSMemberRightsController alloc] init];
    rightsController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:rightsController animated:YES];
    
}

#pragma mark - 升级
- (IBAction)clickMemberScoreBtn:(UIButton *)sender {
    
    NSArray *arr2 = @[@"",@"普通会员",@"白银会员",@"黄金会员",@"铂金会员",@"钻石会员",@"黑钻会员"];
    
    NSUInteger num = [[NSString stringWithFormat:@"%@",_MembershipUserScore[@"Level_id"]] integerValue];
    
    NSUInteger num2 = [[NSString stringWithFormat:@"%@",_MembershipUserScore[@"NextLevel"]] integerValue];
    
    
    HowToUpGradeController *upGradeVC = [[HowToUpGradeController alloc] init];
    upGradeVC.hidesBottomBarWhenPushed = YES;
    
    upGradeVC.currentLevel = arr2[num];
    upGradeVC.nextLevel = arr2[num2];
    upGradeVC.NextLevelScore = [NSString stringWithFormat:@"%@",_MembershipUserScore[@"NextLevelScore"]];
    upGradeVC.CurrentScore = [NSString stringWithFormat:@"%@",_MembershipUserScore[@"UserScore"]];
    
    
    [self.navigationController pushViewController:upGradeVC animated:YES];
    
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_MembershipUserScoreArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsExchangeCell *changeCell = [tableView dequeueReusableCellWithIdentifier:id_exchangeCell forIndexPath:indexPath];
    
    changeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Card *newcard = (Card *)[_MembershipUserScoreArray objectAtIndex:indexPath.section];
    
    
    changeCell.backImgV.image = [UIImage imageNamed:@"bg_card"];

//    if(newcard.CardType == 1)
//    {
//        changeCell.backImgV.image = [UIImage imageNamed:@"qw_tiyanka"];
//    }else if(newcard.CardType == 2)
//    {
//        changeCell.backImgV.image = [UIImage imageNamed:@"qw_yueka"];
//    }else if(newcard.CardType == 3)
//    {
//        changeCell.backImgV.image = [UIImage imageNamed:@"qw_cika"];
//    }else if(newcard.CardType == 4)
//    {
//        changeCell.backImgV.image = [UIImage imageNamed:@"qw_nianka"];
//    }
    changeCell.introLab.text=[NSString stringWithFormat:@"免费扫码洗车%ld次",newcard.CardCount];
    changeCell.nameLab.text = newcard.CardName;
    changeCell.scoreLab.text = [NSString stringWithFormat:@"%ld积分",newcard.Integralnum];
    
    return changeCell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Card *newcard = (Card *)[_MembershipUserScoreArray objectAtIndex:indexPath.section];
//    WashCarTicketController *ticketVC = [[WashCarTicketController alloc] init];
//    ticketVC.hidesBottomBarWhenPushed = YES;
//    ticketVC.card = newcard;
//    ticketVC.CurrentScore = [NSString stringWithFormat:@"%@",_MembershipUserScore[@"UserScore"]];
//    [self.navigationController pushViewController:ticketVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 23*Main_Screen_Height/667;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor whiteColor];
    
    return v;
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 圆角弧度半径
//    CGFloat cornerRadius = 6.f;
//    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
//    cell.backgroundColor = UIColor.clearColor;
//
//    // 创建一个shapeLayer
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
//    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    // 获取cell的size
//    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
//    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
//
//    // CGRectGetMinY：返回对象顶点坐标
//    // CGRectGetMaxY：返回对象底点坐标
//    // CGRectGetMinX：返回对象左边缘坐标
//    // CGRectGetMaxX：返回对象右边缘坐标
//    // CGRectGetMidX: 返回对象中心点的X坐标
//    // CGRectGetMidY: 返回对象中心点的Y坐标
//
//    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
//
//    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//    if (indexPath.row == 0) {
//        // 初始起点为cell的左下角坐标
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//
//    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//        // 初始起点为cell的左上角坐标
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//    } else {
//        // 添加cell的rectangle信息到path中（不包括圆角）
//        CGPathAddRect(pathRef, nil, bounds);
//    }
//    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
//    layer.path = pathRef;
//    backgroundLayer.path = pathRef;
//    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
//    CFRelease(pathRef);
//    // 按照shape layer的path填充颜色，类似于渲染render
//    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
//    layer.fillColor = [UIColor whiteColor].CGColor;
//
//    // view大小与cell一致
//    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
//    // 添加自定义圆角后的图层到roundView中
//    [roundView.layer insertSublayer:layer atIndex:0];
//    roundView.backgroundColor = UIColor.clearColor;
//    // cell的背景view
//    cell.backgroundView = roundView;
//
//    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
//    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
//    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
//    backgroundLayer.fillColor = [UIColor cyanColor].CGColor;
//    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
//    selectedBackgroundView.backgroundColor = UIColor.clearColor;
//    cell.selectedBackgroundView = selectedBackgroundView;
//
//}
//
//
//
//
//#pragma mark - UICollectionView的数据源和代理
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 4;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    GoodsViewCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:id_goodsCell forIndexPath:indexPath];
//    goodsCell.backgroundColor = [UIColor whiteColor];
//
//    return goodsCell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    WashCarTicketController *ticketVC = [[WashCarTicketController alloc] init];
//    ticketVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:ticketVC animated:YES];
//}
//
//#pragma mark - item布局设置
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return CGSizeMake(140, 80);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//
//    return 36;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 36;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//
//    return UIEdgeInsetsMake(18, 23.75, 18, 23.75);
//}

-(void)noticeupdate:(NSNotification *)sender{
    
    
    [self GetMembershipUserScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
