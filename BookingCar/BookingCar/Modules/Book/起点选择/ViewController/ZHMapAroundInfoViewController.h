
//  Created by aimoke on 17/8/9.
//  Copyright © 2017年 LDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapSearchKit/AMapSearchKit.h>
#import "ZHMapView.h"

@protocol BackUpDateBookingDelegate <NSObject>

-(void)UpDateRequsetBooking:(CLLocationCoordinate2D)collaction StartName:(NSString *)name;

@end

@interface ZHMapAroundInfoViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>//,AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *showTableView;

@property (weak, nonatomic) IBOutlet UITextField *TextfieldSearch;//搜索框
@property (weak, nonatomic) IBOutlet UIButton *ButSearch;//搜索按钮

@property (nonatomic, assign) id <BackUpDateBookingDelegate>backBookingDelegate;
//@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) NSString *currentLocationCity;
@property (nonatomic, strong) NSString *currentSelectCity;


@end
