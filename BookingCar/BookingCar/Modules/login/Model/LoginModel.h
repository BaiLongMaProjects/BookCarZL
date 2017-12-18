//
//  LoginModel.h
//  BookingCar
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "RYBaseModel.h"

@interface LoginModel : RYBaseModel<NSCoding>
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *deviceToken;
@end
