//
//  OrderCommentController.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/7.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "OrderCommentController.h"
#import <Masonry.h>
#import "TggStarEvaluationView.h"

#import "HTTPDefine.h"
#import "LCMD5Tool.h"
#import "AFNetworkingTool.h"
#import "UdStorage.h"

#import "MBProgressHUD.h"
#import "IQKeyboardManager.h"
@interface OrderCommentController ()<UITextViewDelegate>
{
    UITextView *commentTextView;
    NSInteger score;
    MBProgressHUD *HUD1;
}

//@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;
//@property (nonatomic, weak) UIButton *firstButton;

@property (weak ,nonatomic) TggStarEvaluationView *tggStarEvaView;

@end

@implementation OrderCommentController

//- (NSMutableArray<UIButton *> *)buttonArray{
//    
//    if (nil == _buttonArray) {
//        
//        _buttonArray = [NSMutableArray array];
//    }
//    return _buttonArray;
//}

- (void)drawNavigation {
    
    [self drawTitle:@"发表评价"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //是否显示键盘上的工具条
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    UIView *containStarView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 10*Main_Screen_Height/667, Main_Screen_Width, 110*Main_Screen_Height/667)];
    containStarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containStarView];
    
    
    UILabel *gradeLabel = [[UILabel alloc] init];
    gradeLabel.text = @"打分星评";
    gradeLabel.textColor = [UIColor colorFromHex:@"4a4a4a"];
    gradeLabel.font = [UIFont systemFontOfSize:16*Main_Screen_Height/667];
    [containStarView addSubview:gradeLabel];
    
    
//    for (int i = 0; i < 5; i++) {
//        
//        UIButton *starButton = [[UIButton alloc] init];
//        [starButton setImage:[UIImage imageNamed:@"huixingxing"] forState:UIControlStateNormal];
//        [starButton setImage:[UIImage imageNamed:@"huangxingxing"] forState:UIControlStateSelected];
//        [starButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//        starButton.tag = i;
//
//        [containStarView addSubview:starButton];
//        [self.buttonArray addObject:starButton];
//    }
    
    
    __weak __typeof(self)weakSelf = self;
    self.tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        //几颗星的回调count
        score = count;
        
    }];
    
    [containStarView addSubview:_tggStarEvaView];
    
    
    
    
    //约束
    
    
    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containStarView).mas_offset(22*Main_Screen_Height/667);
        make.centerX.equalTo(containStarView);
    }];
    
    [_tggStarEvaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containStarView);
        make.top.equalTo(gradeLabel.mas_bottom);
        make.height.mas_equalTo(60*Main_Screen_Height/667);
        make.width.mas_equalTo(300*Main_Screen_Height/667);
    }];
    
//    _firstButton = self.buttonArray[0];
//    
//    [self.buttonArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(containStarView).mas_offset(89*Main_Screen_Height/667);
//        make.top.equalTo(gradeLabel.mas_bottom).mas_offset(25*Main_Screen_Height/667);
//        make.width.height.mas_equalTo(26*Main_Screen_Height/667);
//    }];
//    
//    [self.buttonArray[1] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buttonArray[0]);
//        make.leading.equalTo(self.buttonArray[0].mas_trailing).mas_offset(16.75*Main_Screen_Height/667);
//        make.size.equalTo(self.buttonArray[0]);
//    }];
//    
//    [self.buttonArray[2] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buttonArray[1]);
//        make.leading.equalTo(self.buttonArray[1].mas_trailing).mas_offset(16.75*Main_Screen_Height/667);
//        make.size.equalTo(self.buttonArray[1]);
//    }];
//    
//    [self.buttonArray[3] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buttonArray[2]);
//        make.leading.equalTo(self.buttonArray[2].mas_trailing).mas_offset(16.75*Main_Screen_Height/667);
//        make.size.equalTo(self.buttonArray[2]);
//    }];
//    
//    [self.buttonArray[4] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buttonArray[3]);
//        make.leading.equalTo(self.buttonArray[3].mas_trailing).mas_offset(16.75*Main_Screen_Height/667);
//        make.size.equalTo(self.buttonArray[3]);
//    }];
    
    
    commentTextView = [[UITextView alloc] init];

    commentTextView.text = @"亲,您的评价可以帮助到别人哦";
    commentTextView.textColor = [UIColor colorFromHex:@"#999999"];
    commentTextView.delegate = self;
    [self.view addSubview:commentTextView];
    
    [commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containStarView.mas_bottom).mas_offset(10*Main_Screen_Height/667);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200*Main_Screen_Height/667);
    }];
    
    UIButton *signinButton = [UIUtil drawDefaultButton:self.view title:@"发表评价" target:self action:@selector(clickSigninButton:)];
    
    [signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(-25*Main_Screen_Height/667);
        make.width.mas_equalTo(350*Main_Screen_Height/667);
        make.height.mas_equalTo(48*Main_Screen_Height/667);
        make.centerX.equalTo(self.view);
    }];
}

