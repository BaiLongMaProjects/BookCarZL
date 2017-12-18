
//
//  AppDelegate+AppCategoryZL.m
//  BookingCar
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "AppDelegate+AppCategoryZL.h"

@implementation AppDelegate (AppCategoryZL)

/** 原来的登录页面 */
//- (void)setRootControllerLoginVC{
//    LoginViewController * login = [[LoginViewController alloc]init];
//    UINavigationController * navVC = [[UINavigationController alloc]initWithRootViewController:login];
//    self.window.rootViewController=navVC;
//    [self.window makeKeyAndVisible];
//
//}
/** 1.2.3登录页面 ZL */
- (void)setRootControllerLoginVC{
    ZLLoginViewController * login = [[ZLLoginViewController alloc]init];
    MainNavigationController * navVC = [[MainNavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController=navVC;
    [self.window makeKeyAndVisible];
}
/** 设置RootVC为TabbarController*/
- (void)setRootControllerMainTabVC{
    MainTabViewController *tabController=[[MainTabViewController alloc]init];
    self.window.rootViewController=tabController;
    [self.window makeKeyAndVisible];
}

/** 3D Touch 实现 */
- (void)creatShortcutItem {
//    if ([self respondsToSelector:@selector(traitCollection)])
//    {
//        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
//        {
//            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
//            {
//                // 支持3D Touch
//            }
//            else
//            {
//                // 不支持3D Touch
//            }
//        }
//    }
    
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.yang.share" localizedTitle:@"分享" localizedSubtitle:@"白龙马出行" icon:icon userInfo:nil];
    UIApplicationShortcutIcon *searchShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *searchShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.liupeng.search" localizedTitle:@"Search" localizedSubtitle:@"Search Subtitle" icon:searchShortcutIcon userInfo:nil];
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];
}

/** 分享按钮实现 */
- (void)shareButtonAction{
    NSArray *images = @[@"测试"];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:images applicationActivities:nil];
//    [self.navigationController presentViewController:activityController animated:YES completion:nil];
    UINavigationController *myNavi = self.window.rootViewController.childViewControllers[0];
    [myNavi presentViewController:activityController animated:YES completion:nil];

}
#pragma mark ===================新版本特性展示页面 开始==================
- (void)newBanBenShow{
    LoginModel * loginMo = [[LoginModel alloc]init];
    loginMo= [LoginDataModel sharedManager].loginInModel;
    NewFeatureModel * model1 = [NewFeatureModel model:[UIImage imageNamed:@"dao01"]];
    NewFeatureModel * model2 = [NewFeatureModel model:[UIImage imageNamed:@"dao02"]];
    NewFeatureModel * model3 = [NewFeatureModel model:[UIImage imageNamed:@"dao03"]];
    CoreNewFeatureVC * vc = [CoreNewFeatureVC newFeatureVCWithModels:@[model1,model2,model3] enterBlock:^{
        if (loginMo.token.length > 0) {
            //自动登录 下次不用再等，默认是关闭的
            EMError *error = [[EMClient sharedClient] loginWithUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL] password:[kUserDefaults valueForKey:USER_PASSWORD_ZL]];
            if (!error)
            {
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }
            MainTabViewController *tabController = [[MainTabViewController alloc]init];
            self.window.rootViewController = tabController;
        }
        else{
            ZLLoginViewController * login = [[ZLLoginViewController alloc]init];
            MainNavigationController * navVC = [[MainNavigationController alloc]initWithRootViewController:login];
            self.window.rootViewController=navVC;
            [self.window makeKeyAndVisible];
        }
    }];
    self.window.rootViewController = vc;
}
#pragma mark ===================新版本特性展示页面 结束==================

@end
