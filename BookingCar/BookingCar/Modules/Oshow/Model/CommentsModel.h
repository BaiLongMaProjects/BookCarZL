//
//  CommentsModel.h
//  BookingCar
//
//  Created by mac on 2017/7/29.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : RYBaseModel

@property (nonatomic, copy) NSString * idTemp;//ID
@property (nonatomic, copy) NSString * comment;//回复内容
@property (nonatomic, copy) NSArray * reply;//反馈的数组
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *show_id;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *replyUserName;

@end
