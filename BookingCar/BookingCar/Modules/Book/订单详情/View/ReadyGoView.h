//
//  ReadyGoView.h
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadyGoModel.h"
@interface ReadyGoView : UIView
@property (weak, nonatomic) IBOutlet UIButton *ButCancelTrip;//取消行程
@property (weak, nonatomic) IBOutlet UIButton *ButMessage;//聊天
@property (weak, nonatomic) IBOutlet UIButton *ButPhone;//电话
@property (weak, nonatomic) IBOutlet UIImageView *ImgHeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UILabel *LabCarCard;//车牌号
@property (weak, nonatomic) IBOutlet UILabel *LabModel;//型号
@property (weak, nonatomic) IBOutlet UILabel *LabDateTime;//出行时间
@property (weak, nonatomic) IBOutlet UILabel *LabStart;//起始位置
@property (weak, nonatomic) IBOutlet UILabel *LabFinish;//终点位置
@property (weak, nonatomic) IBOutlet UILabel *LabMoney;//成交金额
@property (weak, nonatomic) IBOutlet UILabel *LabLimitMoney;//成交金额
@property (weak, nonatomic) IBOutlet UIButton *ButGoComment;//去评价
@property (weak, nonatomic) IBOutlet UIButton *ButHopeCancel;//希望乘客取消订单
@property (weak, nonatomic) IBOutlet UILabel *LabPeoson;//乘车人数
@property (weak, nonatomic) IBOutlet UILabel *LabLuggage;//行李箱数

-(void)getInforOrderCar:(ReadyGoModel *)Model;


@end
