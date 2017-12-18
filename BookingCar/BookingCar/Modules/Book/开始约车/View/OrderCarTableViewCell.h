//
//  OrderCarTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/8/15.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"
@interface OrderCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgHeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UILabel *LabStartLocation;//起始位置
@property (weak, nonatomic) IBOutlet UILabel *LabFinishLocation;//终点位置
@property (weak, nonatomic) IBOutlet UILabel *LabDate;//出行日期
@property (weak, nonatomic) IBOutlet UILabel *LabTime;//出行时间
@property (weak, nonatomic) IBOutlet UILabel *LabPerPeo;//乘车人数
@property (weak, nonatomic) IBOutlet UILabel *LabLuggage;//行李箱数
@property (weak, nonatomic) IBOutlet UILabel *LabMoney;//期望价格
@property (weak, nonatomic) IBOutlet UIView *ViewCarPerson;

-(void)getInfoOrderCarModel:(OrderCarModel *)OrderCar;


@end
