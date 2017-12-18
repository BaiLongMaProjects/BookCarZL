//
//  MainNavigationController.m
//  TJProperty
//
//  Created by Miffy@Remmo on 15-5-26.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.extendedLayoutIncludesOpaqueBars = NO;
    //背景颜色
    
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height+20)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, .0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color set];
    CGContextFillRect(context, CGRectMake(.0, .0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)initialize
{
    [self setNavigationItemTheme];
    [self setNavigationBarTheme];
}

+ (void)setNavigationItemTheme
{
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttributes[NSShadowAttributeName] = shadow;
    [barItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}

+ (void)setNavigationBarTheme
{
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
//    navBar.barTintColor = RGBAColor(230, 63, 79, 1);
    navBar.barTintColor = [UIColor whiteColor];
//    navBar.barTintColor = ButLDXColor;

    

    //    NSString *navBarBg = @"beijing";
//    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    
    // 3. 设置导航栏的渐变色（iOS7中返回箭头的颜色）
    navBar.tintColor = [UIColor redColor];
    
    // 4.设置导航栏标题颜色
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttributes[NSFontAttributeName] = [UIFont fontWithName:EN_FONT size:18];
    //BodoniSvtyTwoITCTT-BookIta  字体
    // 5.去除阴影
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttributes[NSShadowAttributeName] = shadow;
    [navBar setTitleTextAttributes:textAttributes];
}

-(UIBarButtonItem*) createBackButton
{
    //UIImage* image= [UIImage imageNamed:@"public_back"];
    CGRect backframe= CGRectMake(0, 0, 35,24);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setImage:[UIImage imageNamed:@"public_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    backButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
}

-(void)popself
{
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 0){
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
    [super pushViewController:viewController animated:animated];
}
//更改电池栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
