//
//  OShowBigPhotoScrView.m
//  BookingCar
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OShowBigPhotoScrView.h"

@implementation OShowBigPhotoScrView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
        
        [self.ButBackImage addTarget:self action:@selector(ButBackImageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)ButBackImageClick:(UIButton *)sender{
    //本地图片的加载方法
    [self.parentVC lew_dismissPopupView];
}

+ (instancetype)defaultPopupView{
    return [[OShowBigPhotoScrView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
