//
//  QWMclistTableViewCell.m
//  QWCarWashing
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "QWMclistTableViewCell.h"
#import "AppDelegate.h"
#import "HTTPDefine.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDAutoLayout.h>

#define mainW [UIScreen mainScreen].bounds.size.width

@implementation QWMclistTableViewCell
{
    AppDelegate *myDelegate;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setlayoutCell
{
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    UIImageView *imageV =[[UIImageView alloc]initWithFrame:CGRectMake1(12,12,80,80)];
    imageV.opaque = YES;
//    imageV.image = [UIImage imageNamed:@"aiche1"];
    [self.contentView addSubview:imageV];
    self.McImageView = imageV;
    
//    UIImageView *imageV1 =[[UIImageView alloc]initWithFrame:CGRectMake1(0,0,30,30)];
//    imageV1.opaque = YES;
//    imageV1.image = [UIImage imageNamed:@"renzheng"];
//    [self.McImageView addSubview:imageV1];
//    self.McImagecheckView = imageV1;
    
    UIImageView *assStoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(112.0/375*Main_Screen_Width, 12.0/677*Main_Screen_Height, 38.0/375*Main_Screen_Width, 17.0/677*Main_Screen_Height)];
    assStoreImage.image = [UIImage imageNamed:@"vrenzheng"];
    assStoreImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:assStoreImage];
    
    CGFloat ass = 0.0;
    if (Main_Screen_Width < 375) {
        ass = 180.0;
    }else{
        ass = 160.0;
    }
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake1(ass/375*Main_Screen_Width,10.0/677*Main_Screen_Height, 150.0/375*Main_Screen_Width, 17.0/677*Main_Screen_Height)];
    namelabel.backgroundColor = [UIColor redColor];
    [namelabel setFont:[UIFont fontWithName:@"Helvetica" size:16 * myDelegate.autoSizeScaleX]];
    namelabel.centerY = assStoreImage.centerY;
    namelabel.sd_layout.leftSpaceToView(assStoreImage, 10);
    namelabel.textColor = [UIColor colorFromHex:@"#4a4a4a"];
    namelabel.text = @"金雷快修店";
    [self.contentView addSubview:namelabel];
    self.Mcname = namelabel;
    
    
   
    CGSize size = [namelabel boundingRectWithSize:CGSizeMake(Main_Screen_Width,2000)];
//    namelabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [namelabel sizeToFit];
    
    
    NSLog(@"%f",mainW);
    UILabel *catlabel = [[UILabel alloc]initWithFrame:CGRectMake1(Main_Screen_Width-88* myDelegate.autoSizeScaleX,14, 88.0/375*mainW, 10)];
    catlabel.backgroundColor = [UIColor greenColor];
    [catlabel setFont:[UIFont fontWithName:@"Helvetica" size:12 * myDelegate.autoSizeScaleX]];
    catlabel.textColor = [UIColor colorFromHex:@"#868686"];
    catlabel.text = @"美容店";
    catlabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:catlabel];
    self.Mccat = catlabel;
    
    CGSize sizecatlabel = [catlabel boundingRectWithSize:CGSizeMake(Main_Screen_Width,2000)];
    catlabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    UILabel *addlabel = [[UILabel alloc]initWithFrame:CGRectMake(112 * myDelegate.autoSizeScaleX, 19* myDelegate.autoSizeScaleY+size.height, 200* myDelegate.autoSizeScaleX, 10* myDelegate.autoSizeScaleY)];
    [addlabel setFont:[UIFont fontWithName:@"Helvetica" size:13 * myDelegate.autoSizeScaleX]];
    addlabel.textColor = [UIColor colorFromHex:@"#999999"];
    addlabel.text = @"上海市浦东新区金桥路金桥路";
   
    
    [self.contentView addSubview:addlabel];
    
    self.Mcaddress = addlabel;
    
    
    //在这里添加洗车次数
    
   
    
    CGSize sizeaddlabel = [addlabel boundingRectWithSize:CGSizeMake(Main_Screen_Width,2000)];
    addlabel.lineBreakMode = NSLineBreakByWordWrapping;
    
