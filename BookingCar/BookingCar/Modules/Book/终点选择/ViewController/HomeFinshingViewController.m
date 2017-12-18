//
//  HomeFinshingViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "HomeFinshingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZHPlaceInfoModel.h"
#import "ZHPlaceInfoTableViewCell.h"
#import <objc/runtime.h>
#import "mapLocation.h"

#import "BookController.h"
#define DEFAULTSPAN 50
#define CellIdntifier @"placeInfoCellIdentifier1"

@interface HomeFinshingViewController ()
{
    BOOL haveGetUserLocation;//是否获取到用户位置
    CLGeocoder *geocoder;
    NSMutableArray *infoArray;//周围信息
    UIImageView *imgView;//中间位置标志视图
    BOOL spanBool;//是否是滑动
    BOOL pinchBool;//是否缩放
    CLLocationManager *_locationManager;
    BOOL ButSearchClick;//点击
    CLLocationCoordinate2D  StartLocation;
    NSString * StrStartName;//开始的位置名称
}

@end

@implementation HomeFinshingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    
    self.title = @"目标位置";
    
    [self.ButSearch addTarget:self action:@selector(geocodeQuery:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.showTableView.tableFooterView = [UIView new];
    spanBool = NO;
    pinchBool = NO;
    [self.showTableView registerNib:[UINib nibWithNibName:@"ZHPlaceInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdntifier];
    geocoder=[[CLGeocoder alloc]init];
    infoArray = [NSMutableArray array];
    haveGetUserLocation = NO;
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    //先查看MapView层次结构
    // NSLog(@"mapview recursiveDescription:\n%@",[self.mapView performSelector:@selector(recursiveDescription)]);
    
    //打印完后我们发现有个View带有手势数组其类型为_MKMapContentView获取Span和Pinch手势
    for (UIView *view in self.mapView.subviews) {
        NSString *viewName = NSStringFromClass([view class]);
        if ([viewName isEqualToString:@"_MKMapContentView"]) {
            UIView *contentView = view;//[self.mapView valueForKey:@"_contentView"];
            for (UIGestureRecognizer *gestureRecognizer in contentView.gestureRecognizers) {
                if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewSpanGesture:)];
                }
                if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewPinchGesture:)];
                }
            }
            
        }
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self resetTableHeadView];
    
    
    
    ButSearchClick = NO;
    
    [self CreatNavButRight];

}
-(void)CreatNavButRight
{
    UIButton *RightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];

    [RightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [RightButton setTitle:@"确定" forState:UIControlStateNormal];
    [RightButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    
}
-(void)showGroupDetailAction
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.TextfieldSearch.text.length == 0) {
        ZHPlaceInfoModel *model = [infoArray objectAtIndex:0];
        StrStartName = model.name;
    }
    [self.backfinishBookingDelegate UpDateRequsetfinishBooking:StartLocation StartName:StrStartName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    [infoArray removeAllObjects];
    [self.showTableView reloadData];
    [self resetTableHeadView];
    CGPoint mapCenter = self.mapView.center;
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:mapCenter toCoordinateFromView:self.mapView];
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    imgView.center = CGPointMake(mapCenter.x, mapCenter.y-15);
    [UIView animateWithDuration:0.2 animations:^{
        imgView.center = mapCenter;
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.05 animations:^{
                imgView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                
            }completion:^(BOOL finished){
                if (finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        imgView.transform = CGAffineTransformIdentity;
                    }completion:^(BOOL finished){
                        if (finished) {
                            spanBool = NO;
                        }
                    }];
                }
            }];
            
        }
    }];
    
}


-(void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLocatingUser");
}


-(void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"mapViewDidStopLocatingUser");
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    if (!haveGetUserLocation) {
        if (self.mapView.userLocationVisible) {
            haveGetUserLocation = YES;
            [self getAddressByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            [self addCenterLocationViewWithCenterPoint:self.mapView.center];
        }
        
    }
}


- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError:%@",error.localizedDescription);
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    
    if (imgView && (spanBool||pinchBool)) {
        [infoArray removeAllObjects];
        [self.showTableView reloadData];
        [self resetTableHeadView];
        CGPoint mapCenter = self.mapView.center;
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:mapCenter toCoordinateFromView:self.mapView];
        [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
        imgView.center = CGPointMake(mapCenter.x, mapCenter.y-15);
        [UIView animateWithDuration:0.2 animations:^{
            imgView.center = mapCenter;
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    imgView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            imgView.transform = CGAffineTransformIdentity;
                        }completion:^(BOOL finished){
                            if (finished) {
                                spanBool = NO;
                            }
                        }];
                    }
                }];
                
            }
        }];
    }
    
}


#pragma mark - Private Methods
-(void)resetTableHeadView
{
    if (infoArray.count>0) {
        self.showTableView.tableHeaderView = nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0)];
        view.backgroundColor = self.showTableView.backgroundColor;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = view.center;
        [indicatorView startAnimating];
        [view addSubview:indicatorView];
        self.showTableView.tableHeaderView = view;
        
    }
}


-(void)addCenterLocationViewWithCenterPoint:(CGPoint)point
{
    if (!imgView) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100, 18, 38)];
        imgView.center = point;
        imgView.image = [UIImage imageNamed:@"Home_Loction"];
        imgView.center = self.mapView.center;
        [self.view addSubview:imgView];
    }
}

