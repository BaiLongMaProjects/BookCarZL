//
//  BaseController.m
//  BookingCar
//
//  Created by LiXiaoJing on 26/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#import "BaseController.h"
#import "OshowController.h"
#import "MeController.h"
#import "LoginViewController.h"
#import "EaseEmotionManager.h"
#import "ChatPageViewController.h"

#import "MainTabViewController.h"
#import "MainNavigationController.h"

#import "CarOrderListViewController.h"//司机表
#import "MyOrderListViewController.h"//乘客表

@interface BaseController ()
{
    NSString * RoleName;//我的角色
}

@end
@implementation BaseController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = RGBA(245, 245, 245, 1);
    //取出数据 但是数据格式尽量要对应 大部分是可以使用ObjectForKey的
    RoleName=[[NSUserDefaults standardUserDefaults] objectForKey:ROLE_TYPE_ZL];
    [self viewControllerSettings];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:USER_NOTIFICATION_ZL object:nil];
}

-(void)userInfoNotification:(NSNotification*)notification{
    
    NSDictionary *dict = [notification userInfo];
    NSLog(@"打印通知 ====  %@",dict);
    
    NSString *type=[dict valueForKey:@"m_type"];
    if ([type isEqualToString:@"url"]) {
        
        LoginViewController * login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        [login setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:login animated:YES completion:^{
            NSLog(@"跳转");
        }];
        
    }else if ([type isEqualToString:@"home"])
    {
        MeController *firstvc=[[MeController alloc]init];
        self.tabBarController.selectedIndex = 3;

        //firstvc.url=[aps valueForKey:@"content"];
        [self.navigationController pushViewController:firstvc animated:YES];
    }else if ([type isEqualToString:@"userinfo"])
    {
        
    };
    if ([type isEqualToString:@"chat"]) {
        
        self.tabBarController.selectedIndex = 1;
    }
    if ([type isEqualToString:@"start"]||[type isEqualToString:@"consent"]||[type isEqualToString:@"d_cancel"]||[type isEqualToString:@"c_cancel"]||[type isEqualToString:@"please"] || [type isEqualToString:@"select"]) {
        NSLog(@"开始接单 通知跳转");
        if ([RoleName isEqualToString:@"0"]) {
            if (![[self getCurrentVC] isKindOfClass:[MyOrderListViewController class]]) {
                NSLog(@"乘客端  接单通知跳转，当前VC不为 MyOrderListViewController");
//                MyOrderListViewController * login = [[MyOrderListViewController alloc]initWithNibName:@"MyOrderListViewController" bundle:[NSBundle mainBundle]];
//                MainTabViewController *tabVC = (MainTabViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                MainNavigationController * navVC = (MainNavigationController*)tabVC.viewControllers[1];
//                [navVC pushViewController:login animated:YES];
                self.tabBarController.selectedIndex = 1;
            }else{
                 NSLog(@"乘客端  接单通知跳转，当前VC是-----MyOrderListViewController");
            }
        }else
        {
            if (![[self getCurrentVC] isKindOfClass:[CarOrderListViewController class]]) {
                 NSLog(@"司机端  接单通知跳转，当前VC不为 CarOrderListViewController");
//                CarOrderListViewController * login = [[CarOrderListViewController alloc]initWithNibName:@"CarOrderListViewController" bundle:[NSBundle mainBundle]];
//                MainTabViewController *tabVC = (MainTabViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                MainNavigationController * navVC = (MainNavigationController*)tabVC.viewControllers[1];
//                [navVC pushViewController:login animated:YES];
                self.tabBarController.selectedIndex = 1;
            }
            else{
                NSLog(@"司机端  接单通知跳转，当前VC是-----CarOrderListViewController");
            }
        }
    }
}



-(void)viewControllerSettings{
    self.view.backgroundColor=[UIColor whiteColor];
}



@end
