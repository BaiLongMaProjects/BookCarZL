//
//  OrderZLTableViewCell.h
//  BookingCar
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"



@interface OrderZLTableViewCell : UITableViewCell

/** 订单发起人昵称 */
@property (strong, nonatomic) IBOutlet UILabel *orderUserName;
/** 订单状态类型 */
@property (strong, nonatomic) IBOutlet UILabel *orderType;
/** 开始地址 */
@property (strong, nonatomic) IBOutlet UILabel *startLocation;
/** 乘客人数 */
@property (strong, nonatomic) IBOutlet UILabel *personNum;
/** 终点地址 */
@property (strong, nonatomic) IBOutlet UILabel *finishLocation;
/** 行李箱数 */
@property (strong, nonatomic) IBOutlet UILabel *xingLiNum;
/** 开始日期 */
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
/** 开始时间 */
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
/** 期望价格 */
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;


/** 当前用户角色 */
@property (assign, nonatomic) APP_USER_ROLETYPE roleType;


-(void)getInforModel:(OrderCarModel *)Model;

@end
