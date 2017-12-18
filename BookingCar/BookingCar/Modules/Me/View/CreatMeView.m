//
//  CreatMeView.m
//  BookingCar
//
//  Created by mac on 2017/6/30.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "CreatMeView.h"

@implementation CreatMeView


- (void)awakeFromNib{
    [super awakeFromNib];
    [self.headerButton.layer setCornerRadius:55.0f];
    [self.headerButton.layer setMasksToBounds:YES];//允许裁剪
    //[self.headerBackShadowView.layer setCornerRadius:60.0f];
    //[self.headerBackShadowView.layer setMasksToBounds:YES];//允许裁剪
    [self.backHeadImageVIew.layer setCornerRadius:65.0f];
    [self.backHeadImageVIew.layer setMasksToBounds:YES];
    /** 阴影设置 */
//    CALayer *layer = [self.headerBackShadowView layer];
//    layer.shadowOffset = CGSizeMake(0, 3);
//    layer.shadowRadius = 5.0;
//    layer.shadowColor = [UIColor blackColor].CGColor;
//    layer.shadowOpacity = 0.8;
//    layer.cornerRadius = 9.0;
//    self.headerBackShadowView.clipsToBounds = NO;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
