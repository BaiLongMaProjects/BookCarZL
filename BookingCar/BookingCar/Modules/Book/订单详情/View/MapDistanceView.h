//
//  MapDistanceView.h
//  BookingCar
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OrderCarModel.h"

@interface MapDistanceView : UIView<MKMapViewDelegate>
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong)OrderCarModel * orderModel;
@property (weak, nonatomic) IBOutlet UIView *ViewMileage;//公里数View
@property (weak, nonatomic) IBOutlet UILabel *LabMileage;//公里数Lable
@property (weak, nonatomic) IBOutlet UILabel *LabOfferMoney;//建议价格
-(void)getInfoModel:(OrderCarModel *)Model;
@end
