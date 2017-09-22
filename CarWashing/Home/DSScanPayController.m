//
//  DSScanPayController.m
//  CarWashing
//
//  Created by Mac WuXinLing on 2017/9/1.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSScanPayController.h"
#import "DSStartWashingController.h"

#import <Masonry.h>
#import "CashViewController.h"
#import "BusinessPayCell.h"

#import "UdStorage.h"
#import "HTTPDefine.h"
#import "AFNetworkingTool.h"
#import "LCMD5Tool.h"

@interface DSScanPayController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *payTableView;

@property (nonatomic, strong) NSArray *payNameArray;
@property (nonatomic, strong) NSArray *payImageNameArr;

@property (nonatomic, strong) NSIndexPath *lastPath;

@property (nonatomic, weak) BusinessPayCell *seleCell;

@end

static NSString *payViewCell = @"payTableViewCell";
static NSString *id_paySelectCell = @"id_paySelectCell";

@implementation DSScanPayController

- (void)drawNavigation {
    
    [self drawTitle:@"支付"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(goBack) name:@"paysuccess" object:nil];
    
    
    
    
    
    
    NSArray *payNameArray = @[@"微信支付",@"支付宝支付"];
    NSArray *payImageNameArr = @[@"weixin",@"zhifubao"];
    self.payNameArray = payNameArray;
    self.payImageNameArr = payImageNameArr;
    
    [self setupUI];
}


- (void)setupUI {
    
    UITableView *payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height) style:UITableViewStyleGrouped];
    
    self.payTableView = payTableView;
    payTableView.delegate = self;
    payTableView.dataSource = self;
    payTableView.rowHeight = 50*Main_Screen_Height/667;
    
    [self.view addSubview:payTableView];
    
    [self.payTableView registerClass:[BusinessPayCell class] forCellReuseIdentifier:id_paySelectCell];
    
    //[payTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:payViewCell];
    //
    //    //选择支付方式
    //    UILabel *payLab = [[UILabel alloc] init];
    //    payLab.text = @"选择支付方式";
    //    [self.view addSubview:payLab];
    //
    //    //支付宝
    //    UIView *zhifubaoView = [[UIView alloc] init];
    //    zhifubaoView.backgroundColor = [UIColor whiteColor];
    //
    //    [self.view addSubview:zhifubaoView];
    //
    //
    //    //微信
    //    UIView *weixinView = [[UIView alloc] init];
    //    weixinView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:weixinView];
    //
    //    //约束
    //    [payLab mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(payTableView.mas_bottom).mas_offset(20);
    //        make.left.equalTo(self.view).mas_offset(20);
    //    }];
    //
    //    [zhifubaoView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.view);
    //        make.top.mas_equalTo(payLab.mas_bottom).mas_offset(10);
    //        make.height.mas_equalTo(60);
    //    }];
    //
    //    [weixinView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.view);
    //        make.top.mas_equalTo(zhifubaoView.mas_bottom).mas_offset(1);
    //        make.height.mas_equalTo(60);
    //    }];
    //
    //
    //    UIImageView *aliImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
    //    aliImageView.image = [UIImage imageNamed:@"messageA"];
    //
    //    UILabel *aliLable = [[UILabel alloc] init];
    //    aliLable.text = @"支付宝支付";
    //
    //    UIButton *aliBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 40, 15, 30, 30)];
    //
    //    [aliBtn setBackgroundImage:[UIImage imageNamed:@"搜索-更多-未选中"] forState:UIControlStateNormal];
    //    [aliBtn setBackgroundImage:[UIImage imageNamed:@"搜索-更多-已选中"] forState:UIControlStateHighlighted];
    //
    //    [zhifubaoView addSubview:aliImageView];
    //    [zhifubaoView addSubview:aliLable];
    //    [zhifubaoView addSubview:aliBtn];
    //
    //    [aliLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(aliImageView);
    //        make.leading.mas_equalTo(aliImageView.mas_trailing).mas_offset(10);
    //    }];
    //
    //
    //    UIImageView *weixinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
    //
    //    weixinImageView.image = [UIImage imageNamed:@"messageA"];
    //
    //    UILabel *weixinLable = [[UILabel alloc] init];
    //    weixinLable.text = @"微信支付";
    //
    //    UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 40, 15, 30, 30)];
    //
    //    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"搜索-更多-未选中"] forState:UIControlStateNormal];
    //    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"搜索-更多-已选中"] forState:UIControlStateHighlighted];
    //
    //    [weixinView addSubview:weixinImageView];
    //    [weixinView addSubview:weixinLable];
    //    [weixinView addSubview:weixinBtn];
    //
    //    [weixinLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(weixinView);
    //        make.leading.mas_equalTo(weixinImageView.mas_trailing).mas_offset(10);
    //    }];
    
    
    //底部支付栏
    UIView *payBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - 60*Main_Screen_Height/667, Main_Screen_Width, 60*Main_Screen_Height/667)];
    payBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payBottomView];
    
    UILabel *bottomPriceLab = [[UILabel alloc] init];
    bottomPriceLab.text = self.Xprice;
    bottomPriceLab.font = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
    bottomPriceLab.textColor = [UIColor colorFromHex:@"#ff525a"];
    [payBottomView addSubview:bottomPriceLab];
    
    [bottomPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(payBottomView).mas_offset(30*Main_Screen_Height/667);
        make.top.equalTo(payBottomView).mas_offset(20*Main_Screen_Height/667);
        
    }];
    
    UIButton *bottomPayButton = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 136*Main_Screen_Height/667, 0, 136*Main_Screen_Height/667, 60*Main_Screen_Height/667)];
    bottomPayButton.backgroundColor = [UIColor colorFromHex:@"#0161a1"];
    [bottomPayButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [bottomPayButton setTintColor:[UIColor whiteColor]];
    bottomPayButton.titleLabel.font = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
    
    //方法子
    [bottomPayButton addTarget:self action:@selector(showAlertWithTitle:message:) forControlEvents:UIControlEventTouchUpInside];
    
    [payBottomView addSubview:bottomPayButton];
    
    
}


