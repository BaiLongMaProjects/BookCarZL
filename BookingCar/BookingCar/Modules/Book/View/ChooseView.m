//
//  ChooseView.m
//  BookingCar
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "ChooseView.h"

@implementation ChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.ButCar setBackgroundImage:[UIImage imageNamed:@"fujincarbutton"] forState:UIControlStateSelected];
    [self.ButCar setBackgroundImage:[UIImage imageNamed:@"fujincarbuttonW"] forState:UIControlStateNormal];
    [self.ButCar setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.ButCar setTitleColor:[UIColor colorWithhex16stringToColor:Main_blueColor_ZL] forState:UIControlStateNormal];
    
    [self.ButPeoson setBackgroundImage:[UIImage imageNamed:@"fujincarbutton"] forState:UIControlStateSelected];
    [self.ButPeoson setBackgroundImage:[UIImage imageNamed:@"fujincarbuttonW"] forState:UIControlStateNormal];
    [self.ButPeoson setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.ButPeoson setTitleColor:[UIColor colorWithhex16stringToColor:Main_blueColor_ZL] forState:UIControlStateNormal];
    
}

@end
