//
//  WaitingTripViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/16.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"
@protocol BackUpDateOrderCarVCDelegate <NSObject>
-(void)UpDateRequsetOrderCarVCData;
@end

@interface WaitingTripViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *ViewMileage;//公里数View
@property (weak, nonatomic) IBOutlet UILabel *LabMileage;//公里数Lable
@property (weak, nonatomic) IBOutlet UIView *ViewDetail;//详细
@property (weak, nonatomic) IBOutlet UIButton *ButNearCar;//附近的司机
@property (weak, nonatomic) IBOutlet UIButton *ButCancelCar;//取消行程
@property (weak, nonatomic) IBOutlet UILabel *LabStartLoc;//起始位置
@property (weak, nonatomic) IBOutlet UILabel *LabFinishLoc;//终点位置
@property (weak, nonatomic) IBOutlet UILabel *LabDate;//出行日期
@property (weak, nonatomic) IBOutlet UILabel *LabTime;//出行时间
@property (weak, nonatomic) IBOutlet UILabel *LabPeoson;//乘车人数
@property (weak, nonatomic) IBOutlet UILabel *LabLuggage;//行李数
@property (weak, nonatomic) IBOutlet UILabel *LabMoney;//期望金额


@property (nonatomic, assign) id <BackUpDateOrderCarVCDelegate> backUpDatedelegate;

-(instancetype)initWithDataModel:(OrderCarModel *)orderModel;

@end