//方法子
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    if (self.lastPath.row == 0) {
        message = @"蔷薇爱车想要打开微信";
    }else {
        message = @"蔷薇爱车想要打开支付宝";
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        DSStartWashingController    *startVC    = [[DSStartWashingController alloc]init];
//        startVC.hidesBottomBarWhenPushed        = YES;
//        [self.navigationController pushViewController:startVC animated:YES];
        
        
#pragma mark-扫码洗车 3.37自动扫码支付
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:Userid],
                                 @"DeviceCode":self.DeviceCode
                                 };
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        NSLog(@"%@",params);
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Payment/ScanPayment",Khttp] success:^(NSDictionary *dict, BOOL success) {
            NSLog(@"%@",dict);
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                NSDictionary *di = [NSDictionary dictionary];
                di = [dict objectForKey:@"JsonData"];
                
                NSMutableString *stamp = [di objectForKey:@"timestamp"];
                //调起微信支付
                PayReq *req= [[PayReq alloc] init];
                req.partnerId
                = [di objectForKey:@"partnerid"];
                req.prepayId
                = [di objectForKey:@"prepayid"];
                req.nonceStr
                = [di objectForKey:@"noncestr"];
                req.timeStamp
                = stamp.intValue;
                req.package
                = [di objectForKey:@"packag"];
                req.sign = [di objectForKey:@"sign"];
                BOOL result = [WXApi sendReq:req];
                
                NSLog(@"-=-=-=-=-%d", result);
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[di
                                                                                                            objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign
                      );
                
            }
            else
            {
                
          
                [self.view showInfo:@"信息获取失败,请检查网络" autoHidden:YES interval:2];
                
            }
            
            
            
            
        } fail:^(NSError *error) {
            NSLog(@"%@",error);
            [self.view showInfo:@"信息获取失败,请检查网络" autoHidden:YES interval:2];
        }];
        
        
        
        
        
        
        
        
        
        
        
        
        
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }
    else if(section == 2)
    {
        return 1;
    }
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *payCell = [tableView dequeueReusableCellWithIdentifier:payViewCell];
    
    payCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    payCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *shopTypeArr = @[@"服务商家",@"服务项目",@"订单金额"];
    NSArray *cashTypeArr = @[@"特惠活动",@"实付"];
    
    if (indexPath.section == 0) {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            payCell.textLabel.text = shopTypeArr[indexPath.row];
            payCell.detailTextLabel.text = self.SerMerChant;
            payCell.textLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
            payCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            payCell.detailTextLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
            payCell.detailTextLabel.textColor = [UIColor colorFromHex:@"#999999"];
        }else if (indexPath.section == 0 && indexPath.row == 1){
            
            payCell.textLabel.text = shopTypeArr[indexPath.row];
            payCell.detailTextLabel.text = self.SerProject;
            payCell.textLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
            payCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            payCell.detailTextLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
            payCell.detailTextLabel.textColor = [UIColor colorFromHex:@"#999999"];
        }
        else
        {
            payCell.textLabel.text = shopTypeArr[indexPath.row];
            payCell.detailTextLabel.text = self.Jprice;
            payCell.textLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
            payCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            payCell.detailTextLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
            payCell.detailTextLabel.textColor = [UIColor colorFromHex:@"#ff525a"];
        }
        
        
        
    }else if(indexPath.section == 1){
        payCell.textLabel.text = cashTypeArr[indexPath.row];
        if(indexPath.row == 0)
        {
            payCell.detailTextLabel.text = [NSString stringWithFormat:@"立减%.2f元",[[self.Jprice substringFromIndex:1] doubleValue] - [[self.Xprice substringFromIndex:1] doubleValue]];
            payCell.textLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
            payCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            payCell.detailTextLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
            payCell.detailTextLabel.textColor = [UIColor colorFromHex:@"#ff525a"];
        }
        else
        {
            payCell.detailTextLabel.text = self.Xprice;
            payCell.textLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
            payCell.textLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
            payCell.detailTextLabel.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
            payCell.detailTextLabel.textColor = [UIColor colorFromHex:@"#ff525a"];
        }
        
    }
    else{
        BusinessPayCell *cell = [tableView dequeueReusableCellWithIdentifier:id_paySelectCell forIndexPath:indexPath];
        _seleCell = cell;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:self.payImageNameArr[indexPath.row]];
        cell.textLabel.text = self.payNameArray[indexPath.row];
        cell.textLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
        cell.textLabel.font = [UIFont systemFontOfSize:15*Main_Screen_Height/667];
        
        //        UIButton *payWayBtn = [[UIButton alloc] init];
        //        [payWayBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        //        [payWayBtn setImage:[UIImage imageNamed:@"xaunzhong"] forState:UIControlStateSelected];
        //        [payCell.contentView addSubview:payWayBtn];
        
        //        [payWayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.equalTo(payCell.contentView);
        //            make.right.equalTo(payCell.contentView).mas_offset(-12);
        //            make.width.mas_equalTo(21);
        //            make.height.mas_equalTo(21);
        //        }];
        
        //单选支付
        NSInteger row = [indexPath row];
        NSInteger oldRow = [self.lastPath row];
        
        if (row == oldRow && self.lastPath != nil) {
            [cell.payWayBtn setBackgroundImage:[UIImage imageNamed:@"xaunzhong"] forState:UIControlStateNormal];
        }else{
            
            [cell.payWayBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        }
        
        return cell;
        
    }
    
    
    
    return payCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && indexPath.row == 0 ) {
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        return nil;
    }
    
    UILabel *wayLabel = [[UILabel alloc] init];
    wayLabel.text = @"  请选择支付方式";
    wayLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    wayLabel.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    
    
    return wayLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        return 30*Main_Screen_Height/667;
    }
    
    return 10*Main_Screen_Height/667;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10*Main_Screen_Height/667;
}


