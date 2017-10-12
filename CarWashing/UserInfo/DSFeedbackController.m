//
//  DSFeedbackController.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/26.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSFeedbackController.h"
#import "DSTextView.h"
@interface DSFeedbackController ()<UITextViewDelegate>

@end

@implementation DSFeedbackController

- (void)drawNavigation {
    
    [self drawTitle:@"意见反馈" Color:[UIColor blackColor]];
    [self drawRightTextButton:@"提交" action:@selector(submitButtonClick:)];
    
}
- (void) submitButtonClick:(id)sender {

}

- (void) drawContent
{
    self.statusView.backgroundColor     = [UIColor grayColor];
    self.navigationView.backgroundColor = [UIColor grayColor];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DSTextView * textView =[[DSTextView alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 180*Main_Screen_Height/667)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholderColor = [UIColor lightGrayColor];
    textView.placeholder = @"您的意见是我们前进的最大动力，谢谢！";
    textView.font = [UIFont systemFontOfSize:17*Main_Screen_Height/667];
    textView.delegate = self;
    textView.layer.borderWidth =1;
    textView.layer.borderColor =[UIColor redColor].CGColor;
    [textView.layer setCornerRadius:10.0f];
    [self.view addSubview:textView];
}
- (void)textViewDidChange:(DSTextView *)textView

{
    
    if([textView.placeholder length] == 0)
    {
        return;
    }
    if([textView.placeholder length]  == 0)
    {
        [textView.placeHolderLabel setAlpha:1];
    }
    else
    {
        [textView.placeHolderLabel  setAlpha:0];
    }
    
    if ([textView.text isEqualToString:@""]) {
        [textView.placeHolderLabel setAlpha:1];
    }
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
