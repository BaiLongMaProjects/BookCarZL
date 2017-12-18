//
//  OrderCarViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/14.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "OrderCarModel.h"

@interface OrderCarViewController : BaseController
@property (nonatomic, assign)CLLocationCoordinate2D CoordinateStart;
@property (nonatomic, strong)NSString * StrStartName;
@property (nonatomic, assign)CLLocationCoordinate2D CoordinateFinish;
@property (nonatomic, strong)NSString * StrFinishName;

-(instancetype)initWithDataModel:(OrderCarModel *)orderModel;

@end
