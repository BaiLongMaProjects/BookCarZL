//
//  OrderCarTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/8/15.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OrderCarTableViewCell.h"

@implementation OrderCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.ImgHeadPhoto.layer setMasksToBounds:YES];
    [self.ImgHeadPhoto.layer setCornerRadius:35];
//    [self.ViewCarPerson.layer setMasksToBounds:YES];
    [self.ViewCarPerson.layer setCornerRadius:4];
    // Initialization code
}
-(void)getInfoOrderCarModel:(OrderCarModel *)OrderCar
{

    self.LabName.text = OrderCar.nick_name;
    [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:OrderCar.portrait_image]];
    
    self.LabStartLocation.text = OrderCar.from_location;
    self.LabFinishLocation.text = OrderCar.to_location;
    self.LabDate.text = OrderCar.trip_date;
    self.LabTime.text = OrderCar.trip_time;
    self.LabPerPeo.text = OrderCar.trip_person;
    self.LabLuggage.text = OrderCar.trip_luggage;
    self.LabMoney.text = [NSString stringWithFormat:@"$%@",OrderCar.expect_price];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
