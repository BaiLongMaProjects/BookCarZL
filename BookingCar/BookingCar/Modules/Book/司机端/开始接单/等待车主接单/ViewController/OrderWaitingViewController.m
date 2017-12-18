//
//  OrderWaitingViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OrderWaitingViewController.h"
#import "MapDistanceView.h"
#import "CarDetailView.h"//等待车主接单
@interface OrderWaitingViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)OrderCarModel * orderModel;
@property (nonatomic, strong)MapDistanceView * mapDostanceView;
@property (nonatomic, strong)CarDetailView * carDetailView;
@end

@implementation OrderWaitingViewController
-(instancetype)initWithDataModel:(OrderCarModel*)orderCarModel
{
    if (self = [super init]) {
        _orderModel = [[OrderCarModel alloc]init];
        _orderModel = orderCarModel;
    }
    return self;
}

-(void)requsetOrderQuote{
    [SVProgressHUD show];
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:self.orderModel.idTemp forKey:@"order_id"];
    [params setValue:self.carDetailView.MoneyTextfield.text forKey:@"price"];
    [HttpTool postWithPath:kOrderQuote params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[NSString stringWithFormat:@"%@",responseObj[@"statusCode"]] isEqualToString:@"1"]) {
            [self CreatChangePage];
        }
        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [SVProgressHUD dismiss];
    }];

}
-(void)CreatChangePage
{
    self.carDetailView.ButOrderStart.hidden = YES;
    self.carDetailView.LabMySayMoney.hidden = NO;
    self.carDetailView.MoneyTextfield.hidden = YES;
    self.carDetailView.ButCancleTrip.hidden = NO;
    self.carDetailView.LabMySayMoney.text = self.carDetailView.MoneyTextfield.text;
    self.title = @"等待乘客同意您的报价";
}

-(void)LeftBarCreatButton
{
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_back"] style:UIBarButtonItemStylePlain target:self action:@selector(barBackClick)];
    self.navigationItem.leftBarButtonItem = bar;
}
-(void)barBackClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(UpDateRequsetWatingVCData)]) {
        [self.delegate UpDateRequsetWatingVCData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
//地图
-(MapDistanceView *)mapDostanceView
{
    if (nil == _mapDostanceView) {
        _mapDostanceView = [[[NSBundle mainBundle]loadNibNamed:@"MapDistanceView" owner:self options:nil]lastObject];
        
//        [_mapDostanceView setFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/2)];
    }
    return _mapDostanceView;
}
-(CarDetailView *)carDetailView
{
    if (nil == _carDetailView) {
        _carDetailView = [[[NSBundle mainBundle]loadNibNamed:@"CarDetailView" owner:self options:nil]lastObject];
        _carDetailView.MoneyTextfield.delegate = self;
        _carDetailView.ButCancleTrip.hidden = YES;
        _carDetailView.ButChat.hidden = YES;
        _carDetailView.ButPhone.hidden = YES;
        [_carDetailView.ButOrderStart addTarget:self action:@selector(ButOrderStartClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_carDetailView setFrame:CGRectMake(0, KScreenHeight/2, KScreenWidth, KScreenHeight/2)];
    }
    return _carDetailView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"等待车主接单";
    
    double Slat = [self.orderModel.from_lat doubleValue];
    double Slog = [self.orderModel.from_lng doubleValue];
    double Flat = [self.orderModel.to_lat doubleValue];
    double Flog = [self.orderModel.to_lng doubleValue];
    self.orderModel.CoordinateStart = CLLocationCoordinate2DMake(Slat, Slog);
    self.orderModel.CoordinateFinish = CLLocationCoordinate2DMake(Flat, Flog);
    [self.mapDostanceView getInfoModel:self.orderModel];
    [self.carDetailView getInfoCarDetailOrderCarModel:self.orderModel];
    [self.view addSubview:self.mapDostanceView];
    [self.view addSubview:self.carDetailView];
    [self.carDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(320.0f);
    }];
    [self.mapDostanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.carDetailView.mas_top);
    }];
    [self LeftBarCreatButton];
    // Do any additional setup after loading the view from its nib.
}
-(void)ButOrderStartClick:(UIButton *)sender
{
    NSLog(@"开始接单");
    
    if ([self.carDetailView.MoneyTextfield.text isEqualToString:@""]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的报价" customView:nil hideDelay:2.f];
        return;
    }
    [self requsetOrderQuote];
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
