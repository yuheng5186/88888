//
//  QWMclistTableViewCell.h
//  QWCarWashing
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QWMclistTableViewCell : UITableViewCell

@property(nonatomic,weak)UIImageView *McImageView;
@property(nonatomic,weak)UIImageView *McImagecheckView;
@property(nonatomic,weak)UILabel *Mcname;
@property(nonatomic,weak)UILabel *Mccat;
@property(nonatomic,weak)UIImageView *McImagelubiaoView;
@property(nonatomic,weak)UILabel *Mcrange;
@property(nonatomic,weak)UILabel *Mcaddress;
@property(nonatomic,weak)UIImageView *Mcxingji;
@property(nonatomic,weak)UILabel *Mcscore;

@property(nonatomic,weak)UILabel *Mctag1;
@property(nonatomic,weak)UILabel *Mctag2;

-(void)setlayoutCell;

-(void)setUpCellWithDic:(NSDictionary *)dic;

@end
