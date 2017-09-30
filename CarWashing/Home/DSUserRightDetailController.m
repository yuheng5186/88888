//
//  DSUserRightDetailController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/8.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSUserRightDetailController.h"
#import "UIWindow+YzdHUD.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "MBProgressHUD.h"
#import "UdStorage.h"
#import "Mylabel.h"
#import "CardConfigGrade.h"

#import <Masonry.h>

@interface DSUserRightDetailController ()
{
    CardConfigGrade *card;
    MBProgressHUD *HUD;
}

@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) UIButton    *getButton;
@end

@implementation DSUserRightDetailController

- (void) drawNavigation {
    
    [self drawTitle:@"新用户注册奖励"];
}
- (void) drawContent {
    self.contentView.top        = self.navigationView.bottom;
    self.contentView.height     = self.view.height;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    card = [[CardConfigGrade alloc]init];
    // Do any additional setup after loading the view.
    _dic = [[NSDictionary alloc]init];
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide =YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
    
    [self GetCouponDetail];
    
}
- (void) createSubView {

    UIView *upView                  = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*328/667) color:[UIColor colorFromHex:@"#fafafa"]];
    upView.top                      = 0;
    
    
    UIImageView *backgroundImageView;
//    bg_card
    
    backgroundImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(22.5*Main_Screen_Height/667, 0, Main_Screen_Width-45*Main_Screen_Height/667, 190*Main_Screen_Height/667) imageName:@"bg_card"];
    
    
//    if([_dic[@"CardType"] intValue] == 1)
//    {
//        backgroundImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(22.5*Main_Screen_Height/667, 0, Main_Screen_Width-45*Main_Screen_Height/667, 190*Main_Screen_Height/667) imageName:@"qw_tiyanka"];
//    }else if([_dic[@"CardType"] intValue] == 2)
//    {
//        backgroundImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(22.5*Main_Screen_Height/667, 0, Main_Screen_Width-45*Main_Screen_Height/667, 190*Main_Screen_Height/667) imageName:@"qw_yueka"];
//    }else if([_dic[@"CardType"] intValue] == 3)
//    {
//        backgroundImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(22.5*Main_Screen_Height/667, 0, Main_Screen_Width-45*Main_Screen_Height/667, 190*Main_Screen_Height/667) imageName:@"qw_cika"];
//    }else if([_dic[@"CardType"] intValue] == 4)
//    {
//        backgroundImageView      = [UIUtil drawCustomImgViewInView:upView frame:CGRectMake(22.5*Main_Screen_Height/667, 0, Main_Screen_Width-45*Main_Screen_Height/667, 190*Main_Screen_Height/667) imageName:@"qw_nianka"];
//    }
    
    backgroundImageView.top               = Main_Screen_Height*25/667;
    backgroundImageView.centerX           = upView.centerX;
    
