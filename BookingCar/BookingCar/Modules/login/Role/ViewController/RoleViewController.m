//
//  RoleViewController.m
//  YiGov2
//
//  Created by mac on 2017/6/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RoleViewController.h"
#import "MainTabViewController.h"
#import "IDCardViewController.h"//认证
@interface RoleViewController ()
{
    NSString  * StrRoleSelect;
}
//fmdb数据库本地缓存
@property (nonatomic,strong)FMDatabase *db;
@end

@implementation RoleViewController
-(void)requsetRoleSelect{
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:StrRoleSelect forKey:@"id"];
    [HttpTool getWithPath:kSetRoleUrl params:params success:^(id responseObj) {
        NSLog(@"设置角色返回信息：%@",responseObj);
        NSString * statusCode = [NSString stringWithFormat:@"%@",responseObj[@"status"]];

        if ([statusCode isEqualToString:@"1"]) {

            [[NSUserDefaults standardUserDefaults] setObject:StrRoleSelect forKey:ROLE_TYPE_ZL];
            //这一步是使数据同步，但不是必须的
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
            
            if ([StrRoleSelect isEqualToString:@"1"]) {
                /** 选择了司机 1 */
                [self requsetDirverMyVerify];
            }else
            {
                /** 选择了乘客 0 */
//                MainTabViewController * mainTabVC = (MainTabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//                [mainTabVC setSelectedIndex:0];
                MainTabViewController * main = [[MainTabViewController alloc]initWithNibName:@"BookController" bundle:[NSBundle mainBundle]];
                [main setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:main animated:YES completion:^{
                    NSLog(@"跳转");
                    
                }];
                /** 发送选择乘客通知 */
            }
            
        }else
        {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        
    } failure:^(NSError *error) {
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//当前角色
-(void)requsetDirverMyVerify
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    NSLog(@"设置角色token：%@",login.token);
    [HttpTool getWithPath:@"api/driver/new-driver-status" params:params success:^(id responseObj) {
        NSLog(@"当前角色我的身份认证返回信息：%@",responseObj);
        NSString * statusCode = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        if ([statusCode isEqualToString:@"0"]) {
//            IDCardViewController * idCard = [[IDCardViewController alloc]init];
//            [self.navigationController pushViewController:idCard animated:YES];
            DriverZiLiaoViewController * ziLiaoVC = [[DriverZiLiaoViewController alloc]init];
            [self.navigationController pushViewController:ziLiaoVC animated:YES];
        }else if([statusCode isEqualToString:@"1"]){
            ShenHeZLViewController *VC = [[ShenHeZLViewController alloc]init];
            VC.type = 0;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else if ([statusCode isEqualToString:@"2"]){
            ShenHeZLViewController *VC = [[ShenHeZLViewController alloc]init];
            VC.type = 1;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else if([statusCode isEqualToString:@"10"]){
            /*
            MainTabViewController * mainTabVC = (MainTabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            [mainTabVC setSelectedIndex:0];
             */
            /*
            MainTabViewController * main = [[MainTabViewController alloc]initWithNibName:@"BookController" bundle:[NSBundle mainBundle]];
            [main setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:main animated:YES completion:^{
                NSLog(@"跳转");
            }];
             */
             [(AppDelegate *)[UIApplication sharedApplication].delegate setRootControllerMainTabVC];
        }
        else{
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark-按钮点击方法
//返回按钮
- (IBAction)BackButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//乘客
- (IBAction)Visitor:(id)sender {
    NSLog(@"我是乘客");
    StrRoleSelect = @"0";
    [self requsetRoleSelect];
}
//司机
- (IBAction)DriverButton:(id)sender {
    NSLog(@"我是司机");
    StrRoleSelect = @"1";
    [self requsetRoleSelect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
