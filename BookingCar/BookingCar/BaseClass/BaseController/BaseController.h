//
//  BaseController.h
//  BookingCar
//
//  Created by LiXiaoJing on 26/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.

#import <UIKit/UIKit.h>

/** 枚举类型  乘客 司机 */
typedef NS_ENUM(NSUInteger, APP_USER_ROLETYPE) {
    CHENGKE_ROLETYPE,
    DRIVER_ROLETYPE,
};
/** 角色为司机时的订单状态类型 */
typedef NS_ENUM(NSUInteger, DRIVER_ORDER_STATE_TYPE) {
    BAOJIA_ZL_TYPE,
    SHIXIAO_ZL_TYPE,
    QUXIAO_ZL_TYPE,
    CHENGJIAO_ZL_TYPE,
    WANCHENG_ZL_TYPE,
    YAOQING_TYPE,
};
/** 角色为乘客时的订单状态类型 */
typedef NS_ENUM(NSUInteger, ORDER_STATE_TYPE) {
    DENGDAN_TYPE,
    YIJIEDAN_TYPE,
    CHAOSHI_TYPE,
    FINISHEDAN_TYPE,
};


@interface BaseController : UIViewController

@end
