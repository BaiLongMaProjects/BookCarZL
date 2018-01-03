//
//  OrderDetailsViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"
#import "ChatSubViewVC.h"
@interface OrderDetailsViewController : UIViewController
/** zl弃用 */
@property (nonatomic, assign)BOOL SwitchBool;
/** 当前角色类型  乘客 司机 */
@property (nonatomic, assign) APP_USER_ROLETYPE roleType;
/** 为司机时的  订单状态类型 */
@property (nonatomic, assign) DRIVER_ORDER_STATE_TYPE driver_OrderState_Type;
/** 为乘客时 的状态类型   */
@property (nonatomic, assign) ORDER_STATE_TYPE chengKe_OrderState_Type;



-(instancetype)initWithDataModel:(OrderCarModel *)orderCarModel;

@end
