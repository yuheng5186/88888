//
//  DSSegmentView.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/7/28.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "DSSegmentView.h"
#import <Masonry.h>

@interface DSSegmentView ()

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;

@property (nonatomic, strong) UIButton *firstButton;

/**
 上一个按钮
 */
@property (nonatomic, weak) UIButton *preButton;

@property (nonatomic, weak) UIView *singleLine;

@end
@implementation DSSegmentView

- (NSMutableArray<UIButton *> *)buttonArray{
    if (nil == _buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor  = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    [self setupButton];
    [self setupSingleLine];
    self.backgroundColor=[UIColor whiteColor];
    
}


#pragma mark - 细线
- (void)setupSingleLine {
    
    UIView *singleLine = [[UIView alloc] init];
    
    _singleLine = singleLine;
    
    singleLine.backgroundColor = [UIColor colorFromHex:@"#febb02"];
    
    [self addSubview:singleLine];
    
    [singleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(_firstButton);
        make.width.mas_equalTo(Main_Screen_Width*70/375);
        make.height.mas_equalTo(Main_Screen_Height*3/667);
    }];
}


#pragma mark - 添加button
- (void)setupButton {
    
    
    
    NSArray *titleArray = @[@"车友圈",@"本地新鲜事"];
    
    
    int index = 0;
    
    for (NSString *title in titleArray) {
        
        UIButton *button = [self buttonWithTitle:title];
        
        button.tag = index++;
        
        //点击事件
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
    }
    
    //赋值第一个button
    _firstButton = self.buttonArray[0];
    
    [self.buttonArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
    }];
    
    [self.buttonArray[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonArray[0]);
        make.leading.equalTo(self.buttonArray[0].mas_trailing);
        make.size.equalTo(self.buttonArray[0]);
        make.trailing.equalTo(self);
    }];
}


#pragma mark - 点击按钮
- (void)clickButton:(UIButton *)button{
    
    _preButton.selected = NO;
    
    button.selected = YES;
    
    _preButton = button;
    
    //修改细线的约束
    [_singleLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_firstButton).offset(button.tag * _firstButton.width);
    }];
    
    [UIView animateWithDuration:.25 animations:^{
        
        [self layoutIfNeeded];
    }];
    
    
    //传递数据
    if (_categoryBlock) {
        _categoryBlock(button.tag);
    }
    
}


#pragma mark - 实例化button
- (UIButton *)buttonWithTitle:(NSString *)title{
    
    UIButton *button = [[UIButton alloc] init];
    
    //设置button的title
    [button setTitle:title forState:UIControlStateNormal];
    
    //设置文字的颜色
    [button setTitleColor:[UIColor colorFromHex:@"#999999"] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    
    return button;
}


#pragma mark - 根据传递的数据修改细线的约束
- (void)setOffsetX:(CGFloat)offsetX {
    
    _offsetX = offsetX;
    
    //更新细线的约束
    [_singleLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_firstButton).offset(offsetX);
    }];
    
    //要实现按钮选择的切换,就需要获取到数组中的button,那么就需要下标
    NSInteger index = offsetX / _firstButton.width + 0.5;
    
    _preButton.selected = NO;
    
    self.buttonArray[index].selected = YES;
    
    _preButton = self.buttonArray[index];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
