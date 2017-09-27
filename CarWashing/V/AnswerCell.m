//
//  AnswerCell.m
//  KCB
//
//  Created by haozp on 16/1/6.
//  Copyright © 2016年 haozp. All rights reserved.
//

#import "AnswerCell.h"
#import "UIView+AutoSizeToDevice.h"

@implementation AnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textViewLabel.userInteractionEnabled = NO;
    
    self.dg_viewAutoSizeToDevice = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
