//
//  ZLShareViewController.h
//  BookingCar
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Zhou. All rights reserved.
//

#import "BaseController.h"

@interface ZLShareViewController : BaseController
/** 开始地点 */
@property (nonatomic, copy) NSString *startLocation;
/** 结束地点 */
@property (nonatomic, copy) NSString *finishLocation;
/** 出行时间 */
@property (nonatomic, copy) NSString *timeString;
/** 出行价格 */
@property (nonatomic, copy) NSString *priceString;
/** 分享链接 */
@property (nonatomic, copy) NSString *urlString;
@property (strong, nonatomic) IBOutlet UIImageView *successView;


@end
