//
//  HQTableViewCell.m
//  HQSliderView
//
//  Created by  on 2016/11/15.
//  Copyright © 2016年 . All rights reserved.
//

#import "HQTableViewCell.h"

@implementation HQTableViewCell

+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HQTableViewCell";
    HQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HQTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

@end
