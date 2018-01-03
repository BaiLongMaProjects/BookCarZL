//
//  OrderZLTableViewCell.m
//  BookingCar
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "OrderZLTableViewCell.h"

@implementation OrderZLTableViewCell
-(void)getInforModel:(OrderCarModel *)Model
{
    self.startLocation.text = Model.from_location;
    self.finishLocation.text = Model.to_location;
    self.dateLabel.text = Model.trip_date;
    self.timeLabel.text = Model.trip_time;
    self.personNum.text = Model.trip_person;
    self.xingLiNum.text = Model.trip_luggage;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@",Model.expect_price];
    
    
    if (self.roleType == CHENGKE_ROLETYPE) {
        //乘客状态
    }
    else{
        //司机状态
    }
    
    if ([Model.status isEqualToString:@"1"]) {
        self.orderType.text = @"等待接单";
    }
    if ([Model.status isEqualToString:@"3"]){
        self.orderType.text = @"准备出发";
    }
    if ([Model.status isEqualToString:@"4"]) {
        if (self.roleType == CHENGKE_ROLETYPE) {
            //乘客状态
            self.orderType.text = @"等待乘客取消行程";
        }
        else{
            //司机状态
            self.orderType.text = @"已取消";
        }
        
    }
    if ([Model.status isEqualToString:@"2"])
    {
        self.orderType.text = @"等待乘客同意";
        //self.LabOrderPeoson.hidden = NO;
        //self.LabOrderPeoson.text = [NSString stringWithFormat:@"%@ 人",Model.people_num];//Model.people_num;
    }
    if ([Model.status isEqualToString:@"5"]){
        if (self.roleType == CHENGKE_ROLETYPE) {
            //乘客状态
            self.orderType.text = @"已取消";
        }
        else{
            //司机状态
            self.orderType.text = @"乘客已取消";
        }
    }
    if ([Model.status isEqualToString:@"8"]) {
        self.orderType.text = @"订单超时";
    }
    if ([Model.status isEqualToString:@"9"]) {
        self.orderType.text = @"订单已完成";
    }
    if ([Model.status isEqualToString:@"0"]) {
        self.orderType.text = @"订单已取消";
    }
    if ([Model.status isEqualToString:@"11"]) {
        if (self.roleType == CHENGKE_ROLETYPE) {
            //乘客状态
            //self.orderType.text = @"已取消";
        }
        else{
            //司机状态
            self.orderType.text = @"已失效";
        }
    }
    if ([Model.status isEqualToString:@"12"]) {
        if (self.roleType == CHENGKE_ROLETYPE) {
            //乘客状态
            //self.orderType.text = @"已取消";
        }
        else{
            //司机状态
            self.orderType.text = @"被邀请";
        }
    }
    //[self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    self.orderUserName.text = Model.nick_name;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
