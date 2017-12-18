//
//  MainTabViewController.m
//  TJProperty
//
//  Created by Miffy@Remmo on 15-5-26.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "MainTabViewController.h"
#import "MainNavigationController.h"
#import "BookController.h"
#import "ChatController.h"
#import "OshowController.h"
#import "MeController.h"
#import "EaseConversationListViewController.h"

#import "OShowSubZLViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : [UIColor blackColor]
                                                        } forState:UIControlStateNormal];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : ButLDXColor
                                                        } forState:UIControlStateSelected];
    [self setSelectedIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BookController *book = [[BookController alloc]init];
    [self addChildViewController:book withImageName:@"home" title:@"首页"];
    
    NSString * currentRole = [kUserDefaults valueForKey:ROLE_TYPE_ZL];
    if([currentRole isEqualToString:@"0"]){
        //0 是乘客
        MyOrderListViewController * myOrderVC = [[MyOrderListViewController alloc]init];
        [self addChildViewController:myOrderVC withImageName:@"xingcheng" title:@"行程"];
        
    }
    else{
        //1 是司机
        //InforModel * infor = [[InforModel alloc]init];
        //infor = [LoginDataModel sharedManager].inforModel;
        OrderStartViewController * orderStart = [[OrderStartViewController alloc]init];
        //orderStart.orderLocation = infor.PointLatLngLocation;
        [self addChildViewController:orderStart withImageName:@"dingdan" title:@"附近订单"];
    }

    
    OShowSubZLViewController * oShowZL = [[OShowSubZLViewController alloc]init];
    [self addChildViewController:oShowZL withImageName:@"oshow" title:@"OShow"];
    
    
    MeController *Me= [[MeController alloc]init];
    [self addChildViewController:Me withImageName:@"personal" title:@"我的"];
    
    //TabBar背景色
    //    self.tabBar.backgroundImage = [UIImage imageNamed:@"toolbar_background"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.tintColor = ButLDXColor;
    
    self.tabBar.selectionIndicatorImage = [[UIImage alloc]init];
    
    
}


- (void)addChildViewController:(UIViewController *)childController withImageName:(NSString *)icon title:(NSString *)title
{
    UITabBarItem *item = childController.tabBarItem;
    childController.title = title;
    NSString *selectIcon = [icon stringByAppendingString:@"_selected"];
    UIImage *iconImage = [UIImage imageNamed:icon];
    UIImage *selectIconImage = [UIImage imageNamed:selectIcon];
    if ([selectIconImage respondsToSelector:@selector(imageWithRenderingMode:)]) {
        selectIconImage = [selectIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.image = iconImage;
    item.selectedImage = selectIconImage;
    
    MainNavigationController *nav = [[MainNavigationController alloc]initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}






@end
