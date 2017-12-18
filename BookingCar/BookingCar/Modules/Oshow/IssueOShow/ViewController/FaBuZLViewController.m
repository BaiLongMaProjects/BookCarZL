//
//  FaBuZLViewController.m
//  BookingCar
//
//  Created by apple on 2017/10/20.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "FaBuZLViewController.h"

@interface FaBuZLViewController ()

@end

@implementation FaBuZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布动态";
    // Do any additional setup after loading the view from its nib.
    [self loadTopUI];
}

- (void)loadTopUI{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 60, 30)];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(fabuButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];

    
}
- (void)fabuButtonAction:(id)sender{
    
    
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
