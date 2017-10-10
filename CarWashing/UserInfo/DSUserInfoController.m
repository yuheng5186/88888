//
//  DSUserInfoController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/20.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSUserInfoController.h"
#import "AppDelegate.h"
#import "DSChangePhoneController.h"
#import "DSChangeNameController.h"
#import<AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "UIImageView+WebCache.h"
#import "HowToUpGradeController.h"
#import "EarnScoreController.h"
#import "DSMembershipController.h"

#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "UdStorage.h"
#import "HTTPDefine.h"

@interface DSUserInfoController ()<UITableViewDelegate,UITableViewDataSource,LKActionSheetDelegate,LKAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *sexString;
@property (nonatomic, strong) UIImageView *userImageView;

@end

@implementation DSUserInfoController

- (void)drawNavigation {
    
    [self drawTitle:@"个人信息"];
    
}


- (void) drawContent
{
    self.contentView.top                = self.statusView.bottom;
    self.contentView.backgroundColor    = [UIColor colorFromHex:@"#111112"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticeupdateUserName:) name:@"updatenamesuccess" object:nil];
    [center addObserver:self selector:@selector(noticeupdateUserName:) name:@"updatephonesuccess" object:nil];
    self.sexString = @"未填写";
    [self createSubView];

}

- (void) createSubView {
    self.tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width,Main_Screen_Height) style:UITableViewStyleGrouped];
    self.tableView.top              = 0;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.scrollEnabled    = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView  = [UIView new];
    self.tableView.tableHeaderView  = [UIView new];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        default:
            break;
    }
    return 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80*Main_Screen_Height/667;
    }else{
        return 50*Main_Screen_Height/667;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStatic = @"cellStatic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStatic];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.backgroundColor    = [UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor    = [UIColor blackColor];
    cell.textLabel.font         = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font   = [UIFont systemFontOfSize:14];
    
    if (indexPath.section == 0) {
        cell.textLabel.text     = @"头像";
        self.userImageView  = [UIUtil drawCustomImgViewInView:cell.contentView frame:CGRectMake(0,Main_Screen_Height*10/667, Main_Screen_Width*60/375, Main_Screen_Height*60/667) imageName:@"huiyuantou"];
        
        NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,APPDELEGATE.currentUser.userImagePath];
        NSURL *url=[NSURL URLWithString:ImageURL];
        [self.userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"huiyuantou"]];
      
        self.userImageView.left          = Main_Screen_Width*275/375;
        self.userImageView.layer.masksToBounds = YES;
        self.userImageView.layer.cornerRadius = Main_Screen_Height*30/667;
        
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text         = @"姓名";
            cell.detailTextLabel.text   = APPDELEGATE.currentUser.userName;
            
        }else if (indexPath.row == 1){
            cell.textLabel.text         = @"手机号";
            NSString  *number = APPDELEGATE.currentUser.userPhone;
            NSString *userName              = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];

            cell.detailTextLabel.text   = userName;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text         = @"性别";
            if([APPDELEGATE.currentUser.userSex isKindOfClass:[NSNull null]])
            {
                cell.detailTextLabel.text   = self.sexString;
            }
            else if([APPDELEGATE.currentUser.userSex isEqual:@"0"])
            {
                cell.detailTextLabel.text   = @"男";
            }
            else
            {
                cell.detailTextLabel.text   = @"女";
            }
            
        }else {
        
            cell.textLabel.text         = @"微信绑定";
            cell.detailTextLabel.text   = @"去绑定";
        }
        
    }
    else{

    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            //无权限 做一个友好的提示
//            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]; [alart show]; return ;
            
        } else {
            LKActionSheet *avatarSheet  = [[LKActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
            avatarSheet.tag             = 1001;
            [avatarSheet showInView:[AppDelegate sharedInstance].window.rootViewController.view];
        }
        
        
        

        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            DSChangeNameController  *changeNameController   = [[DSChangeNameController alloc]init];
            changeNameController.hidesBottomBarWhenPushed   = YES;
            [self.navigationController pushViewController:changeNameController animated:YES];
            
        }else if (indexPath.row == 1){
        
            DSChangePhoneController *changePhone    = [[DSChangePhoneController alloc]init];
            changePhone.hidesBottomBarWhenPushed    = YES;
            [self.navigationController pushViewController:changePhone animated:YES];
            
        }else if (indexPath.row == 2){
            LKActionSheet *actionSheet = [[LKActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
            
            
            [actionSheet showInView:[AppDelegate sharedInstance].window.rootViewController.view];
        }else {
            
            LKAlertView *alartView      = [[LKAlertView alloc]initWithTitle:nil message:@"”金顶洗车“想要打开“微信”" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
            [alartView show];
        }

    }
    
}

#pragma mark - LKActionSheetDelegate
- (void)actionSheet:(LKActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 1001) {
        
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                    UIImagePickerController *picker     = [[UIImagePickerController alloc] init];
                    picker.sourceType                   = sourceType;
                    picker.delegate                     = self;
                    picker.allowsEditing                = YES;
                    [self presentViewController:picker animated:YES completion:nil];
                }
            }
                break;
            case 1:
            {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                    UIImagePickerController *picker     = [[UIImagePickerController alloc] init];
                    picker.sourceType                   = sourceType;
                    picker.delegate                     = self;
                    picker.allowsEditing                = YES;
                    [self presentViewController:picker animated:YES completion:nil];
                }
            }
                break;
            default:
                break;
        }

    }
    else {
        UITableViewCell *cell   = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        switch (buttonIndex) {
            case 0:
            {
                self.sexString = @"男";
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                NSDictionary *mulDic = @{
                                         @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                         @"ModifyType":@"4",
                                         @"Sex":@"0"
                                         };
                NSDictionary *params = @{
                                         @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                         @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                         };
                [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/UserInfoEdit",Khttp] success:^(NSDictionary *dict, BOOL success) {
                    
                    if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                    {
                        APPDELEGATE.currentUser.userSex = @"0";
                        [self.tableView reloadData];
                        
                        
                        [UdStorage storageObject:APPDELEGATE.currentUser.userSex forKey:@"Sex"];
                    }else
                    {
                        [self.view showInfo:@"设置失败" autoHidden:YES interval:2];
                    }
                    
                
                    
                    
                    
                    
                } fail:^(NSError *error) {
                    [self.view showInfo:@"设置失败" autoHidden:YES interval:2];
                }];
                
                
                
                
                
            }
                break;
            case 1:
            {
                self.sexString = @"女";
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                
                NSDictionary *mulDic = @{
                                         @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                         @"ModifyType":@"4",
                                         @"Sex":@"1"
                                         };
                NSDictionary *params = @{
                                         @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                         @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                         };
                [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/UserInfoEdit",Khttp] success:^(NSDictionary *dict, BOOL success) {
                    
                    if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
                    {
                        APPDELEGATE.currentUser.userSex = @"1";
                        
                        [self.tableView reloadData];
                        
                        [UdStorage storageObject:APPDELEGATE.currentUser.userSex forKey:@"Sex"];
                    }
                    else
                    {
                        [self.view showInfo:@"设置失败" autoHidden:YES interval:2];
                    }
                    
                    
                    
                } fail:^(NSError *error) {
                    [self.view showInfo:@"设置失败" autoHidden:YES interval:2];
                }];

                
            }
                break;
            default:
                break;
        }
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *imagePick = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self processImage:imagePick];
}

