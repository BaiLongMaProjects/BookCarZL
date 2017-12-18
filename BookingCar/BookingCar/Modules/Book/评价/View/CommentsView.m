//
//  CommentsView.m
//  BookingCar
//
//  Created by mac on 2017/9/13.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "CommentsView.h"

@implementation CommentsView
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.ButSure.layer setMasksToBounds:YES];
    [self.ButSure.layer setCornerRadius:5];
    
}

-(void)getInfo:(ReadyGoModel *)readyGoModel
{
    //取出数据 但是数据格式尽量要对应 大部分是可以使用ObjectForKey的
    NSString *RoleName = [[NSUserDefaults standardUserDefaults] objectForKey:ROLE_TYPE_ZL];
    if ([RoleName isEqualToString:@"0"]) {
        [self.ImgHead sd_setImageWithURL:[NSURL URLWithString:readyGoModel.d_portrait_image]];
        self.LabName.text = readyGoModel.d_nick_name;
    }else
    {
        [self.ImgHead sd_setImageWithURL:[NSURL URLWithString:readyGoModel.c_portrait_image]];
        self.LabName.text = readyGoModel.c_nick_name;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
