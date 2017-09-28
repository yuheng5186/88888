//
//  UIUtil.m
//  Links
//
//  Created by zhengpeng on 14-4-8.
//  Copyright (c) 2015年 zhengpeng. All rights reserved.
//

#import "UIUtil.h"


@implementation UIUtil
//image button
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action
{
    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName target:target action:action];
	[view addSubview:btn];
	return btn;
}

+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = frame;
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action
{
    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName capInsets:capInsets target:target action:action];
	[view addSubview:btn];
	return btn;
}

+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = frame;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
	UIImage *img = [UIImage imageNamed:iconName];
    if ([img respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        img = [img resizableImageWithCapInsets:capInsets];
    }else{
        img = [img stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
	return btn;
}

+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action tag:(NSInteger)tag
{
	UIButton *btn = [self getButtonWithFrame:frame iconName:iconName target:target action:action tag:tag];
	[view addSubview:btn];
	return btn;
}

+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName target:target action:action];
	btn.tag = tag;
	return btn;
}

+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action tag:(NSInteger)tag
{
	UIButton *btn = [self getButtonWithFrame:frame iconName:iconName capInsets:capInsets target:target action:action tag:tag];
	[view addSubview:btn];
	return btn;
}

+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName capInsets:capInsets target:target action:action];
	btn.tag = tag;
	return btn;
}

//text button
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *btn = [self getButtonWithFrame:frame text:text font:font color:color target:target action:action];
	[view addSubview:btn];
	return btn;
}

+ (UIButton *)getButtonWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

//image text button
+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets text:(NSString *)text font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName capInsets:capInsets text:text font:font color:color target:target action:action];
	[view addSubview:btn];
	return btn;
}

+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets text:(NSString *)text font:(UIFont *)font color:(UIColor *)color  target:(id)target action:(SEL)action
{
    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName capInsets:capInsets target:target action:action];
	[btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    
	return btn;
}

//image clickbackground button
+ (UIButton *)drawClickBackgroundButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = frame;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    imageView.center = CGPointMake(btn.width/2, btn.height/2);
    imageView.hidden = YES;
    imageView.tag = 101;
    [btn addSubview:imageView];
    
    [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
	[view addSubview:btn];
	return btn;
}

+ (UIButton *)getClickBackgroundButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = frame;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    imageView.center = btn.center;
    imageView.hidden = YES;
    imageView.tag = 101;
    [btn addSubview:imageView];
    
    [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
	return btn;
}

+ (void)touchDown:(id)sender
{
    UIButton *button = sender;
    UIImageView *imageView = (UIImageView *)[button viewWithTag:101];
    imageView.hidden = NO;
}

+ (void)touchUpInside:(id)sender
{
    UIButton *button = sender;
    UIImageView *imageView = (UIImageView *)[button viewWithTag:101];
    imageView.hidden = YES;
}

+ (void)touchUpOutside:(id)sender
{
    UIButton *button = sender;
    UIImageView *imageView = (UIImageView *)[button viewWithTag:101];
    imageView.hidden = YES;
}

//image image button
//+ (UIButton *)drawButtonInView:(UIView *)view frame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets iconName2:(NSString *)iconName2 target:(id)target action:(SEL)action
//{
//    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName capInsets:capInsets iconName2:iconName2 target:target action:action];
//	[view addSubview:btn];
//	return btn;
//}
//
//+ (UIButton *)getButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName capInsets:(UIEdgeInsets)capInsets iconName2:(NSString *)iconName2 target:(id)target action:(SEL)action
//{
//    UIButton *btn = [self getButtonWithFrame:frame iconName:iconName capInsets:capInsets target:target action:action];
//    [btn setImage:[UIImage imageNamed:iconName2] forState:UIControlStateNormal];
//	return btn;
//}

//image

+ (UIImageView *) drawCustomImgViewInView: (UIView *) view imageName: (NSString *) imageName
{
    UIImageView *iv = [[UIImageView alloc] initWithImage: [UIImage imageNamed: imageName]];
    [view addSubview:iv];
    return iv;
}

+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName
{
	UIImageView *iv = [self getCustomImgViewWithFrame:frame imageName:imageName];
	[view addSubview:iv];
    return iv;
}


+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	iv.frame = frame;
    return iv;
}

+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag
{
    UIImageView *iv = [self getCustomImgViewWithFrame:frame imageName:imageName tag:tag];
    [view addSubview:iv];
    return iv;
}

+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName tag:(NSInteger)tag
{
    UIImageView *iv = [self getCustomImgViewWithFrame:frame imageName:imageName];
    iv.tag = tag;
    return iv;
}

