//
//  OShowModel.h
//  BookingCar
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYBaseModel.h"
@interface OShowModel : RYBaseModel
@property (nonatomic, copy)NSString * idTemp;
@property (nonatomic, copy)NSString * message;//发送的文字
@property (nonatomic, copy)NSString * point;//昵称
@property (nonatomic, copy)NSString * pv;
@property (nonatomic, copy)NSString * love;//赞 数量
@property (nonatomic, copy)NSString * create_time;//更新时间
@property (nonatomic, copy)NSString * ip;//头像地址
@property (nonatomic, copy)NSString * country;//所属的国家
@property (nonatomic, copy)NSString * city;//所属的城市
@property (nonatomic, copy)NSString * province;//所属的地区
@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * report;//举报
@property (nonatomic, copy)NSString * status_love;//点赞状态

@property (nonatomic, strong)NSArray* attache;
@property (nonatomic, strong)NSArray* comments;
@end
