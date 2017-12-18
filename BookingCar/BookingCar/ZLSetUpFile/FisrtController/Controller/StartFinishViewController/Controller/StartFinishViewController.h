//
//  StartFinishViewController.h
//  BookingCar
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "BaseController.h"
#import "ZHPlaceInfoTableViewCell.h"
#import "ZHPlaceInfoModel.h"

@interface StartFinishViewController : BaseController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *listArray;


@end
