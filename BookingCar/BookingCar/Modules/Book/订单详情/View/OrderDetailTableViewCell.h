//
//  OrderDetailTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderListModel.h"
@interface OrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgHeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UILabel *LabName;//名字
@property (weak, nonatomic) IBOutlet UILabel *LabMoney;//价格

@property (weak, nonatomic) IBOutlet UILabel *LabMoneyYes;//同意价格

-(void)getInfoModel:(MyOrderListModel *)Model;
@end
