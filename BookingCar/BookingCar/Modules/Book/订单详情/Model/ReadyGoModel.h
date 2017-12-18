//
//  ReadyGoModel.h
//  BookingCar
//
//  Created by mac on 2017/9/13.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "RYBaseModel.h"

@interface ReadyGoModel : RYBaseModel
@property (nonatomic, copy)NSString * create_time;//时间
@property (nonatomic, copy)NSString * d_driver_num;//驾驶证号
@property (nonatomic, copy)NSString * d_mobile;//车主电话
@property (nonatomic, copy)NSString * d_model;//车型
@property (nonatomic, copy)NSString * d_nick_name;//车主姓名
@property (nonatomic, copy)NSString * d_portrait_image;//车主头像
@property (nonatomic, copy) NSString * d_plate_num;//车牌号
@property (nonatomic, copy)NSString * driver_id;//车主ID
@property (nonatomic, copy) NSString * d_price;//车主报价
@property (nonatomic, copy)NSString * from_location;//起点
@property (nonatomic, copy)NSString * idTemp;//客户ID
@property (nonatomic, copy)NSString * price;//价格
@property (nonatomic, copy)NSString * to_location;//终点
@property (nonatomic, copy)NSString * trip_date;//出行日期
@property (nonatomic, copy)NSString * trip_time;//出行时间
@property (nonatomic, copy)NSString * trip_luggage;//行李数
@property (nonatomic, copy)NSString * trip_person;//出行人数
@property (nonatomic, copy)NSString * c_mobile;//乘客电话
@property (nonatomic, copy)NSString * c_nick_name;//乘客姓名
@property (nonatomic, copy)NSString * c_portrait_image;//乘客头像
@property (nonatomic, copy)NSString * expect_price;//期望价格
@property (nonatomic, copy)NSString * status;//状态

@property (nonatomic, copy)NSString * user_id;//乘客id


@end