//    NSString *showString             = _dic[@"CardName"];
//    UIFont    *showFont              = [UIFont boldSystemFontOfSize:18*Main_Screen_Height/667];
//    UILabel     *showlabel           = [UIUtil drawLabelInView:backgroundImageView frame:[UIUtil textRect:showString font:showFont] font:showFont text:showString isCenter:NO];
//    showlabel.left                   = Main_Screen_Width*20/375;
//    showlabel.top                    = Main_Screen_Height*20/667;
    
    
    
    
    
    
//    NSString *showString2             = @"金顶洗车";
//    UIFont    *showFont2              = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
//    Mylabel     *showlabel2           = [[Mylabel alloc]initWithFrame:CGRectMake(0, Main_Screen_Height*20/667, Main_Screen_Width*200/375, Main_Screen_Height*50/667)];
//    showlabel2.font = showFont2;
//    showlabel2.text = showString2;
//    [showlabel2 setVerticalAlignment:VerticalAlignmentBottom];
//    showlabel2.bottom   = showlabel.bottom;
//    showlabel2.left     = showlabel.right +Main_Screen_Width*10/375;
//    [backgroundImageView addSubview:showlabel2];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *datenow = [NSDate date];
    
    NSString *showString3             =  [NSString stringWithFormat:@"有效期至: %@",[self DateZhuan:_dic[@"ExpiredTimes"]]];
    
    UIFont    *showFont3              = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
    UILabel     *showlabel3           = [UIUtil drawLabelInView:backgroundImageView frame:[UIUtil textRect:showString3 font:showFont3] font:showFont3 text:showString3 isCenter:NO];
    showlabel3.textColor              = [UIColor colorFromHex:@"#999999"];
    showlabel3.left                   = Main_Screen_Width*25/375;
    showlabel3.bottom                 = backgroundImageView.height - Main_Screen_Height*18/667;
    
    NSString *showString33             = [NSString stringWithFormat:@"%@",_dic[@"CardName"]];
    UIFont    *showFont33             = [UIFont systemFontOfSize:18*Main_Screen_Height/667];
    UILabel     *showlabel33           = [UIUtil drawLabelInView:backgroundImageView frame:[UIUtil textRect:showString33 font:showFont33] font:showFont33 text:showString33 isCenter:NO];
    showlabel33.textColor =               [UIColor colorFromHex:@"#4a4a4a"];
    showlabel33.left                   = Main_Screen_Width*25/375;
    showlabel33.top                    = Main_Screen_Height*20/667;
    
    NSString *jindingString            = @"金顶洗车";
    UIFont    *jindingFont             = [UIFont systemFontOfSize:10*Main_Screen_Height/667];
    UILabel     *jindingLabel          = [UIUtil drawLabelInView:backgroundImageView frame:[UIUtil textRect:jindingString font:jindingFont] font:jindingFont text:jindingString isCenter:NO];
    jindingLabel.textColor             = [UIColor colorFromHex:@"#4a4a4a"];
    jindingLabel.left                   = showlabel33.right +Main_Screen_Width*5/375;
    jindingLabel.bottom                 = showlabel33.bottom;
    
    NSString *saomaString            = @"扫码洗车服务中使用";
    UIFont    *saomaFont             = [UIFont systemFontOfSize:12*Main_Screen_Height/667];
    UILabel     *saomaLabel          = [UIUtil drawLabelInView:backgroundImageView frame:[UIUtil textRect:saomaString font:saomaFont] font:saomaFont text:saomaString isCenter:NO];
    saomaLabel.textColor             = [UIColor colorFromHex:@"#4a4a4a"];
    saomaLabel.left                  = showlabel33.left;
    saomaLabel.top                   = showlabel33.bottom +Main_Screen_Height*5/667;
    
    
    NSString *string;
    if([_dic[@"IsReceive"] intValue] == 1)
    {
        string        = @"立即领取";
        _getButton  = [UIUtil drawDefaultButton:upView title:string target:self action:@selector(getButtonClick:)];
        
    }
    else
    {
        string        = @"已领取";
        _getButton  = [UIUtil drawDefaultButton:upView title:string target:self action:nil];
        [_getButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHex:@"#e6e6e6"]] forState:UIControlStateNormal];
        _getButton.enabled = NO;
    }
    
    
    
    _getButton.top           = backgroundImageView.bottom +Main_Screen_Height*50/667;
    _getButton.centerX       = Main_Screen_Width/2;
    upView.height           = _getButton.bottom +Main_Screen_Height*50/667;
    
    
    UIView *downView                = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*270/667) color:[UIColor whiteColor]];
    downView.top                    = upView.bottom;
    //
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"使用须知";
    noticeLabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    noticeLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    [downView addSubview:noticeLabel];
    
    
    UILabel *noticeLabel1 = [[UILabel alloc] init];
    noticeLabel1.text = @"1. 下载金顶洗车APP，通过扫码可直接启动洗车机；";
    noticeLabel1.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel1.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel1.numberOfLines = 0;
    [downView addSubview:noticeLabel1];
    
    
    UILabel *noticeLabel2 = [[UILabel alloc] init];
    noticeLabel2.text = @"2. 整个洗车过程请遵照洗车提示和工作人员引导；";
    noticeLabel2.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel2.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel2.numberOfLines = 0;
    [downView addSubview:noticeLabel2];
    
    
    UILabel *noticeLabel3 = [[UILabel alloc] init];
    noticeLabel3.text = @"3. 此卡请在有效期内使用，不退卡、不转让、不挂失；";
    noticeLabel3.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel3.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel3.numberOfLines = 0;
    [downView addSubview:noticeLabel3];
    
    
    UILabel *noticeLabel4 = [[UILabel alloc] init];
    noticeLabel4.text = @"4. 启动前请确保外置天线、反光镜已经收起，车窗等处于关闭、全车处于隔水状态，自行改装外饰确保不妨碍洗车；";
    noticeLabel4.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel4.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel4.numberOfLines = 0;
    [downView addSubview:noticeLabel4];
    
    
    UILabel *noticeLabel5 = [[UILabel alloc] init];
    noticeLabel5.text = @"5. 请不要在洗车过程中随意上下车，若出现问题或者故障可咨询工作人员或拨打客服电话进行咨询";
    noticeLabel5.textColor = [UIColor colorFromHex:@"#999999"];
    noticeLabel5.font = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
    noticeLabel5.numberOfLines = 0;
    [downView addSubview:noticeLabel5];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(downView).mas_offset(10*Main_Screen_Height/667);
    }];
    
    [noticeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [noticeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel1.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
}];
    
    [noticeLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel2.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [noticeLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel3.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    [noticeLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(noticeLabel);
        make.top.equalTo(noticeLabel4.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.right.equalTo(downView).mas_offset(-10*Main_Screen_Height/667);
    }];
    
    
    
//    NSString *useString             = @"使用须知";
//    UIFont    *useFont              = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
//    UILabel     *uselabel           = [UIUtil drawLabelInView:downView frame:CGRectMake(0, 0, Main_Screen_Width*100/375, Main_Screen_Height*20/667) font:useFont text:useString isCenter:NO];
//    uselabel.backgroundColor = [UIColor redColor];
//    uselabel.textColor              = [UIColor colorFromHex:@"#4a4a4a"];
//    uselabel.left                   = Main_Screen_Width*10/375;
//    uselabel.top                    = Main_Screen_Height*10/667;
//    
//    NSString *useString1             = @"1、此卡仅限清洗汽车外观，不得购买其它服务项目";
//    UIFont    *useFont1              = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
//    UILabel     *uselabel1           = [UIUtil drawLabelInView:downView frame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*20/375, Main_Screen_Height*40/667) font:useFont1 text:useString1 isCenter:NO];
//    uselabel1.textColor              = [UIColor colorFromHex:@"#999999"];
//    uselabel1.numberOfLines          = 0;
//    uselabel1.centerX                = downView.width/2;
//    uselabel1.top                    = uselabel.bottom +Main_Screen_Height*10/667;
//    
//    NSString *useString2             = @"2、洗车卡不能兑换现金和转赠与其他人使用";
//    UIFont    *useFont2              = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
//    UILabel     *uselabel2           = [UIUtil drawLabelInView:downView frame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*20/375, Main_Screen_Height*40/667) font:useFont2 text:useString2 isCenter:NO];
//    uselabel2.textColor              = [UIColor colorFromHex:@"#999999"];
//    uselabel2.backgroundColor = [UIColor blueColor];
//    uselabel2.numberOfLines          = 0;
//    uselabel2.centerX                = Main_Screen_Width/2;
//    uselabel2.top                    = uselabel1.bottom +Main_Screen_Height*5/667;
//    
//    NSString *useString3             = @"3、此卡一经售出，概不兑现。不记名，不挂失，不退卡，不补办";
//    UIFont    *useFont3              = [UIFont systemFontOfSize:14*Main_Screen_Height/667];
//    UILabel     *uselabel3           = [UIUtil drawLabelInView:downView frame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*20/375, Main_Screen_Height*40/667) font:useFont3 text:useString3 isCenter:NO];
//    uselabel3.backgroundColor = [UIColor redColor];
//    uselabel3.textColor              = [UIColor colorFromHex:@"#999999"];
//    uselabel3.numberOfLines          = 0;
//    uselabel3.centerX                = Main_Screen_Width/2;
//    uselabel3.top                    = uselabel2.bottom +Main_Screen_Height*5/667;
}

-(NSString *)DateZhuan:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
    NSDateFormatter*outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString*str = [outputFormatter stringFromDate:inputDate];
    return str;
}

