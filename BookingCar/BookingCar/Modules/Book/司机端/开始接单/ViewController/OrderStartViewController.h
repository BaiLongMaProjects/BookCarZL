//
//  OrderStartViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"
#import "NSObject+XWAdd.h"

@interface OrderStartViewController : UIViewController

@property (nonatomic,strong)CLLocation * orderLocation;
@property (nonatomic, strong) RKNotificationHub *countHub;

@end
