//
//  OrderDetailTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.ImgHeadPhoto.layer setMasksToBounds:YES];
    [self.ImgHeadPhoto.layer setCornerRadius:20];
    // Initialization code
}
-(void)getInfoModel:(MyOrderListModel *)Model
{
    [self.ImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image]];
    self.LabName.text = Model.nick_name;
    self.LabMoney.text = [NSString stringWithFormat:@"$%@",Model.quote_price];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
