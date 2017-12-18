//
//  NoStartOrderTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/8/19.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "NoStartOrderTableViewCell.h"

@implementation NoStartOrderTableViewCell

-(void)getInforModel:(OrderCarModel *)Model
{
    self.LabStart.text = Model.from_location;
    self.LabFinish.text = Model.to_location;
    self.LabDate.text = Model.trip_date;
    self.LabTime.text = Model.trip_time;
    self.LabPeoson.text = Model.trip_person;
    self.LabLuggage.text = Model.trip_luggage;
    self.LabMoney.text = [NSString stringWithFormat:@"$%@",Model.expect_price];
    if ([Model.status isEqualToString:@"1"]) {
        self.LabStatus.text = @"等待接单";
    }
    if ([Model.status isEqualToString:@"3"]){
        self.LabStatus.text = @"准备出发";
    }
    if ([Model.status isEqualToString:@"4"]) {
        self.LabStatus.text = @"等待乘客取消行程";
    }
    if ([Model.status isEqualToString:@"2"])
    {
        self.LabStatus.text = @"等待乘客同意";
        //self.LabOrderPeoson.hidden = NO;
        self.LabOrderPeoson.text = [NSString stringWithFormat:@"%@ 人",Model.people_num];//Model.people_num;
    }
    if ([Model.status isEqualToString:@"5"]){
        self.LabStatus.text = @"乘客已同意取消";
    }
    if ([Model.status isEqualToString:@"9"]) {
        self.LabStatus.text = @"订单已完成";
        //是否评论
        self.ButGoComment.hidden = NO;
        if ([Model.c_status isEqualToString:@"0"]) {
            [self.ButGoComment setTitle:@"未评价>>" forState:UIControlStateNormal];
        }else
        {
            [self.ButGoComment setTitle:@"已评价>>" forState:UIControlStateNormal];
        }
    }
    if ([Model.status isEqualToString:@"0"]) {
        self.LabStatus.text = @"订单已取消";
    }
    [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    self.LabName.text = Model.nick_name;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.ImgHeadPhoto.layer setMasksToBounds:YES];
    [self.ImgHeadPhoto.layer setCornerRadius:35];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
