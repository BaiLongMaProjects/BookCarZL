//
//  ReadyGoView.m
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "ReadyGoView.h"

@implementation ReadyGoView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.ImgHeadPhoto.layer setMasksToBounds:YES];
    [self.ImgHeadPhoto.layer setCornerRadius:35];
    [self.ButCancelTrip.layer setBorderWidth:1];
    [self.ButCancelTrip.layer setMasksToBounds:YES];
    [self.ButCancelTrip.layer setCornerRadius:4];
//    self.ButGoComment.hidden = YES;
}
-(void)getInforOrderCar:(ReadyGoModel *)Model
{

    //取出数据 但是数据格式尽量要对应 大部分是可以使用ObjectForKey的
    NSString * RoleName=[[NSUserDefaults standardUserDefaults] objectForKey:ROLE_TYPE_ZL];
    
    //1 为司机
    if ([RoleName isEqualToString:@"1"]) {

        self.LabDateTime.text = [NSString stringWithFormat:@"%@ %@",Model.trip_date,Model.trip_time];
        self.LabStart.text = Model.from_location;
        self.LabFinish.text = Model.to_location;
        self.LabPeoson.text = Model.trip_person;
        self.LabLuggage.text = Model.trip_luggage;
        [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.c_portrait_image]];
        self.LabName.text = Model.c_nick_name;
        self.LabCarCard.text = @"";
        self.LabModel.text = @"";
        
        if ([Model.status isEqualToString:@"3"] || [Model.status isEqualToString:@"9"]) {
            
            self.LabMoney.text = [NSString stringWithFormat:@"$%@",Model.price];
        }else{
                self.LabLimitMoney.text = @"我的报价";
                self.LabMoney.text = [NSString stringWithFormat:@"$%@",Model.d_price];
        }

    }else{
        //0 为乘客
        self.LabDateTime.text = [NSString stringWithFormat:@"%@ %@",Model.trip_date,Model.trip_time];
        self.LabStart.text = Model.from_location;
        self.LabFinish.text = Model.to_location;
        self.LabPeoson.text = Model.trip_person;
        self.LabLuggage.text = Model.trip_luggage;
        [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.d_portrait_image]];
        self.LabName.text = Model.d_nick_name;
        self.LabCarCard.text = Model.d_plate_num;
        self.LabModel.text = Model.d_model;
        self.ButPhone.hidden = NO;
        self.ButMessage.hidden = NO;
        
        
        if ([Model.status isEqualToString:@"1"] || [Model.status isEqualToString:@"8"] || [Model.status isEqualToString:@"0"]) {
            self.LabLimitMoney.text = @"期望价格";
            self.LabMoney.text = [NSString stringWithFormat:@"$%@",Model.expect_price];
        }else
        {
            self.LabLimitMoney.text = @"司机报价";
            self.LabMoney.text = [NSString stringWithFormat:@"$%@",Model.d_price];
        }

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
