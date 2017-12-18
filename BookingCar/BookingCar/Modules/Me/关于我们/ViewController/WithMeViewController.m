//
//  WithMeViewController.m
//  BookingCar
//
//  Created by mac on 2017/9/23.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "WithMeViewController.h"

@interface WithMeViewController ()

@end

@implementation WithMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"about"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    UILabel * label = [UILabel new];
    label.text = kAppVersion;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-50.0f);
    }];
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
