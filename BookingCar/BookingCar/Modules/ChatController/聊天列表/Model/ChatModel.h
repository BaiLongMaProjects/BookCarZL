//
//  ChatModel.h
//  BookingCar
//
//  Created by mac on 2017/9/13.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "RYBaseModel.h"

@interface ChatModel : RYBaseModel
@property (nonatomic, copy)NSString * content;
@property (nonatomic, copy)NSString * to;
@property (nonatomic, copy)NSString * nick_name;
@property (nonatomic, copy)NSString * portrait_image;
@property (nonatomic, copy)NSString * my_nick_name;//自己的姓名
@property (nonatomic, copy)NSString * my_portrait_image;//自己的头像
@property (nonatomic, copy)NSString * mobile;
@property (nonatomic, copy)NSString * create_time;//时间
@end
