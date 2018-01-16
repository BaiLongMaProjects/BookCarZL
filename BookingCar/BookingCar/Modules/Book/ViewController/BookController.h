//
//  BookController.h
//  BookingCar
//
//  Created by LiXiaoJing on 29/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>
#import "ZLFisrViewModel.h"
#import "DismissModel.h"
#import "PresentingModel.h"
#import "ZLShareViewController.h"

@interface BookController : BaseController<UIViewControllerTransitioningDelegate>


/** 分享行程的链接 */
@property (nonatomic, copy) NSString *urlString;


@end
