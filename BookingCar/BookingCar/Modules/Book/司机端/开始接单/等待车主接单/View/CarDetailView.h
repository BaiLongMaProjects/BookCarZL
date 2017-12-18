//
//  CarDetailView.h
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"
@interface CarDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *ButOrderStart;//开始接单按钮
@property (weak, nonatomic) IBOutlet UITextField *MoneyTextfield;

@property (weak, nonatomic) IBOutlet UIImageView *ImgHeadPhoto;//头像

@property (weak, nonatomic) IBOutlet UIButton *ButCancleTrip;//取消行程
@property (weak, nonatomic) IBOutlet UILabel *LabName;//我的姓名

@property (weak, nonatomic) IBOutlet UILabel *LabDateTime;//出行时间

@property (weak, nonatomic) IBOutlet UILabel *LabStartLoc;//起始位置

@property (weak, nonatomic) IBOutlet UILabel *LabFinishLoc;//终点位置

@property (weak, nonatomic) IBOutlet UILabel *LabPeoson;//乘车人数

@property (weak, nonatomic) IBOutlet UILabel *LabLuggage;//行李箱数
@property (weak, nonatomic) IBOutlet UILabel *LabHopeMoney;//期望薪资

@property (weak, nonatomic) IBOutlet UIButton *ButChat;//聊天按钮

@property (weak, nonatomic) IBOutlet UIButton *ButPhone;//电话按钮
@property (weak, nonatomic) IBOutlet UILabel *LabMySayMoney;//我的报价

-(void)getInfoCarDetailOrderCarModel:(OrderCarModel *)Model;




@end
