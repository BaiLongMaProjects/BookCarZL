//
//  MyOfferViewController.m
//  BookingCar
//
//  Created by mac on 2017/9/29.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "MyOfferViewController.h"

@interface MyOfferViewController ()

@end

@implementation MyOfferViewController

-(void)requsetOffer{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:self.TextOfferView.text forKey:@"context"];
    [params setObject:@"" forKey:@"attache1"];
    
    [HttpTool postWithPath:kSingFeedback params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[NSString stringWithFormat:@"%@",responseObj[@"statusCode"]] isEqualToString:@"1"]) {
            [[RYHUDManager sharedManager] showWithMessage:@"提交成功" customView:nil hideDelay:2.f];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.tabBarController.tabBar setHidden:YES];
//    self.navigationController.navigationBar.hidden = NO;
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.tabBarController.tabBar setHidden:NO];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉建议";
    
    [self.ButSuer addTarget:self action:@selector(ButSuerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ButSuer.layer setMasksToBounds:YES];
    [self.ButSuer.layer setCornerRadius:5];
    [self.TextOfferView.layer setMasksToBounds:YES];
    [self.TextOfferView.layer setCornerRadius:5];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)ButSuerClick:(UIButton *)sender
{
    [self requsetOffer];
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