-(void)getAroundInfoMationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"移动的精度%f==== 移动的纬度%f ===== ",coordinate.latitude,coordinate.longitude);
    StartLocation = coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, DEFAULTSPAN, DEFAULTSPAN);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.region = region;
    request.naturalLanguageQuery = @"school";
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error) {
            [self getAroundInfomation:response.mapItems];
        }else{
            haveGetUserLocation = NO;
            NSLog(@"Quest around Error:%@",error.localizedDescription);
        }
    }];
}


-(void)getAroundInfomation:(NSArray *)array
{
    for (MKMapItem *item in array) {
        MKPlacemark * placemark = item.placemark;
        ZHPlaceInfoModel *model = [[ZHPlaceInfoModel alloc]init];
        model.name = placemark.name;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        [infoArray addObject:model];
    }
    [self.showTableView reloadData];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initialData:placemarks];
                [self getAroundInfoMationWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
                [self.showTableView reloadData];
                [self resetTableHeadView];
            });
        }else{
            haveGetUserLocation = NO;
            NSLog(@"error:%@",error.localizedDescription);
        }
        
    }];
}


#pragma mark - Initial Data
-(void)initialData:(NSArray *)places
{
    [infoArray removeAllObjects];
    for (CLPlacemark *placemark in places) {
        ZHPlaceInfoModel *model = [[ZHPlaceInfoModel alloc]init];
        model.name = placemark.name;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        [infoArray insertObject:model atIndex:0];
    }
}

#pragma mark － TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return infoArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZHPlaceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdntifier forIndexPath:indexPath];
    ZHPlaceInfoModel *model = [infoArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.name;
    cell.subTitleLabel.text = model.thoroughfare;
    return cell;
}


#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHPlaceInfoModel *model = [infoArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@,%@",model.name,model.thoroughfare);
    
    NSLog(@"%f,%f",model.coordinate.latitude,model.coordinate.longitude);
    
    StrStartName = model.name;
    StartLocation = model.coordinate;
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.backfinishBookingDelegate UpDateRequsetfinishBooking:StartLocation StartName:StrStartName];
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - touchs
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"moved");
    spanBool = YES;
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}


#pragma mark - MapView Gesture
-(void)mapViewSpanGesture:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"SpanGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"SpanGesture Changed");
            spanBool = YES;
        }
            
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"SpanGesture Cancelled");
        }
            
            break;
        case UIGestureRecognizerStateEnded:{
            NSLog(@"SpanGesture Ended");
        }
            
            break;
            
        default:
            break;
    }
}

-(void)mapViewPinchGesture:(UIGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"PinchGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"PinchGesture Changed");
            pinchBool = YES;
        }
            
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"PinchGesture Cancelled");
        }
            
            break;
        case UIGestureRecognizerStateEnded:{
            pinchBool = NO;
            NSLog(@"PinchGesture Ended");
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 查询按钮触发动作
- (void)geocodeQuery:(id)sender {
    
    
    if (self.TextfieldSearch.text == nil || [self.TextfieldSearch.text length] == 0) {
        return ;
    }
    
    StrStartName = self.TextfieldSearch.text;
    
    CLGeocoder *geocode = [[CLGeocoder alloc] init];
    
    [geocode geocodeAddressString:self.TextfieldSearch.text completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"查询记录数: %lu",(unsigned long)[placemarks count]);
        
        if ([placemarks count ] > 0) {
            //移除目前地图上得所有标注点
            [_mapView removeAnnotations:_mapView.annotations];
            
        }
        
        for (int i = 0; i< [placemarks count]; i++) {
            CLPlacemark * placemark = placemarks[i];
            
            //关闭键盘
            [self.TextfieldSearch resignFirstResponder];
            //调整地图位置和缩放比例,第一个参数是目标区域的中心点，第二个参数：目标区域南北的跨度，第三个参数：目标区域的东西跨度，单位都是米
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 10000, 10000);
            
            //重新设置地图视图的显示区域
            [_mapView setRegion:viewRegion animated:YES];
            // 实例化 MapLocation 对象
            mapLocation * annotation = [[mapLocation alloc] init];
            annotation.streetAddress = placemark.name ;
            //            annotation.city = placemark.locality;
            //            annotation.state = placemark.administrativeArea ;
            //            annotation.zip = placemark.postalCode;
            annotation.coordinate = placemark.location.coordinate;
            //把标注点MapLocation 对象添加到地图视图上，一旦该方法被调用，地图视图委托方法mapView：ViewForAnnotation:就会被回调
            [_mapView addAnnotation:annotation];
        }
        
    }];
    
    ButSearchClick = YES;
}


#pragma mark mapView Delegate 地图 添加标注时 回调
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    // 获得地图标注对象
    if (ButSearchClick == YES) {
        MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
        }
        // 设置大头针标注视图为紫色
        annotationView.pinColor = MKPinAnnotationColorPurple ;
        // 标注地图时 是否以动画的效果形式显示在地图上
        annotationView.animatesDrop = YES ;
        // 用于标注点上的一些附加信息
        annotationView.canShowCallout = YES ;
        
        return annotationView;
    }
    return nil;
}


- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
    NSLog(@"error : %@",[error description]);
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
