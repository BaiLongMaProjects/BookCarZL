//
//  MapDistanceView.m
//  BookingCar
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "MapDistanceView.h"

@implementation MapDistanceView


-(void)getInfoModel:(OrderCarModel *)Model
{
#pragma  mark - 添加覆盖物
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
    mapView.delegate = self;
    [self addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self);
    }];
    [mapView addSubview:self.ViewMileage];
    CLLocationCoordinate2D  CenterCoordinate;
//    CenterCoordinate.latitude = (Flat-Slat)/2+Flat;
//    CenterCoordinate.longitude = (Flog-Slog)/2+Slog;
    CenterCoordinate.latitude =(Model.CoordinateFinish.latitude - Model.CoordinateStart.latitude)/2 + Model.CoordinateStart.latitude;
    CenterCoordinate.longitude =(Model.CoordinateFinish.longitude - Model.CoordinateStart.longitude)/2 + Model.CoordinateStart.longitude;
    //经纬度
    CLLocationCoordinate2D coordinate = CenterCoordinate;
    //比例尺
    MKCoordinateSpan span = {0.18,0.18};
    //设置范围
    //显示范围，数值越大，范围就越大（后面数字越小 比例约小 可以无限接近0）
    //        MKCoordinateSpan span = {0,0.09};
    MKCoordinateRegion region = {coordinate,span};
    //是否允许缩放，一般都会让缩放的
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    //地图初始化时显示的区域
    //是否显示用户的当前位置
    //        mapView.showsUserLocation = YES;
    _mapView = mapView;
    [self.mapView setRegion:region animated:YES];
    
//    //定义一个坐标范围
//    MKCoordinateRegion region;
//    //范围的中心点为用户当前位置的坐标
//    region.center = self.mapView.userLocation.coordinate;
//    //跨度为地图范围的跨度
//    region.span = self.mapView.region.span;
//    [self.mapView setRegion:region animated:YES];
    
    //起点和终点的经纬度
    CLLocationCoordinate2D start = Model.CoordinateStart;
    CLLocationCoordinate2D end = Model.CoordinateFinish;
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
            self.LabMileage.text = [NSString stringWithFormat:@"%.2f公里",(long)sumDistance*0.001];
            self.LabOfferMoney.text = [NSString stringWithFormat:@"%.2f$",(long)sumDistance*0.001];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
