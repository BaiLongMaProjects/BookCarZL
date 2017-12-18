//
//  HomeFinshingViewController.h
//  BookingCar
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ZHMapView.h"
@protocol BackFinishUpDateBookingDelegate <NSObject>

-(void)UpDateRequsetfinishBooking:(CLLocationCoordinate2D)collaction StartName:(NSString *)name;

@end
@interface HomeFinshingViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *showTableView;

@property (weak, nonatomic) IBOutlet UITextField *TextfieldSearch;//搜索框
@property (weak, nonatomic) IBOutlet UIButton *ButSearch;//搜索按钮

@property (nonatomic, assign) id <BackFinishUpDateBookingDelegate>backfinishBookingDelegate;


@end
