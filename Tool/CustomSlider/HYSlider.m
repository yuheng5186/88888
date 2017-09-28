//
//  HYSlider.m
//  HYSlider
//
//  Created by heyang on 16/6/3.
//  Copyright © 2016年 heyang. All rights reserved.
//

#import "HYSlider.h"
#import "UILabel+StringFrame.h"
@interface HYSlider ()
@property (nonatomic,strong) UIView *leftView;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIView *scrollShowTextView;
@property (nonatomic,strong) UIView *touchView;

@property (nonatomic) CGFloat hyMaxValue;

@end
@implementation HYSlider



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.backgroundColor=[UIColor greenColor];
        self.leftView.backgroundColor=[UIColor yellowColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        self.backgroundColor=[UIColor greenColor];
        self.leftView.backgroundColor=[UIColor yellowColor];
    }
    return self;
}

- (void)setCurrentSliderValue:(CGFloat)currentSliderValue
{
    _currentSliderValue = currentSliderValue;
    
    if(_hyMaxValue != 0)
    {
        _leftView.frame = CGRectMake(0, 0,currentSliderValue / (_hyMaxValue/self.frame.size.width), self.frame.size.height);
    }
    else
    {
        _leftView.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    }
    
    
    
    if(_textLabel){
        [_textLabel removeFromSuperview];
    }
    
    _textLabel = [[UILabel alloc]initWithFrame: CGRectMake(self.leftView.frame.size.width - 20, 0, 20, self.frame.size.height)];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:9.0];
//    [self.leftView addSubview:_textLabel];
    self.textLabel.text = [NSString stringWithFormat:@"%.f",currentSliderValue];
}

-(void)setShowTouchView:(BOOL)showTouchView{
    _showTouchView = showTouchView;
    if(_showTouchView){
        _touchView .frame = CGRectMake(0, 0, self.frame.size.height + 10, self.frame.size.height + 10);
        _touchView.center = _textLabel.center;
    }

}


-(void)setMaxValue:(CGFloat)maxValue{
    
    _hyMaxValue = maxValue;
    
}

-(void)setCurrentValueColor:(UIColor *)currentValueColor{
    
    self.leftView.backgroundColor = currentValueColor;
}

-(void)setShowTextColor:(UIColor *)showTextColor
{
    _textLabel.textColor = showTextColor;
    _scrollShowTextLabel.textColor = showTextColor;
}

-(void)setTouchViewColor:(UIColor *)touchViewColor{
    _touchView.backgroundColor = touchViewColor;
}


- (void)setShowScrollTextView:(BOOL)showScrollTextView
{
    
    _showScrollTextView = showScrollTextView;
    
    self.scrollShowTextView.hidden = !showScrollTextView;
    self.scrollShowTextView.frame = CGRectMake((self.touchView.frame.origin.x)>= 0 ? (self.touchView.frame.origin.x-5*Main_Screen_Width/375):(-5*Main_Screen_Width/375) ,- 27*Main_Screen_Height/667, 46*Main_Screen_Width/375,25*Main_Screen_Height/667);
    self.scrollShowTextLabel.text = [NSString stringWithFormat:@"%.f",self.currentSliderValue];
}

- (void)setup{
    
    
    self.layer.cornerRadius = self.frame.size.height/2;
    self.backgroundColor = [UIColor lightGrayColor];
    
    
    /** 显示文字label*/
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:9.0*Main_Screen_Height/667];
    _textLabel.textAlignment = NSTextAlignmentRight;
//    [self.leftView addSubview:_textLabel];
   
    
    /** 数值视图*/
    _leftView = [[UIView alloc]init];
    _leftView.layer.cornerRadius = self.frame.size.height/2;
    [self addSubview:_leftView];
    
    _scrollShowTextView  = [[UIView alloc]init];
    _scrollShowTextView.hidden = YES;
    _scrollShowTextView.backgroundColor = [UIColor clearColor];
//    _scrollShowTextLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_scrollShowTextView];
    
    
    /** 浮标image*/
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-10*Main_Screen_Width/667, -3*Main_Screen_Height/667,46*Main_Screen_Width/375,25*Main_Screen_Height/667)];
//    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.image = [UIImage imageNamed:@"huiyuanfenshukuang"];
//    _imageView.backgroundColor=[UIColor blueColor];
    [_scrollShowTextView addSubview:_imageView];
    
    /** 浮标数值显示label*/

    _scrollShowTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*Main_Screen_Width/375, 2*Main_Screen_Height/667, 26*Main_Screen_Width/375, 17*Main_Screen_Height/667)];
    _scrollShowTextLabel.textAlignment = NSTextAlignmentCenter;
    _scrollShowTextLabel.textColor = [UIColor clearColor];
//   _scrollShowTextLabel.adjustsFontSizeToFitWidth = YES;
    _scrollShowTextLabel.font=[UIFont systemFontOfSize:12*Main_Screen_Height/667];
    
//    boundingRectWithSize
    _scrollShowTextLabel.text=[NSString stringWithFormat:@"%f",self.currentSliderValue];
    
    
    [_imageView addSubview:_scrollShowTextLabel];

    
    
    /** 圆形触摸块*/
    _touchView  = [[UIView alloc]init];
    _touchView.layer.cornerRadius = (self.frame.size.height + 10) /2;
    _touchView.layer.masksToBounds = YES;
    _touchView.layer.borderColor = [UIColor whiteColor].CGColor;
    _touchView.layer.borderWidth = 2.0;
    _touchView.backgroundColor = [UIColor yellowColor];
//    [self addSubview:_touchView];
    
    /** 默认最大值*/
    _hyMaxValue = 255.0;

    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGRAction:)];
    [self addGestureRecognizer:longGR];
    
}



- (void)longGRAction:(UILongPressGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        (!self.showScrollTextView) ? (self.scrollShowTextView.hidden = YES) : (self.scrollShowTextView.hidden = NO);
    }else{
        self.scrollShowTextView.hidden = NO;
        CGPoint translation            = [recognizer locationInView:self];
        
        
        if((translation.x >=0 && ((_hyMaxValue/self.frame.size.width) * translation.x) <= _hyMaxValue)){
          
            self.leftView.frame           = CGRectMake(0, 0, translation.x, self.frame.size.height);
            self.scrollShowTextView.frame = CGRectMake((translation.x-18)>= 0 ? (translation.x-18):(0) ,- 48*Main_Screen_Height/667, 36*Main_Screen_Width/375,20*Main_Screen_Height/667);
            self.textLabel .frame             = CGRectMake((self.leftView.frame.size.width - 20) >= 0 ? (self.leftView.frame.size.width - 20):(0) , 0, 20, self.frame.size.height);
            self.textLabel.text           = [NSString stringWithFormat:@"%.f",(_hyMaxValue/self.frame.size.width) * translation.x];
            self.scrollShowTextLabel.text = [NSString stringWithFormat:@"%.f",(_hyMaxValue/self.frame.size.width) * translation.x];

            if(_showTouchView){
            _touchView .frame             = CGRectMake(0, 0, self.frame.size.height + 10, self.frame.size.height + 10);
            _touchView.center             = _textLabel.center;
            }
         
            
            /** delegate*/
            if([self.delegate respondsToSelector:@selector(HYSlider:didScrollValue:)]){
            [self.delegate HYSlider:self didScrollValue:(_hyMaxValue/self.frame.size.width) * translation.x];
            }
            
            
        }

    }
}



@end
