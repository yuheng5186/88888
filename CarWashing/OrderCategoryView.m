//
//  OrderCategoryView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/2.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "OrderCategoryView.h"
#import <Masonry.h>


@interface OrderCategoryView ()

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;

@property (nonatomic, weak) UIButton *firstButton;

/**
 上一个按钮
 */
@property (nonatomic, weak) UIButton *preButton;

@property (nonatomic, weak) UIView *singleLine;


@end

@implementation OrderCategoryView

- (NSMutableArray<UIButton *> *)buttonArray{
    
    if (nil == _buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

#pragma mark - 初始化界面
- (void)setupUI{
    
#pragma mark - 1. 添加button
    [self setupButton];
    
#pragma mark - 2. 添加细线
    [self setupSingleLine];
    
    //默认选中第一个按钮
    [self clickButton:_firstButton];
    //    if (_preButton == nil) {
    //        _firstButton.selected = YES;
    //        _preButton = _firstButton;
    //    }
    
}

#pragma mark - 细线
- (void)setupSingleLine {
    
    UIView *singleLine = [[UIView alloc] init];
    
    _singleLine = singleLine;
    
    singleLine.backgroundColor = [UIColor colorFromHex:@"#febb02"];
    
    [self addSubview:singleLine];
    
    
    //约束
    [singleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.centerX.equalTo(_firstButton);
        
        make.width.mas_equalTo(Main_Screen_Width*40/375);
        
        make.height.mas_equalTo(2);
    }];
}


#pragma mark - 添加button
- (void)setupButton{
    
    //1.实例化title的数组
    NSArray *titleArray = @[@"全部",@"待付款",@"待评价"];
    
    //2.循环添加button
    
    //tag
    int index = 0;
    
    
    for (NSString *title in titleArray) {
        
        UIButton *button = [self buttonWithTitle:title];
        
        
        button.tag = index++;
        
        
        
        //添加监听事件
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
    }
    
    //赋值第一个button
    _firstButton = self.buttonArray[0];
    
    //3.自动布局
    [self.buttonArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.bottom.equalTo(self);
    }];
    
    [self.buttonArray[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.buttonArray[0]);
        make.leading.equalTo(self.buttonArray[0].mas_trailing);
        make.size.equalTo(self.buttonArray[0]);
    }];
    
    [self.buttonArray[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.buttonArray[1]);
        
        make.leading.equalTo(self.buttonArray[1].mas_trailing);
        
        make.size.equalTo(self.buttonArray[1]);
        
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
    //[button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor colorFromHex:@"#999999"] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    
    return button;
}


#pragma mark - 根据传递的数据修改细线的约束
- (void)setOffsetX:(CGFloat)offsetX{
    
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


@end
