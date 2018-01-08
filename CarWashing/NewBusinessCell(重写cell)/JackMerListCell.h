//
//  JackMerListCell.h
//  CarWashing
//
//  Created by Wuxinglin on 2017/12/29.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JackMerListModel.h"
#import "KMTagListView.h"
@interface JackMerListCell : UITableViewCell{
    KMTagListView *tag;
}
@property (weak, nonatomic) IBOutlet UIImageView *MerImageJackCell;
@property (weak, nonatomic) IBOutlet UIImageView *MerTypeImageJackCell;
@property (weak, nonatomic) IBOutlet UILabel *MerTitleLabelJackCell;
@property (weak, nonatomic) IBOutlet UILabel *MerAdressLabelJackCell;
//@property (weak, nonatomic) IBOutlet UILabel *MerTypeLableJackMerCell;      //右上角
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabelJackCell;
@property (weak, nonatomic) IBOutlet UILabel *ScoreLabelMerCell;
@property (weak, nonatomic) IBOutlet UILabel *SerNumLableMerCell;
@property (weak, nonatomic) IBOutlet UIView *MerFlagBase;

-(void)setModelValueWithJack:(JackMerListModel*)model;
@end