- (void)clickSigninButton:(UIButton *)button {
    
    
    
    
    if (commentTextView.text.length > 0) {
        HUD1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD1.removeFromSuperViewOnHide =YES;
        HUD1.mode = MBProgressHUDModeIndeterminate;
        HUD1.minSize = CGSizeMake(132.f, 108.0f);
        NSDictionary *mulDic = @{
                                 @"Account_Id":[UdStorage getObjectforKey:@"Account_Id"],
                                 @"MerCode":self.SerMerCode,
                                 @"SerCode":self.SerCode,
                                 @"OrderId":self.orderid,
                                 @"CommentContent":commentTextView.text,
                                 @"Score":[NSString stringWithFormat:@"%ld",score]
                                 };
        
        NSDictionary *params = @{
                                 @"JsonData" : [NSString stringWithFormat:@"%@",[AFNetworkingTool convertToJsonData:mulDic]],
                                 @"Sign" : [NSString stringWithFormat:@"%@",[LCMD5Tool md5:[AFNetworkingTool convertToJsonData:mulDic]]]
                                 };
        
        [AFNetworkingTool post:params andurl:[NSString stringWithFormat:@"%@OrderRecords/AddOrderComment",Khttp] success:^(NSDictionary *dict, BOOL success) {
            NSLog(@"%@",dict);
            if([[dict objectForKey:@"ResultCode"] isEqualToString:[NSString stringWithFormat:@"%@",@"F000000"]])
            {
                            NSNotification * notice = [NSNotification notificationWithName:@"fabiaoboupdate" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter]postNotification:notice];
                
                
                __weak typeof (self)weakSelf = self;
                
                HUD1.completionBlock = ^(){
                    [weakSelf.view showInfo:@"评价成功" autoHidden:YES interval:2];
                    //            self.dic = [dict objectForKey:@"JsonData"];
                    //        [self.MerchantDetailData addObjectsFromArray:arr];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
                
                [HUD1 hide:YES afterDelay:1];
                
                
            }
            else
            {
                [HUD1 hide:YES];
                [self.view showInfo:@"评论添加失败" autoHidden:YES interval:2];
                //            [self.navigationController popViewControllerAnimated:YES];
            }
            
            
            
            
        } fail:^(NSError *error) {
            [HUD1 hide:YES];
            [self.view showInfo:@"评论添加失败" autoHidden:YES interval:2];
        }];
        
    }else {
//         [HUD1 hide:YES];
        [self.view showInfo:@"请输入内容再提交" autoHidden:YES interval:1];
    }
    
   

    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"亲,您的评价可以帮助到别人哦"]) {
        textView.text = @"";
        textView.textColor = [UIColor colorFromHex:@"#999999"];
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length < 1) {
//        textView.text = @"亲,您的评价可以帮助到别人哦";
        textView.font = [UIFont systemFontOfSize:13*Main_Screen_Height/667];
        textView.textColor = [UIColor colorFromHex:@"#999999"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
