//
//  ShenHeZLViewController.m
//  BookingCar
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "ShenHeZLViewController.h"

@interface ShenHeZLViewController ()

@end

@implementation ShenHeZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.button.layer setCornerRadius:6];
    self.title = @"审核结果";
//    [self.button.layer setMasksToBounds:YES];
    // Do any additional setup after loading the view from its nib.
    [self setTypeView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self.tabBarController.tabBar setHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.tabBarController.tabBar setHidden:NO];
}

- (void)setTypeView{
    if (self.type == 0) {
        self.label.text = @"审核中...";
        self.button.hidden = YES;
    }
    else{
        self.label.text = @"审核未通过";
        self.button.hidden = NO;
        
    }
    
}

- (IBAction)buttonAction:(id)sender {
    DriverZiLiaoViewController * ziLiaoVC = [[DriverZiLiaoViewController alloc]init];
    [self.navigationController pushViewController:ziLiaoVC animated:YES];

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
