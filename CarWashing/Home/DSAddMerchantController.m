//
//  DSAddMerchantController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/8/8.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSAddMerchantController.h"

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "HTTPDefine.h"
#import "MBProgressHUD.h"

@interface DSAddMerchantController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LKAlertViewDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *merchantFieldText;
@property (nonatomic, strong) UITextField *phoneFieldText;
@property (nonatomic, strong) UITextField *addressFieldText;

@end

@implementation DSAddMerchantController

- (void) drawNavigation {

    [self drawTitle:@"商家入驻"];
    [self drawRightTextButton:@"提交" action:@selector(rightButtonClick:)];
}

- (void) drawContent
{
    self.contentView.top                = self.statusView.bottom;
    self.contentView.backgroundColor    = [UIColor colorFromHex:@"#111112"];
    
}
- (void) rightButtonClick:(id)sender {
    
    if (self.phoneFieldText.text.length >0 && self.merchantFieldText.text.length > 0 && self.addressFieldText.text.length > 0) {
    if ([LCMD5Tool valiMobile:self.phoneFieldText.text]) {
        
        
            
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.removeFromSuperViewOnHide =YES;
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"加载中";
            HUD.minSize = CGSizeMake(132.f, 108.0f);
            
            
            NSDictionary *mulDic = @{
                                     @"Name":self.merchantFieldText.text,
                                     @"Phone":self.phoneFieldText.text,
                                     @"Address":self.addressFieldText.text
                                     };
            NSDictionary *params = @{
                                     @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                     @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                     };
            
            [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@MerChant/AddMerchantSettledInfo",Khttp] success:^(NSDictionary *dict, BOOL success) {
                if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                {
                    __weak typeof(self) weakSelf = self;
                    
                    
                    HUD.completionBlock = ^(){
                        [weakSelf.view showInfo:@"入驻成功" autoHidden:YES interval:2];
                    };
                    
                    LKAlertView *alartView      = [[LKAlertView alloc]initWithTitle:@"恭喜您提交成功" message:@"客服将在24小时以内联系您" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alartView.tag               = 110;
                    [alartView show];
                    
                    
                    [HUD hide:YES afterDelay:1.f];
                }
                else
                {
                    [HUD setHidden:YES];
                    [self.view showInfo:@"网络异常，信息提交失败" autoHidden:YES interval:2];
                }
                
                
                
                
                
                
            } fail:^(NSError *error) {
                [HUD setHidden:YES];
                [self.view showInfo:@"网络异常，信息提交失败" autoHidden:YES interval:2];
            }];
            
        }else {
            
            
            [self.view showInfo:@"联系电话不存在，请检查是否正确！" autoHidden:YES];
        }
        
    }else {
    
        [self.view showInfo:@"请填写完整信息再提交" autoHidden:YES];

    }
    
    
    

    
    
}

#pragma mark ---LKAlertViewDelegate---
- (void)alertView:(LKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        NSLog(@"确定");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSubView];
}

- (void) createSubView {

    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height) style:UITableViewStyleGrouped];
    self.tableView.top              = Main_Screen_Height*10/667;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.scrollEnabled    = NO;
    self.tableView.tableFooterView  = [UIView new];
    self.tableView.tableHeaderView  = [UIView new];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.contentView addSubview:self.tableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section

{
    return 10.0f*Main_Screen_Height/667;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*Main_Screen_Height/667;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.backgroundColor    = [UIColor whiteColor];
//    cell.textLabel.textColor    = [UIColor colorFromHex:@"#999999"];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text                   = @"商家名称";
            self.merchantFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*150/375, Main_Screen_Height*40/667)];
            self.merchantFieldText.placeholder    = @"请填写商家名称";
            self.merchantFieldText.delegate       = self;
            self.merchantFieldText.returnKeyType  = UIReturnKeyDone;
            self.merchantFieldText.textAlignment  = NSTextAlignmentLeft;
            self.merchantFieldText.font           = [UIFont systemFontOfSize:14];
            self.merchantFieldText.backgroundColor= [UIColor whiteColor];
            self.merchantFieldText.top            = Main_Screen_Height*5/667;
            self.merchantFieldText.left           = Main_Screen_Width*120/375 ;
            
            [self.merchantFieldText addTarget:self action:@selector(merchantFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:self.merchantFieldText];
        }
    }else {
    
        if (indexPath.row == 0) {
            cell.textLabel.text                = @"联系电话";
            self.phoneFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*150/375, Main_Screen_Height*40/667)];
            self.phoneFieldText.placeholder    = @"请填写联系电话";
            self.phoneFieldText.delegate       = self;
            self.phoneFieldText.returnKeyType  = UIReturnKeyDone;
            self.phoneFieldText.keyboardType   = UIKeyboardTypeNumberPad;
            self.phoneFieldText.textAlignment  = NSTextAlignmentLeft;
            self.phoneFieldText.font           = [UIFont systemFontOfSize:14];
            self.phoneFieldText.backgroundColor= [UIColor whiteColor];
            self.phoneFieldText.top            = Main_Screen_Height*5/667;
            self.phoneFieldText.left           = Main_Screen_Width*120/375 ;
            
            [self.phoneFieldText addTarget:self action:@selector(phoneFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:self.phoneFieldText];
        }else {
            cell.textLabel.text                  = @"联系地址";
            self.addressFieldText                = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-Main_Screen_Width*150/375, Main_Screen_Height*40/667)];
            self.addressFieldText.placeholder    = @"请填写联系地址";
            self.addressFieldText.delegate       = self;
            self.addressFieldText.returnKeyType  = UIReturnKeyDone;
            self.addressFieldText.textAlignment  = NSTextAlignmentLeft;
            self.addressFieldText.font           = [UIFont systemFontOfSize:14];
            self.addressFieldText.backgroundColor= [UIColor whiteColor];
            self.addressFieldText.top            = Main_Screen_Height*5/667;
            self.addressFieldText.left           = Main_Screen_Width*120/375 ;
            
            [self.addressFieldText addTarget:self action:@selector(addressFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:self.addressFieldText];
        }
    
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (void) merchantFieldTextChanged:(UITextField *)sender {

    
}
- (void) phoneFieldTextChanged:(UITextField *)sender {
    
    
}
- (void) addressFieldTextChanged:(UITextField *)sender {
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.merchantFieldText resignFirstResponder];
    [self.phoneFieldText resignFirstResponder];
    [self.addressFieldText resignFirstResponder];

    [self.view endEditing:YES];
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
