//
//  OrderCarModel.h
//  BookingCar
//
//  Created by mac on 2017/8/16.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCarModel : RYBaseModel
@property (nonatomic, copy)NSString * from_lat;
@property (nonatomic, copy)NSString * from_lng;
@property (nonatomic, copy)NSString * from_location;
@property (nonatomic, copy)NSString * to_lat;
@property (nonatomic, copy)NSString * to_lng;
@property (nonatomic, copy)NSString * to_location;
@property (nonatomic, copy)NSString * trip_date;
@property (nonatomic, copy)NSString * trip_time;
@property (nonatomic, copy)NSString * expect_price;
@property (nonatomic, copy)NSString * trip_person;
@property (nonatomic, copy)NSString * trip_luggage;
@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * c_status;//是否评价
@property (nonatomic, copy)NSString * people_num;//竞价人数


@property (nonatomic, copy)NSString * idTemp;
@property (nonatomic, assign)CLLocationCoordinate2D CoordinateStart;
@property (nonatomic, assign)CLLocationCoordinate2D CoordinateFinish;
@property (nonatomic, copy)NSString * gender;//性别
@property (nonatomic, copy)NSString * nick_name;//姓名
@property (nonatomic, copy)NSString * portrait_image;//头像
@property (nonatomic, strong)NSDictionary *user_id;


@end
