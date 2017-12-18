//
//  NoStartOrderTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/8/19.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"
@interface NoStartOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgHeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UIView *ViewCard;//卡片
@property (weak, nonatomic) IBOutlet UILabel *LabStart;//开始位置
@property (weak, nonatomic) IBOutlet UILabel *LabFinish;//终点位置
@property (weak, nonatomic) IBOutlet UILabel *LabDate;//开始日期
@property (weak, nonatomic) IBOutlet UILabel *LabTime;//开始时间
@property (weak, nonatomic) IBOutlet UILabel *LabStatus;//行程状态
@property (weak, nonatomic) IBOutlet UILabel *LabPeoson;//乘车人数
@property (weak, nonatomic) IBOutlet UILabel *LabLuggage;//行李箱数
@property (weak, nonatomic) IBOutlet UILabel *LabMoney;//期望价格
@property (weak, nonatomic) IBOutlet UILabel *LabHopeMoney;
@property (weak, nonatomic) IBOutlet UILabel *LabOrderPeoson;//接单人数
@property (weak, nonatomic) IBOutlet UIButton *ButGoComment;//去评价
@property (weak, nonatomic) IBOutlet UILabel *LabName;//我的姓名
-(void)getInforModel:(OrderCarModel *)Model;
@end