+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets
{
    UIImageView *iv = [self getCustomImgViewWithFrame:frame imageName:imageName capInsets:capInsets];
    [view addSubview:iv];
    return iv;
}

+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets
{
    UIImageView *iv = [self getCustomImgViewWithFrame:frame imageName:imageName];
    
    UIImage *img = [UIImage imageNamed:imageName];
    if ([img respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        img = [img resizableImageWithCapInsets:capInsets];
    }else{
        img = [img stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    
    iv.image = img;
    return iv;
}

+ (UIImageView *)drawCustomImgViewInView:(UIView *)view frame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets tag:(NSInteger)tag
{
    UIImageView *iv = [self getCustomImgViewWithFrame:frame imageName:imageName capInsets:capInsets tag:tag];
    [view addSubview:iv];
    return iv;
}

+ (UIImageView *)getCustomImgViewWithFrame:(CGRect)frame imageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets tag:(NSInteger)tag
{
    UIImageView *iv = [self getCustomImgViewWithFrame:frame imageName:imageName capInsets:capInsets];
    iv.tag = tag;
    return iv;
}

//label
+ (UILabel *)drawLabelInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter
{
	UILabel *lb = [self getLabelWithFrame:frame font:font text:text isCenter:isCenter];
	[view addSubview:lb];
	return lb;
}

+ (UILabel *)getLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter
{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
	lb.backgroundColor = [UIColor clearColor];
	lb.font = font;
	lb.text = text;
    if (isCenter) {
        lb.textAlignment = NSTextAlignmentCenter;
    }
	return lb;
}

+ (UILabel *)drawLabelInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter tag:(NSInteger)tag
{
	UILabel *lb = [self getLabelWithFrame:frame font:font text:text isCenter:isCenter tag:tag];
	[view addSubview:lb];
	return lb;
}

+ (UILabel *)getLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter tag:(NSInteger)tag
{
    UILabel *lb = [self getLabelWithFrame:frame font:font text:text isCenter:isCenter];
	lb.tag = tag;
	return lb;
}

+ (UILabel *)drawLabelInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color
{
	UILabel *lb = [self getLabelWithFrame:frame font:font text:text isCenter:isCenter color:color];
	[view addSubview:lb];
	return lb;
}

+ (UILabel *)getLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color
{
    UILabel *lb = [self getLabelWithFrame:frame font:font text:text isCenter:isCenter];
	lb.textColor = color;
	return lb;
}

+ (UILabel *)drawLabelMutiLineInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter
{
	UILabel *lb = [self getLabelMutiLineWithFrame:frame font:font text:text isCenter:isCenter];
    [view addSubview:lb];
	return lb;
}

+ (UILabel *)getLabelMutiLineWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter
{
    float height;
//    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        CGRect rect = [text boundingRectWithSize:CGSizeMake(frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
//        height = rect.size.height+0.05;
//    } else {
//        CGSize lblSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//        height = lblSize.height+0.05;
//    }
    CGRect rect = [text boundingRectWithSize:CGSizeMake(frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    height = rect.size.height+0.05;


	UILabel *lb = [self getLabelWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height) font:font text:text isCenter:isCenter];
	lb.numberOfLines = 0;
	return lb;
}

+ (UILabel *)drawLabelMutiLineInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text  isCenter:(BOOL)isCenter tag:(NSInteger)tag
{
    UILabel *lb = [self getLabelMutiLineWithFrame:frame font:font text:text isCenter:isCenter tag:tag];
	[view addSubview:lb];
	return lb;
}

+ (UILabel *)getLabelMutiLineWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text  isCenter:(BOOL)isCenter tag:(NSInteger)tag
{
    UILabel *lb = [self getLabelMutiLineWithFrame:frame font:font text:text isCenter:isCenter];
	lb.tag = tag;
	return lb;
}

+ (UILabel *)drawLabelMutiLineInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color
{
    UILabel *lb = [self getLabelMutiLineWithFrame:frame font:font text:text isCenter:isCenter color:color];
	[view addSubview:lb];
	return lb;
}

+ (UILabel *)getLabelMutiLineWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text isCenter:(BOOL)isCenter color:(UIColor *)color
{
    UILabel *lb = [self getLabelMutiLineWithFrame:frame font:font text:text isCenter:isCenter];
	lb.textColor = color;
	return lb;
}

//textview
+ (UITextView *)drawTextViewInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font text:(NSString *)text
{
    UITextView *tv = [self getTextViewWithFrame:frame font:font text:text];
    [view addSubview:tv];
    return tv;
}

+ (UITextView *)getTextViewWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text
{
    UITextView *tv = [[UITextView alloc] initWithFrame:frame];
    tv.text = text;
    tv.backgroundColor = [UIColor clearColor];
    tv.editable = NO;
    tv.font = font;
    CGRect frame2 = tv.frame;
    frame2.size.height = tv.contentSize.height;
    tv.frame = frame2;
    
    return tv;
}

//textfield
+ (UITextField *)drawTextFieldInView:(UIView *)view frame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder  text:(NSString *)text
{
    UITextField *field = [self getTextFieldWithFrame:frame font:font placeholder:placeholder text:text];
    [view addSubview:field];
    return field;
}

+ (UITextField *)getTextFieldWithFrame:(CGRect)frame font:(UIFont *)font  placeholder:(NSString *)placeholder text:(NSString *)text
{
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.font = font;
    field.placeholder = placeholder;
    field.text = text;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    return field;
}

//line
+ (UIView *)drawLineInView:(UIView *)view frame:(CGRect)frame color:(UIColor *)color
{
    UIView *line = [self getLineWithFrame:frame color:color];
    [view addSubview:line];
    return line;
}

+ (UIView *)drawLineInView:(UIView *)view frame:(CGRect)frame {
    UIView *line = [self getLineWithFrame:frame color:[UIColor colorWithHex:0xf6f6f6 alpha:1.0]];
    [view addSubview:line];
    return line;
}

+ (UIView *)drawDefaultLineInView:(UIView *)view frame:(CGRect)frame {
    UIView *line = [self getLineWithFrame:frame color:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]];
    [view addSubview:line];
    return line;
}

+ (UIView *)getLineWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    return line;
}

//other
+ (CGFloat)lineWidth
{
    static CGFloat width = 0;
    if ( 0 == width ) {
        
        if (2 ==  [[UIScreen mainScreen] scale]) {
            width = 0.5;
        } else if ( 1 ==  [[UIScreen mainScreen] scale] ) {
            width = 1;
        } else {
            width = 0.5;
        }
    }

    return width;
}

+ (CGFloat)textWidth:(NSString *)text font:(UIFont *)font
{
    float textWidth;
//    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
//        textWidth = textRect.size.width;
//    } else {
//        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(10000, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//        textWidth = textSize.width;
//    }
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    textWidth = textRect.size.width;
    return textWidth;
}

+ (CGFloat)textHeight:(NSString *)text font:(UIFont *)font
{
    float textHeight;
//    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
//        textHeight = textRect.size.height;
//    } else {
//        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(10000, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//        textHeight = textSize.height;
//    }
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    textHeight = textRect.size.height;
    return textHeight;
}

+ (CGRect)textRect:(NSString *)text font:(UIFont *)font {
    CGRect textRect;
//    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
//    } else {
//        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(10000, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//        textRect = CGRectMake(0, 0, textSize.width, textSize.height);
//    }
    textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return textRect;
}

+ (CGRect)textRect:(NSString *)text font:(UIFont *)font size:(CGSize)size {
    CGRect textRect;
//    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
//    } else {
//        CGSize textSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//        textRect = CGRectMake(0, 0, textSize.width, textSize.height);
//    }
    textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return textRect;
}


+ (CGFloat)labelWidth:(UILabel *)lbl {
    NSString *text = lbl.text;
    UIFont *font = lbl.font;
    float textWidth;
//    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
//        textWidth = textRect.size.width;
//    } else {
//        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(10000, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//        textWidth = textSize.width;
//    }
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    textWidth = textRect.size.width;
    return textWidth;
}

+ (CGFloat)lableHeight:(UILabel *)lbl {
    NSString *text = lbl.text;
    UIFont *font = lbl.font;
    float textHeight;
//    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
//        textHeight = textRect.size.height;
//    } else {
//        CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(10000, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//        textHeight = textSize.height;
//    }
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    textHeight = textRect.size.height;
    return textHeight;
}


+ (UIButton *)drawDefaultButton:(UIView *)view title:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((Main_Screen_Width-300)/2, 0, Main_Screen_Width-20, 40);
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
//    UIImage *normalImage = [UIImage createImageWithColor:[UIColor brkBtnNormal]];
//    UIImage *disableImage = [UIImage createImageWithColor:[UIColor brkBtnDisable]];
//    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHex:@"#0161a1"]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xFFB500 alpha:1.0]] forState:UIControlStateNormal];

//    [btn setBackgroundImage:disableImage forState:UIControlStateDisabled];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return btn;
}

@end


