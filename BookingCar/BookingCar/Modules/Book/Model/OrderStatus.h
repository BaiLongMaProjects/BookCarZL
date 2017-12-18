//
//  OrderStatus.h
//  BookingCar
//
//  Created by mac on 2017/8/29.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStatus : RYBaseModel
@property (nonatomic, copy)NSString * COUNT;//行程个数

@property (nonatomic, copy)NSString * STATUS;//行程状态

@end
