//
//  BigPhotoView.m
//  BookingCar
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "BigPhotoView.h"

@implementation BigPhotoView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
    }
    return self;
}


+ (instancetype)defaultPopupView{
    return [[BigPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