#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        CashViewController *cashVC = [[CashViewController alloc] init];
        //cashVC.providesPresentationContextTransitionStyle = YES;
        //cashVC.definesPresentationContext = YES;
        cashVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:cashVC animated:NO completion:nil];
    }
    
    if (indexPath.section == 2) {
        
        NSInteger newRow = [indexPath row];
        NSInteger oldRow = (self.lastPath != nil)?[self.lastPath row]:-1;
        
        if (newRow != oldRow) {
            self.seleCell = [tableView cellForRowAtIndexPath:indexPath];
            
            [self.seleCell.payWayBtn setBackgroundImage:[UIImage imageNamed:@"xaunzhong"] forState:UIControlStateNormal];
            
            self.seleCell = [tableView cellForRowAtIndexPath:self.lastPath];
            
            [self.seleCell.payWayBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
            
            self.lastPath = indexPath;
            
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.payTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] animated:YES scrollPosition:UITableViewScrollPositionNone];
    if ([_payTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_payTableView.delegate tableView:_payTableView didSelectRowAtIndexPath:indexPath];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack
{
    DSStartWashingController *start = [[DSStartWashingController alloc]init];
    
    NSDate*date                     = [NSDate date];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString *dateString        = [dateFormatter stringFromDate:date];
    [UdStorage storageObject:dateString forKey:@"setTime"];
    
    
   
    start.paynum=[UdStorage getObjectforKey:@"Jprice"];
    start.RemainCount = [UdStorage getObjectforKey:@"RemainCount"];
    start.IntegralNum = [UdStorage getObjectforKey:@"IntegralNum"];
    start.CardType = [UdStorage getObjectforKey:@"CardType"];
    start.CardName =[UdStorage getObjectforKey:@"CardName"];    start.second=240;
    
    
    [self.navigationController pushViewController:start animated:YES];
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
