//
//  MyOrderListModel.h
//  BookingCar
//
//  Created by mac on 2017/9/6.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYBaseModel.h"

@interface MyOrderListModel : RYBaseModel
@property (nonatomic, copy)NSString * backgroud;//背景
@property (nonatomic, copy)NSString * create_time;//时间
@property (nonatomic, copy)NSString * driver_id;//车行id
@property (nonatomic, copy)NSString * idTemp;//id数
@property (nonatomic, copy)NSString * mobile;//电话
@property (nonatomic, copy)NSString * nick_name;//姓名
@property (nonatomic, copy)NSString * order_id;//订单id
@property (nonatomic, copy)NSString * portrait_image;//头像
@property (nonatomic, copy)NSString * quote_price;//报的价格

@end
