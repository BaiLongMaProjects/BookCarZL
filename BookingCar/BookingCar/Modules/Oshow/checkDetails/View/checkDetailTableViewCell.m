//
//  checkDetailTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "checkDetailTableViewCell.h"

@implementation checkDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)getInfo:(checkDedatilModel *)Model
{
    [self.ImageHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image]];
    self.LabName.text = Model.nick_name;
    self.LabMessage.text = Model.comment;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
