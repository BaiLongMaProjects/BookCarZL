//
//  MyLifeHeadView.m
//  BookingCar
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "MyLifeHeadView.h"

@implementation MyLifeHeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.ImgHeadPhoto.layer setMasksToBounds:YES];
    [self.ImgHeadPhoto.layer setCornerRadius:self.ImgHeadPhoto.frame.size.height/2];
}
-(void)getInfo:(MyLifeHeadModel *)Model
{
    self.LabName.text = [NSString stringWithFormat:@"姓名：%@",Model.nick_name];
    self.LabJob.text = [NSString stringWithFormat:@"职业：%@",Model.job];
    self.LabTown.text = [NSString stringWithFormat:@"家乡：%@",Model.company2];
    self.LabBelongs.text = [NSString stringWithFormat:@"所属地：%@",Model.company1];
    self.LabSingleNum.text = [NSString stringWithFormat:@"成单量：%@",Model.order_num];
    self.LabLoveNum.text = [NSString stringWithFormat:@"点赞数：%@",Model.favorite];
    self.LabComments.text = [NSString stringWithFormat:@"评价数：%@",Model.comment];
    [self.ImgBigPhoto sd_setImageWithURL:[NSURL URLWithString:Model.backgroud]];
    [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
