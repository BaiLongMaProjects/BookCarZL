//
//  CarOrderListViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "OrderWaitingViewController.h"

typedef NS_ENUM(NSUInteger, DRIVER_ORDER_STATE_TYPE) {
    BAOJIA_ZL_TYPE,
    SHIXIAO_ZL_TYPE,
    QUXIAO_ZL_TYPE,
    CHENGJIAO_ZL_TYPE,
    WANCHENG_ZL_TYPE,
    YAOQING_TYPE,
};

@interface CarOrderListViewController : BaseController<DZNSegmentedControlDelegate,UIScrollViewDelegate,BackUpDateWatingVCDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ButNoStart;
@property (weak, nonatomic) IBOutlet UIButton *ButHistory;


@property (nonatomic, assign) DRIVER_ORDER_STATE_TYPE current_type;
@property (nonatomic, strong) DZNSegmentedControl *driverCarOrderSegmented;
@property (nonatomic, strong) NSMutableArray *baoJiaArray;
@property (nonatomic, strong) NSMutableArray *shiXiaoArray;
@property (nonatomic, strong) NSMutableArray *quXiaoArray;
@property (nonatomic, strong) NSMutableArray *chengJiaoArray;
@property (nonatomic, strong) NSMutableArray *wanChengArray;
@property (nonatomic, strong) NSMutableArray *yaoQingArray;


@end
