//
//  ShopIntroController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/7/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "ShopIntroController.h"
#import "ShopInfoHeadView.h"
//#import "BusinessMapController.h"
#import "HTTPDefine.h"
#import <Masonry.h>
#import "JXMapNavigationView.h"
#define kColorTableBG [UIColor colorWithHex:0xf0f0f0]
@interface ShopIntroController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) ShopInfoHeadView *infoHeadView;

@property (nonatomic, weak) UITableView *infoTableView;

#pragma mark - map
@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;

@end

static NSString *id_infoCell = @"id_infoCell";

@implementation ShopIntroController

- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}

- (ShopInfoHeadView *)infoHeadView {
    
    if (!_infoHeadView) {
        ShopInfoHeadView *infoHeadView = [ShopInfoHeadView shopInfoHeadView];
        _infoHeadView = infoHeadView;
        [self.view addSubview:_infoHeadView];
    }
    return _infoHeadView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    self.infoTableView.backgroundColor=kColorTableBG;
    self.infoHeadView.backgroundColor=[UIColor whiteColor];
    self.infoTableView.backgroundColor=kColorTableBG;
    
}

- (void)setupUI {
    
    self.infoHeadView.frame = CGRectMake(0, 0, Main_Screen_Width, 280*Main_Screen_Height/667);
    
    self.infoHeadView.namelabel.text = self.dic[@"MerName"];
    self.infoHeadView.addresslabel.text = self.dic[@"MerAddress"];
    if([self.dic[@"ShopType"] intValue] == 1)
    {
        self.infoHeadView.typelabel.text = @"洗车服务";
    }
    
    
    self.infoHeadView.freeCheckLabel.hidden = YES;
    self.infoHeadView.qualityProtectedLabel.hidden = YES;
    
    NSArray *lab = [[self.dic objectForKey:@"MerFlag"] componentsSeparatedByString:@","];
    UILabel *MerflagsLabel;
    for (int i = 0; i < [lab count]; i++) {
        MerflagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*Main_Screen_Height/667 + i % 3 * 67*Main_Screen_Height/667,  199*Main_Screen_Height/667, 60*Main_Screen_Height/667, 15*Main_Screen_Height/667)];
        MerflagsLabel.text = lab[i];
//        MerflagsLabel.backgroundColor = [UIColor redColor];
        [MerflagsLabel setFont:[UIFont fontWithName:@"Helvetica" size:11*Main_Screen_Height/667]];
//        MerflagsLabel.textColor = [UIColor colorFromHex:@"#fefefe"];
//        MerflagsLabel.backgroundColor = [UIColor colorFromHex:@"#ff7556"];
        MerflagsLabel.textColor = [UIColor colorFromHex:@"#a8c4d7"];
        //                MerflagsLabel.backgroundColor = [UIColor colorFromHex:@"#ff7556"];
        MerflagsLabel.backgroundColor = [UIColor whiteColor];
        MerflagsLabel.textAlignment = NSTextAlignmentCenter;
//        MerflagsLabel.layer.borderColor=[UIColor colorFromHex:@"#dfdfdf"].CGColor;
        MerflagsLabel.layer.borderColor=[UIColor colorFromHex:@"#a8c4d7"].CGColor;
  
        MerflagsLabel.layer.borderWidth=0.8;
        MerflagsLabel.textAlignment = NSTextAlignmentCenter;
        MerflagsLabel.layer.masksToBounds = YES;
        MerflagsLabel.layer.cornerRadius = 7.5*Main_Screen_Height/667;
        [self.infoHeadView addSubview:MerflagsLabel];
    }

    

    UITableView *infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64 - 44*Main_Screen_Height/667) style:UITableViewStylePlain];
    _infoTableView = infoTableView;
    [self.view addSubview:_infoTableView];
    
    infoTableView.delegate = self;
    infoTableView.dataSource = self;
    
    
    infoTableView.tableHeaderView = self.infoHeadView;
    infoTableView.rowHeight = 200*Main_Screen_Height/667;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:id_infoCell];
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    
    
    UIImageView *infoImageView = [[UIImageView alloc] init];
//    infoImageView.image = [UIImage imageNamed:@"hangdiantu"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,self.dic[@"Img"]];
        NSURL *url=[NSURL URLWithString:ImageURL];
        NSData *data=[NSData dataWithContentsOfURL:url];
        UIImage *img=[UIImage imageWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^{
            infoImageView.image = img;
        });
    });
    infoImageView.frame = CGRectMake(0, 0, Main_Screen_Width, 200*Main_Screen_Height/667);
    [cell.contentView addSubview:infoImageView];
    

    
    return cell;
}

- (IBAction)skipToMapView:(id)sender {
    
//    BusinessMapController *mapVC = [[BusinessMapController alloc] init];
//    mapVC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:mapVC animated:YES];
    
    [self.mapNavigationView showMapNavigationViewWithtargetLatitude:22.488260 targetLongitute:113.915049 toName:@"中海油华英加油站"];
    [self.view addSubview:_mapNavigationView];
    
}



- (IBAction)didClickShopPhone:(id)sender {
    
    NSString *message = @"是否拨打商家电话";
    NSString *title = @"";
    [self showAlertWithTitle:title message:message];
    
}


//方法子
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [PhoneHelper dial: self.dic[@"MerPhone"]];
        
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
