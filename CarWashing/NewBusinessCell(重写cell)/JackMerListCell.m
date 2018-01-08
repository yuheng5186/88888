//
//  JackMerListCell.m
//  CarWashing
//
//  Created by Wuxinglin on 2017/12/29.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "JackMerListCell.h"
//加载图片
#import <SDWebImage/UIImageView+WebCache.h>
#import "HTTPDefine.h"


@implementation JackMerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelValueWithJack:(JackMerListModel *)model{
    
    //服务了多少
    self.SerNumLableMerCell.text = [NSString stringWithFormat:@"%ld单",(long)model.ServiceCount];
    
    //评分
    self.ScoreLabelMerCell.text = [NSString stringWithFormat:@"%.1f分",model.Score];
    
    //距离
    self.DistanceLabelJackCell.text = [NSString stringWithFormat:@"%.1fkm",model.Distance];
    
    //右上角类别
//    self.MerTypeLableJackMerCell.text = [NSString stringWithFormat:@"洗车服务"];
    
    //地址
    self.MerAdressLabelJackCell.text = [NSString stringWithFormat:@"%@",model.MerAddress];
    
    //商家名称
    self.MerTitleLabelJackCell.text = [NSString stringWithFormat:@"%@",model.MerName];
    
    //商家大图
    [self.MerImageJackCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHTTPImg,model.Img]]];
    
//    //大图下面的小图片      1.智能洗车,2.快速,3.休息
//    if (model.ShopType == 1) {
//        //智能洗车
//        self.MerTypeImageJackCell.image = [UIImage imageNamed:@"ZhiNengXiChe"];
//    }else if (model.ShopType == 2){
//        //快速洗车
//        self.MerTypeImageJackCell.image = [UIImage imageNamed:@"ZiDongXiChe"];
//    }else if (model.ShopType == 3){
//        //休息
//        self.MerTypeImageJackCell.image = [UIImage imageNamed:@"ShangJiaXiuXi"];
//    }
    
    //商家flag
    self.MerFlagBase.backgroundColor = [UIColor whiteColor];
    NSArray *flagArray = [model.MerFlag componentsSeparatedByString:@","];
    if (tag == nil) {
        tag = [[KMTagListView alloc]initWithFrame:CGRectMake(-15.0/375*Main_Screen_Width, 0, Main_Screen_Width-100, 0)];
        tag.scrollEnabled = NO;
        [tag setupSubViewsWithTitles:flagArray];
        [self.MerFlagBase addSubview:tag];
        CGRect rect = tag.frame;
        rect.size.height = tag.contentSize.height+5;
        rect.size.width = self.MerFlagBase.frame.size.width;
        tag.frame = rect;
    }

}

@end
