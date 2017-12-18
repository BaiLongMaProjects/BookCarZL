//
//  OrderStartListTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/8/27.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OrderStartListTableViewCell.h"

@implementation OrderStartListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.ImgHeadPhoto.layer setMasksToBounds:YES];
    [self.ImgHeadPhoto.layer setCornerRadius:self.ImgHeadPhoto.frame.size.height/2];
    // Initialization code
}

-(void)getInfoOrderCarModel:(OrderCarModel *)Model
{
    self.LabStartLoc.text = Model.from_location;
    self.LabFinishLoc.text = Model.to_location;
    self.LabDate.text = Model.trip_date;
    self.LabTime.text = Model.trip_time;
    self.LabLuggage.text = Model.trip_luggage;
    self.LabPeoson.text = Model.trip_person;
    self.LabMoney.text = [NSString stringWithFormat:@"$%@",Model.expect_price];
    if ([Model.status isEqualToString:@"0"]) {
        self.LabStatus.text = @"用户已取消";
    }
    if ([Model.status isEqualToString:@"1"]) {
        self.LabStatus.text = @"等待车主接单";
    }
    if ([Model.status isEqualToString:@"2"]) {
        self.LabStatus.text = @"等待乘客同意";
    }
    if ([Model.status isEqualToString:@"3"]) {
        self.LabStatus.text = @"乘客已同意";
    }
    if ([Model.status isEqualToString:@"5"]) {
        self.LabStatus.text = @"乘客已同意取消";
    }
    if ([Model.status isEqualToString:@"8"]) {
        self.LabStatus.text = @"该行程已超时";
    }
    if ([Model.status isEqualToString:@"9"]) {
        self.LabStatus.text = @"已完成";
    }
    self.LabName.text = Model.nick_name;
    if (![Model.portrait_image isEqualToString:@""]) {
        [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
