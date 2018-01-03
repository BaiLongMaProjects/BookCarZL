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
