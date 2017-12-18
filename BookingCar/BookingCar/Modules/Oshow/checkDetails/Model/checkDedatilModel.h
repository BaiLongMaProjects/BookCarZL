//
//  checkDedatilModel.h
//  BookingCar
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface checkDedatilModel : RYBaseModel
@property (nonatomic, copy)NSString * comment;
@property (nonatomic, copy)NSString * idTemp;
@property (nonatomic, copy)NSString * nick_name;
@property (nonatomic, copy)NSString * portrait_image;

@property (nonatomic, strong)NSArray * reply;
@end