- (void)processImage:(UIImage *)image
{
    
    NSDictionary *mulDic = @{
                             @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                             @"ModifyType":@"1",
                             @"Headimg":[self imageToString:image]
                             };
    NSDictionary *params = @{
                             @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool base64convertToJsonData:mulDic]],
                             @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool base64convertToJsonData:mulDic]]]
                             };
    [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@User/UserInfoEdit",Khttp] success:^(NSDictionary *dict, BOOL success) {

        
        
        
        if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
        {
            
            APPDELEGATE.currentUser.userImagePath = [[dict objectForKey:@"JsonData"] objectForKey:@"Headimg"];
            self.userImageView.image = image;
            [UdStorage storageObject:APPDELEGATE.currentUser.userImagePath forKey:@"Headimg"];
            
            NSNotification * notice = [NSNotification notificationWithName:@"updateheadimgsuccess" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
    
            
            
            
            
            
            
            NSArray *vcsArray = [NSArray array];
            vcsArray= [self.navigationController viewControllers];
            NSInteger vcCount = vcsArray.count;
    
            if(vcsArray.count == 2)
            {
                
            }
            else
            {
                UIViewController *lastVC = vcsArray[vcCount-2];
                UIViewController *lasttwoVC = vcsArray[vcCount-3];
                int index=[[self.navigationController viewControllers]indexOfObject:self];
                
                if([lastVC isKindOfClass:[HowToUpGradeController class]])
                {
                                    NSNotification * notice = [NSNotification notificationWithName:@"Earnsuccess" object:nil userInfo:nil];
                                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
                }
                else if([lastVC isKindOfClass:[EarnScoreController class]])
                {
                    if([lasttwoVC isKindOfClass:[DSMembershipController class]])
                    {
                                            NSNotification * notice = [NSNotification notificationWithName:@"Earnsuccess" object:nil userInfo:nil];
                                            [[NSNotificationCenter defaultCenter]postNotification:notice];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
                        
                    }
                                    NSNotification * notice = [NSNotification notificationWithName:@"Earnsuccess" object:nil userInfo:nil];
                                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3]animated:YES];
                }

            }
    
    
    
    
 
            
        }
        else
        {
            [self.view showInfo:@"修改头像失败" autoHidden:YES interval:2];
        }

        
        
        
    } fail:^(NSError *error) {
        [self.view showInfo:@"设置失败" autoHidden:YES interval:2];
    }];
}

- (NSString *)imageToString:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *dataStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSLog(@"%@",dataStr);
    
    return dataStr;
}

-(void)noticeupdateUserName:(NSNotification *)sender{
  
    [self.tableView reloadData];
}



#pragma mark ---LKAlertViewDelegate---
- (void)alertView:(LKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (buttonIndex == 0) {
            
        }else{
            
            
        }
    
}


@end