//    UIImageView *imageV3 =[[UIImageView alloc]initWithFrame:CGRectMake(290 * myDelegate.autoSizeScaleX, 21* myDelegate.autoSizeScaleY+sizecatlabel.height,10 * myDelegate.autoSizeScaleX,10 * myDelegate.autoSizeScaleY)];
//    imageV3.opaque = YES;
//    imageV3.image = [UIImage imageNamed:@"juli"];
//    [self.contentView addSubview:imageV3];
//    self.McImagelubiaoView = imageV3;
    
    self.Mcrange.left=10*Main_Screen_Width/375;
    
    UILabel *julilabel = [[UILabel alloc]initWithFrame:CGRectMake(250*myDelegate.autoSizeScaleX,21* myDelegate.autoSizeScaleY+sizecatlabel.height, 88*myDelegate.autoSizeScaleX, 10*myDelegate.autoSizeScaleY)];
    [julilabel setFont:[UIFont fontWithName:@"Helvetica" size:11 * myDelegate.autoSizeScaleX]];
    julilabel.textColor = [UIColor colorFromHex:@"#868686"];
    julilabel.text = @"1.25km";
    julilabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:julilabel];
    self.Mcrange = julilabel;
    
    
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake1(112, 75, 175, 2)];
    lineImg.image = [self drawLineByImageView:lineImg];
    [self.contentView addSubview:lineImg];
    
    self.washTimeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(112 * myDelegate.autoSizeScaleX, self.Mcaddress.frame.origin.y+sizeaddlabel.height+5*myDelegate.autoSizeScaleY, 80* myDelegate.autoSizeScaleX, 10* myDelegate.autoSizeScaleY)];
    self.washTimeNumLabel.text = @"洗车1000次";
    self.washTimeNumLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    self.washTimeNumLabel.textColor = [UIColor colorFromHex:@"#999999"];
    [self.contentView addSubview: self.washTimeNumLabel];
    
    //原来的商家✨
//    UIImageView *imageV2 =[[UIImageView alloc]initWithFrame:CGRectMake(112 * myDelegate.autoSizeScaleX, self.Mcaddress.frame.origin.y+sizeaddlabel.height+5*myDelegate.autoSizeScaleY, 62* myDelegate.autoSizeScaleX, 10* myDelegate.autoSizeScaleY)];
//    imageV2.opaque = YES;
//    imageV2.image = [UIImage imageNamed:@"shangjia3xing"];
//    [self.contentView addSubview:imageV2];
//    self.Mcxingji = imageV2;
    
    UILabel *scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(200 * myDelegate.autoSizeScaleX, self.Mcaddress.frame.origin.y+sizeaddlabel.height, 50* myDelegate.autoSizeScaleX, 21* myDelegate.autoSizeScaleY)];
    [scorelabel setFont:[UIFont fontWithName:@"Helvetica" size:13 * myDelegate.autoSizeScaleX]];
    scorelabel.textColor = [UIColor colorFromHex:@"#999999"];
    scorelabel.text = @"4.0分";
    [self.contentView addSubview:scorelabel];
    self.Mcscore = scorelabel;
    
    UILabel *taglabel1 = [[UILabel alloc]initWithFrame:CGRectMake1(112, 83, 60, 15)];
    [taglabel1 setFont:[UIFont fontWithName:@"Helvetica" size:11 * myDelegate.autoSizeScaleX]];
    taglabel1.textColor = [UIColor colorFromHex:@"#fefefe"];
    taglabel1.text = @"免费检测";
    taglabel1.backgroundColor = [UIColor colorFromHex:@"#ffa24f"];
    taglabel1.textAlignment = NSTextAlignmentCenter;
    taglabel1.layer.masksToBounds = YES;
    taglabel1.layer.cornerRadius = 7.5*myDelegate.autoSizeScaleY;
//    [self.contentView addSubview:taglabel1];
    self.Mctag1 = taglabel1;
    
    UILabel *taglabel2 = [[UILabel alloc]initWithFrame:CGRectMake1(112+60+7, 83, 60, 15)];
    [taglabel2 setFont:[UIFont fontWithName:@"Helvetica" size:11 * myDelegate.autoSizeScaleX]];
    taglabel2.textColor = [UIColor colorFromHex:@"#fefefe"];
    taglabel2.text = @"质量保障";
    
    taglabel2.backgroundColor = [UIColor colorFromHex:@"#ff7556"];
    taglabel2.textAlignment = NSTextAlignmentCenter;
    taglabel2.layer.masksToBounds = YES;
    taglabel2.layer.cornerRadius = 7.5*myDelegate.autoSizeScaleY;
