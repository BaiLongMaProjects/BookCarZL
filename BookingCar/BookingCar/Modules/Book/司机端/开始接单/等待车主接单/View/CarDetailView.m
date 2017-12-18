//
//  CarDetailView.m
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "CarDetailView.h"

@implementation CarDetailView
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.ButOrderStart.layer setMasksToBounds:YES];
    [self.ButOrderStart.layer setCornerRadius:4];
    [self.ImgHeadPhoto.layer setMasksToBounds:YES];
    [self.ImgHeadPhoto.layer setCornerRadius:self.ImgHeadPhoto.frame.size.height/2];
    [self.ButCancleTrip.layer setCornerRadius:5];
    [self.ButCancleTrip.layer setMasksToBounds:YES];
    [self.ButCancleTrip.layer setBorderWidth:1];
}
-(void)getInfoCarDetailOrderCarModel:(OrderCarModel *)Model
{
    [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    self.LabDateTime.text = [NSString stringWithFormat:@"%@ %@",Model.trip_date,Model.trip_time];
    self.LabStartLoc.text = Model.from_location;
    self.LabFinishLoc.text = Model.to_location;
    self.LabPeoson.text = Model.trip_person;
    self.LabLuggage.text = Model.trip_luggage;
    self.LabHopeMoney.text = [NSString stringWithFormat:@"$%@",Model.expect_price];
    self.LabName.text = Model.nick_name;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
