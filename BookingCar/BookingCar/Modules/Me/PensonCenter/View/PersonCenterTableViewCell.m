//
//  PersonCenterTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/7/2.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "PersonCenterTableViewCell.h"

@implementation PersonCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
