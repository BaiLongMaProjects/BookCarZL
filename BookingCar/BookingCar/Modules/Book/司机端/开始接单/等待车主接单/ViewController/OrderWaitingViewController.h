//
//  OrderWaitingViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "OrderCarModel.h"
@protocol BackUpDateWatingVCDelegate <NSObject>
-(void)UpDateRequsetWatingVCData;
@end
@interface OrderWaitingViewController : BaseController

@property (nonatomic, assign)id <BackUpDateWatingVCDelegate>delegate;

-(instancetype)initWithDataModel:(OrderCarModel *)orderCarModel;

@end
