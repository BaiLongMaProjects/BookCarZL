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

@property (nonatomic, assign)BOOL SwitchBool;

-(instancetype)initWithDataModel:(OrderCarModel *)orderCarModel;

@end
