//
//  ZhengJianImageView.m
//  BookingCar
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "ZhengJianImageView.h"

@implementation ZhengJianImageView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"shangchuan"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
