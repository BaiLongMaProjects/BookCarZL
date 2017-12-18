//
//  MyOrderListViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"
#import <RKNotificationHub.h>
#import <EaseUI.h>


typedef NS_ENUM(NSUInteger, ORDER_STATE_TYPE) {
    DENGDAN_TYPE,
    YIJIEDAN_TYPE,
    CHAOSHI_TYPE,
    FINISHEDAN_TYPE,
};

@interface MyOrderListViewController : UIViewController<DZNSegmentedControlDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl *tiGongSubControl;
@property (nonatomic, assign) ORDER_STATE_TYPE currentOrder_Type;
@property (nonatomic, strong) NSMutableArray *dengDanARR;
@property (nonatomic, strong) NSMutableArray *yiJieDanARR;
@property (nonatomic, strong) NSMutableArray *chaoShiARR;
@property (nonatomic, strong) NSMutableArray *finishedARR;
@property (nonatomic, strong) RKNotificationHub *countHub;

@end
