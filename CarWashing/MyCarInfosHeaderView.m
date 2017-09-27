//
//  MyCarInfosHeaderView.m
//  CarWashing
//
//  Created by 时建鹏 on 2017/8/8.
//  Copyright © 2017年 DS. All rights reserved.
//

#import "MyCarInfosHeaderView.h"
#import <Masonry.h>

@implementation MyCarInfosHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10*Main_Screen_Height/667, 10*Main_Screen_Height/667, 20*Main_Screen_Height/667, 20*Main_Screen_Height/667)];
        self.imgV = imgV;
        [self.contentView addSubview:imgV];
        
        UILabel *infosLabel = [[UILabel alloc] init];
        self.infosLabel = infosLabel;
        [self.contentView addSubview:infosLabel];
        
        [infosLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(imgV.mas_trailing).mas_offset(15*Main_Screen_Height/667);
            make.centerY.equalTo(imgV);
        }];
    }
    
    return self;
}
@end
