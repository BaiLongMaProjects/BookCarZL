//
//  StartFinishViewController.m
//  BookingCar
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "StartFinishViewController.h"

@interface StartFinishViewController (){
    
    NSString * _searchTextString;
}

@end

@implementation StartFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
}

#pragma mark － TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"placeInfoCellIdentifier";
    ZHPlaceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    ZHPlaceInfoModel *model = [self.listArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.name;
    cell.subTitleLabel.text = model.thoroughfare;
    return cell;
}


#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHPlaceInfoModel *model = [self.listArray objectAtIndex:indexPath.row];

    NSLog(@"%@,%@",model.name,model.thoroughfare);

    NSLog(@"%f,%f",model.coordinate.latitude,model.coordinate.longitude);

    _searchTextString = model.name;

    [self.navigationController popViewControllerAnimated:YES];

    //[self.backBookingDelegate UpDateRequsetBooking:StartLocation StartName:StrStartName];
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


#pragma mark ===================懒加载==================
- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
