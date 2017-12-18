//
//  AppDelegate+AppCategoryZL.h
//  BookingCar
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabViewController.h"
#import "CoreNewFeatureVC.h"

/** zl登录页面 */
#import "ZLLoginViewController.h"

@interface AppDelegate (AppCategoryZL)

- (void)setRootControllerLoginVC;
- (void)setRootControllerMainTabVC;

- (void)creatShortcutItem;
- (void)shareButtonAction;

/** 新版本特性展示页面 轮播 */
- (void)newBanBenShow;


@end