//    [self.contentView addSubview:taglabel2];
    self.Mctag2 = taglabel2;
    
//    UIView  *lineView   = [UIUtil drawLineInView:self.contentView frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*2/667) color:[UIColor colorFromHex:@"#e6e6e6"]];
//    lineView.centerX    = Main_Screen_Width/2;
//    lineView.top     = self.contentView.bottom-Main_Screen_Height*2/667;
    
}

- (UIImage *)drawLineByImageView:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度  1是高度
    CGFloat lengths[] = {3,3};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorFromHex:@"#e6e6e6"].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line, imageView.frame.size.width, 2.0);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

-(void)setUpCellWithDic:(NSDictionary *)dic
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,[dic objectForKey:@"Img"]];
//                NSURL *url=[NSURL URLWithString:ImageURL];
//                NSData *data=[NSData dataWithContentsOfURL:url];
//                UIImage *img=[UIImage imageWithData:data];
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    self.McImageView.image = img;
//                });
//            });
    
    NSString *ImageURL=[NSString stringWithFormat:@"%@%@",kHTTPImg,[dic objectForKey:@"Img"]];
    NSURL *url=[NSURL URLWithString:ImageURL];
    [self.McImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"aiche1"]];
    
    self.washTimeString = dic[@"ServiceCount"];
    self.washTimeNumLabel.text = [NSString stringWithFormat:@"洗车%@次",self.washTimeString];
    
    self.Mcname.text = [dic objectForKey:@"MerName"];
    
    self.Mcaddress.text = [dic objectForKey:@"MerAddress"];
    
        //    self.freeTestLabel.text = [dicobjectForKey:@"MerName"];
        //    self.qualityLabel.text = [dicobjectForKey:@"MerName"];
            self.Mcrange.text = [NSString stringWithFormat:@"%.2fkm",[[dic objectForKey:@"Distance"] doubleValue]];
        
            if([[dic objectForKey:@"ShopType"] intValue] == 1)
            {
                self.Mccat.text = @"洗车服务";
            }
        
        
        
            self.Mcscore.text = [NSString stringWithFormat:@"%@分",[dic objectForKey:@"Score"]];
    
    //原来的商家✨
//            [self.Mcxingji setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@xing",[[NSString stringWithFormat:@"%@",[dic objectForKey:@"Score"]] substringToIndex:1]]]];
//
            NSArray *lab = [[dic objectForKey:@"MerFlag"] componentsSeparatedByString:@","];
        
            UILabel *MerflagsLabel = [UILabel new];
            for (int i = 0; i < [lab count]; i++) {
                MerflagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(115 *myDelegate.autoSizeScaleX + i % 3 * 67 *myDelegate.autoSizeScaleX,  i / 3 * 25 *myDelegate.autoSizeScaleY + 85 *myDelegate.autoSizeScaleY, 60*myDelegate.autoSizeScaleX, 15*myDelegate.autoSizeScaleY)];
        
                MerflagsLabel.text = lab[i];
//                MerflagsLabel.backgroundColor = [UIColor redColor];
                [MerflagsLabel setFont:[UIFont fontWithName:@"Helvetica" size:11*Main_Screen_Height/667 ]];
                MerflagsLabel.textColor=[UIColor colorFromHex:@"#a8c4d7"];
                MerflagsLabel.textAlignment = NSTextAlignmentCenter;
                MerflagsLabel.layer.borderColor=[UIColor colorFromHex:@"#a8c4d7"].CGColor;
                MerflagsLabel.layer.borderWidth=0.8;
                MerflagsLabel.layer.masksToBounds = YES;
                MerflagsLabel.layer.cornerRadius = 7.5*myDelegate.autoSizeScaleY;
                [self.contentView addSubview:MerflagsLabel];
            }
    
    //替换某一位置的字符
    if (self.Mcaddress.text.length>=14) {
        NSString *str4 = [self.Mcaddress.text  stringByReplacingCharactersInRange:NSMakeRange(14, self.Mcaddress.text.length-14) withString:@"..."];
        self.Mcaddress.text=str4;
    }
}

CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX;
    rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX;
    rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}

@end
