//
//  WaitingTripViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/16.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "WaitingTripViewController.h"
#import <MapKit/MapKit.h>
#import "OrderCarModel.h"
#import "NearDriverViewController.h"//附近的司机
@interface WaitingTripViewController ()<MKMapViewDelegate,UIAlertViewDelegate>
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong)OrderCarModel * orderModel;

@end

@implementation WaitingTripViewController
-(instancetype)initWithDataModel:(OrderCarModel *)orderModel
{
    if (self=[super init]) {
        _orderModel=[[OrderCarModel alloc]init];
        _orderModel=orderModel;
    }
    return self;
}

-(void)requsetCancelUrl
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:self.orderModel.idTemp forKey:@"order_id"];
    [params setObject:@"已取消" forKey:@"message"];
    [HttpTool getWithPath:kOrderCancel params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        //刷新列表代理
        [_backUpDatedelegate UpDateRequsetOrderCarVCData];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
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
    self.title = @"我的订单";
    [self CreatMapView];
    [self.ViewDetail setFrame:CGRectMake(0, KScreenHeight/2, KScreenWidth, KScreenHeight/2)];
    [self.ButNearCar.layer setMasksToBounds:YES];
    [self.ButNearCar.layer setCornerRadius:15];
    [self.ButNearCar addTarget:self action:@selector(ButNearCarClick:) forControlEvents:UIControlEventTouchUpInside];
   // [self.ButCancelCar.layer setBorderWidth:1.0];
    //    self.ButCancelCar.layer.borderColor=[UIColor orangeColor].CGColor;
    [self.ButCancelCar.layer setMasksToBounds:YES];
    [self.ButCancelCar.layer setCornerRadius:15];
    [self.ButCancelCar addTarget:self action:@selector(ButCancelCarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self getDataRequst];
    
    NSLog(@"idTemp=====%@",self.orderModel.idTemp);
    // Do any additional setup after loading the view from its nib.
}
-(void)getDataRequst{
    self.LabStartLoc.text = self.orderModel.from_location;
    self.LabFinishLoc.text = self.orderModel.to_location;
    self.LabDate.text = self.orderModel.trip_date;
    self.LabTime.text = self.orderModel.trip_time;
    self.LabPeoson.text = self.orderModel.trip_person;
    self.LabLuggage.text = self.orderModel.trip_luggage;
    self.LabMoney.text = [NSString stringWithFormat:@"$%@",self.orderModel.expect_price];
}
-(void)CreatMapView{
#pragma  mark - 添加覆盖物
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/2)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    [mapView addSubview:self.ViewMileage];
    CLLocationCoordinate2D  CenterCoordinate;
    CenterCoordinate.latitude =(_orderModel.CoordinateFinish.latitude - _orderModel.CoordinateStart.latitude)/2 + _orderModel.CoordinateStart.latitude;
    CenterCoordinate.longitude =(_orderModel.CoordinateFinish.longitude - _orderModel.CoordinateStart.longitude)/2 + _orderModel.CoordinateStart.longitude;
    
    //经纬度
    CLLocationCoordinate2D coordinate = CenterCoordinate;
    //比例尺
    MKCoordinateSpan span = {0.15,0.15};
    //设置范围
    //显示范围，数值越大，范围就越大（后面数字越小 比例约小 可以无限接近0）
    //        MKCoordinateSpan span = {0,0.09};
    MKCoordinateRegion region = {coordinate,span};
    //是否允许缩放，一般都会让缩放的
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    //地图初始化时显示的区域
    [mapView setRegion:region];
    //是否显示用户的当前位置
    //        mapView.showsUserLocation = YES;
    _mapView = mapView;
    
    //起点和终点的经纬度
    CLLocationCoordinate2D start = _orderModel.CoordinateStart;
    CLLocationCoordinate2D end = _orderModel.CoordinateFinish;
    //起点终点的详细信息
    MKPlacemark *startPlace = [[MKPlacemark alloc]initWithCoordinate:start addressDictionary:nil];
    MKPlacemark *endPlace = [[MKPlacemark alloc]initWithCoordinate:end addressDictionary:nil];
    //起点 终点的 节点
    MKMapItem *startItem = [[MKMapItem alloc]initWithPlacemark:startPlace];
    MKMapItem *endItem = [[MKMapItem alloc]initWithPlacemark:endPlace];
    
    //路线请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.source = startItem;
    request.destination = endItem;
    //发送请求
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    
    __block NSInteger sumDistance = 0;
    //计算
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            //取出一条路线
            MKRoute *route = response.routes[0];
            
            //关键节点
            for(MKRouteStep *step in route.steps)
            {
                //大头针
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = step.polyline.coordinate;
                annotation.title = step.polyline.title;
                annotation.subtitle = step.polyline.subtitle;
                
                //添加大头针
                //                [self.mapView addAnnotation:annotation];
                //添加路线
                [self.mapView addOverlay:step.polyline];
                //距离
                sumDistance += step.distance;
            }
            self.LabMileage.text = [NSString stringWithFormat:@"%f公里",(long)sumDistance*0.001];
            NSLog(@"总距离 %ld",sumDistance);
            
            
        }
    }];
}
// 返回指定的遮盖模型所对应的遮盖视图, renderer-渲染
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // 判断类型
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 针对线段, 系统有提供好的遮盖视图
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        // 配置，遮盖线的颜色
        render.lineWidth = 5;
        render.strokeColor =  [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
        
        return render;
    }
    // 返回nil, 是没有默认效果
    return nil;
}

#pragma mark --- 按钮点击事件
-(void)ButNearCarClick:(UIButton *)sender
{
    NSLog(@"附近的车");
    NearDriverViewController * nearDriver = [[NearDriverViewController alloc]initWithDataModel:self.orderModel];
    [self.navigationController pushViewController:nearDriver animated:YES];
}
-(void)ButCancelCarClick:(UIButton *)sender
{
    NSLog(@"取消行程");
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要取消行程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 1) {
        //取消接口
        [self requsetCancelUrl];
        
    }
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