-(void)GetCouponDetail
{
    NSDictionary *mulDic = @{
                             @"ConfigCode":self.ConfigCode,
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"]
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/CardConfigDetail",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            
            _dic = [dict objectForKey:@"JsonData"];
            
            [card setValuesForKeysWithDictionary:_dic];
//            [_CouponListData addObjectsFromArray:arr];
//            [self.tableView reloadData];
//            NSLog(@"%@",card);
            
            [self createSubView];
            
            [HUD setHidden:YES];
        }
        else
        {
            [self.view showInfo:@"信息获取失败" autoHidden:YES interval:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        [self.view showInfo:@"获取失败" autoHidden:YES interval:2];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}


- (void) getButtonClick:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datenow = [NSDate date];
    
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             @"ConfigCode":self.ConfigCode,
                             @"UseLevel":@1,
                             @"GetCardType":@2,
                             @"Area":_dic[@"Area"],
                             @"CardCount":[NSString stringWithFormat:@"%ld",card.CardCount],
                             @"CardName":card.CardName,
                             @"CardPrice":[NSString stringWithFormat:@"%@",card.CardPrice],
                             @"CardType":[NSString stringWithFormat:@"%ld",card.CardType],
                             @"Description":card.Description,
                             @"ExpStartDates":[NSString stringWithFormat:@"%@",[formatter stringFromDate:datenow]],
                             @"ExpEndDates":[NSString stringWithFormat:@"%@",_dic[@"ExpiredTimes"]],
                             @"Integralnum": @1
                             };
    
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@Card/ReceiveCardInfo",Khttp] success:^(NSDictionary *dict, BOOL success) {
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            
            [self.view.window showHUDWithText:@"恭喜您领取成功，已经放入您的卡券中" Type:ShowPhotoYes Enabled:YES];
            
            
            
//            NSInteger num = [[_dic objectForKey:@"IsReceive"] intValue] + 1;
            
//            [_dic setObject:[NSString stringWithFormat:@"%ld",num] forKey:@"IsReceive"];
            
            [_getButton setTitle:@"已领取" forState:UIControlStateNormal];
            [_getButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHex:@"#e6e6e6"]] forState:UIControlStateNormal];

            _getButton.enabled = NO;
            
            
        }
        else
        {
            [self.view showInfo:@"领取失败" autoHidden:YES interval:2];
        }
    } fail:^(NSError *error) {
        [self.view showInfo:@"领取失败" autoHidden:YES interval:2];
        
    }];


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
