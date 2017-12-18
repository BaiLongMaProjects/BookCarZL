//
//  NearDetailModel.h
//  BookingCar
//
//  Created by mac on 2017/9/11.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearDetailModel : RYBaseModel
@property (nonatomic, copy)NSString * backgroud;//背景图片
@property (nonatomic, copy)NSString * company1;//家乡
@property (nonatomic, copy)NSString * company2;//所属地
@property (nonatomic, copy)NSString * gender;//性别
@property (nonatomic, copy)NSString * idTemp;//ID
@property (nonatomic, copy)NSString * job;//职业
@property (nonatomic, copy)NSString * nick_name;//姓名
@property (nonatomic, copy)NSString * portrait_image;//头像
@property (nonatomic, copy)NSString * love;//点赞数
@property (nonatomic, copy)NSString * status;//状态（是否点赞过）
@property (nonatomic, copy)NSString * select_status;//是否请他来接过
@property (nonatomic, copy)NSString * order_id;//订单ID
@property (nonatomic, copy)NSString * driver_id;//车辆ID
@property (nonatomic, copy) NSString *current_province;//当前省份
@property (nonatomic, copy) NSString *current_city;//当前城市
@end
