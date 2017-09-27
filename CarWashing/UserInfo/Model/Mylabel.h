//
//  Mylabel.h
//  CarWashing
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop=0,
    VerticalAlignmentMiddle,//default
    VerticalAlignmentBottom,
    
}VerticalAlignment;

@interface Mylabel : UILabel
{
    @private
    VerticalAlignment _verticalAlignment;
}

@property(nonatomic)VerticalAlignment verticalAlignment;

@end
