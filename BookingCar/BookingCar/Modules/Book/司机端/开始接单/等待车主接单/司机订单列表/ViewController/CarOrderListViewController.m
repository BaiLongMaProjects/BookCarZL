//
//  CarOrderListViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "CarOrderListViewController.h"
//#import "NoStartOrderTableViewCell.h"//自定义cell
#import "OrderCarModel.h"
#import "OrderDetailsViewController.h"//行程详情
#import "WaitingTripViewController.h"
#import "OrderZLTableViewCell.h"//订单列表ListCell

@interface CarOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL MyOrderBooL;
    UITableView * MyOrdertabView;
    NSMutableArray * NoStartArray;
    NSMutableArray * HistoryArray;
    NSInteger OrderPage;
}
@property (nonatomic, strong)OrderZLTableViewCell * nostartTabCell;
@property (nonatomic, strong)OrderCarModel * orderCarModel;

@end

@implementation CarOrderListViewController
-(OrderZLTableViewCell *)nostartTabCell
{
    if (nil == _nostartTabCell) {
        _nostartTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderZLTableViewCell" owner:self options:nil]lastObject];
    }
    return _nostartTabCell;
}
-(void)requsetMyOrderList{
    [self showLoading];
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:@"100" forKey:@"per_page"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)OrderPage] forKey:@"page"];
    [HttpTool getWithPath:kOrderMyList2 params:params success:^(id responseObj) {
        [self dismissLoading];
        //结束刷新
        [MyOrdertabView.mj_header endRefreshing];
        [MyOrdertabView.mj_footer endRefreshing];
        if (OrderPage == 0) {
            [self.wanChengArray removeAllObjects];
            [self.quXiaoArray removeAllObjects];
            [self.baoJiaArray removeAllObjects];
            [self.shiXiaoArray removeAllObjects];
            [self.yaoQingArray removeAllObjects];
            [self.chengJiaoArray removeAllObjects];
        }
        NSLog(@"driver-orderList：%@",responseObj);
        if (responseObj[@"data"] == nil) {
            return;
        }
        for (NSDictionary * dic in responseObj[@"data"]) {
            OrderCarModel * orderCar = [[OrderCarModel alloc]initWithRYDict:dic];
            
            if ([orderCar.status isEqualToString:@"2"]) {
                [self.baoJiaArray addObject:orderCar];
            }
            if ([orderCar.status isEqualToString:@"11"]||[orderCar.status isEqualToString:@"8"]) {
                [self.shiXiaoArray addObject:orderCar];
            }
            if ([orderCar.status isEqualToString:@"0"]||[orderCar.status isEqualToString:@"4"]||[orderCar.status isEqualToString:@"5"]) {
                [self.quXiaoArray addObject:orderCar];
            }
            if ([orderCar.status isEqualToString:@"3"]) {
                [self.chengJiaoArray addObject:orderCar];
            }
            if ([orderCar.status isEqualToString:@"9"]) {
                [self.wanChengArray addObject:orderCar];
            }
            if ([orderCar.status isEqualToString:@"12"]) {
                [self.yaoQingArray addObject:orderCar];
            }
        }
        [MyOrdertabView reloadData];
    } failure:^(NSError *error) {
        [self dismissLoading];
        NSLog(@"司机我的订单错误：%@",error);
        //结束刷新
        [MyOrdertabView.mj_header endRefreshing];
        [MyOrdertabView.mj_footer endRefreshing];
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requsetMyOrderList];
 
    [self.tabBarController.tabBar setHidden:YES];
    //self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    MyOrderBooL = YES;
    self.current_type = BAOJIA_ZL_TYPE;
    self.title = @"我的订单";

    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        //make.top.mas_equalTo(self.view).mas_offset(64.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [backView addSubview:self.driverCarOrderSegmented];
    
    MyOrdertabView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    MyOrdertabView.delegate = self;
    MyOrdertabView.dataSource = self;
    [self.view bringSubviewToFront:MyOrdertabView];
    MyOrdertabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MyOrdertabView.backgroundColor = [UIColor colorWithhex16stringToColor:Main_Background_Gray_Color];
    [self.view addSubview:MyOrdertabView];
    
    [MyOrdertabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(backView.mas_bottom);
    }];
    
    
    [self CreatMJRefresh];

    /** iOS11.0 处理TableView ScrollView 留白问题 */
    /*
    if (@available(iOS 11.0, *)) {
        
        MyOrdertabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }*/
    
    /** 解决顶部导航栏便宜64.0,iPhone X 偏移84.0*/
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
}

#pragma mark -- 下拉刷新
-(void)CreatMJRefresh{
    MyOrdertabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        OrderPage = 0;
        [self requsetMyOrderList];

    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    MyOrdertabView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    MyOrdertabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        OrderPage ++;
        if (OrderPage >= 0) {
                [self requsetMyOrderList];
        }
        
    }];
    
}

#pragma mark -- TabViewdelegate
-(void)CreatTabView{

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.current_type) {
        case BAOJIA_ZL_TYPE:{
            return self.baoJiaArray.count;
        }
            break;
        case YAOQING_TYPE:{
            return self.yaoQingArray.count;
        }
            break;
        case CHENGJIAO_ZL_TYPE:{
            return self.chengJiaoArray.count;
        }
            break;
        case SHIXIAO_ZL_TYPE:{
            return self.shiXiaoArray.count;
        }
            break;
        case QUXIAO_ZL_TYPE:{
            return self.quXiaoArray.count;
        }
            break;
        case WANCHENG_ZL_TYPE:{
            return self.wanChengArray.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identCell = @"orderZlCellID";
    self.nostartTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
    if (!self.nostartTabCell) {
        self.nostartTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderZLTableViewCell" owner:self options:nil]lastObject];
    }
    OrderCarModel * order = [[OrderCarModel alloc]init];
    switch (self.current_type) {
        case BAOJIA_ZL_TYPE:{
            order = self.baoJiaArray[indexPath.row];
        }
            break;
        case YAOQING_TYPE:{
            order = self.yaoQingArray[indexPath.row];
        }
            break;
        case CHENGJIAO_ZL_TYPE:{
            order = self.chengJiaoArray[indexPath.row];
        }
            break;
        case SHIXIAO_ZL_TYPE:{
            order = self.shiXiaoArray[indexPath.row];
        }
            break;
        case QUXIAO_ZL_TYPE:{
           order = self.quXiaoArray[indexPath.row];
        }
            break;
        case WANCHENG_ZL_TYPE:{
            order = self.wanChengArray[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    self.nostartTabCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nostartTabCell.roleType = DRIVER_ROLETYPE;
    [self.nostartTabCell getInforModel:order];
    return self.nostartTabCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCarModel * order = [[OrderCarModel alloc]init];
    switch (self.current_type) {
        case BAOJIA_ZL_TYPE:{
            order = self.baoJiaArray[indexPath.row];
        }
            break;
        case YAOQING_TYPE:{
            order = self.yaoQingArray[indexPath.row];
        }
            break;
        case CHENGJIAO_ZL_TYPE:{
            order = self.chengJiaoArray[indexPath.row];
        }
            break;
        case SHIXIAO_ZL_TYPE:{
            order = self.shiXiaoArray[indexPath.row];
        }
            break;
        case QUXIAO_ZL_TYPE:{
            order = self.quXiaoArray[indexPath.row];
        }
            break;
        case WANCHENG_ZL_TYPE:{
            order = self.wanChengArray[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    
    if (self.current_type == YAOQING_TYPE) {
        OrderWaitingViewController * wait = [[OrderWaitingViewController alloc]initWithDataModel:order];
        wait.delegate = self;
        [self.navigationController pushViewController:wait animated:YES];
    }else{
        OrderDetailsViewController * orderDetail = [[OrderDetailsViewController alloc]initWithDataModel:order];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}
#pragma mark ===================OrderWaitingViewController 代理方法实现   ==================
- (void)UpDateRequsetWatingVCData{
    NSLog(@"OrderWaitingViewController代理方法实现");
    
}


#pragma mark ===================ZL修改开始==================

- (DZNSegmentedControl *)driverCarOrderSegmented
{
    if (!_driverCarOrderSegmented)
    {
        //_tiGongSubControl = [[DZNSegmentedControl alloc] initWithItems:@[@"已接单",@"已取消",@"已完成"]];
        _driverCarOrderSegmented = [[DZNSegmentedControl alloc] initWithItems:@[@"已报价",@"被邀请",@"已成交",@"已失效",@"已取消",@"已完成"]];
        _driverCarOrderSegmented.tag = 3;
        _driverCarOrderSegmented.delegate = self;
        
        _driverCarOrderSegmented.bouncySelectionIndicator = NO;
        _driverCarOrderSegmented.height = 50.0;
        _driverCarOrderSegmented.width = SIZE_WIDTH;
        _driverCarOrderSegmented.showsGroupingSeparators = NO;
        //                _control.height = 120.0f;
        //                _control.width = 300.0f;
        //                _control.showsGroupingSeparators = YES;
        //                _control.inverseTitles = YES;
        _driverCarOrderSegmented.backgroundColor = [UIColor whiteColor];
        _driverCarOrderSegmented.tintColor = [UIColor colorWithhex16stringToColor:Main_blueColor_ZL];
        _driverCarOrderSegmented.hairlineColor = [UIColor clearColor];
        _driverCarOrderSegmented.showsCount = NO;
        _driverCarOrderSegmented.autoAdjustSelectionIndicatorWidth = NO;
        //                _control.selectionIndicatorHeight = 4.0;
        //                _control.adjustsFontSizeToFitWidth = YES;
        
        [_driverCarOrderSegmented addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _driverCarOrderSegmented;
}
- (void)didChangeSegment:(DZNSegmentedControl *)sender{
    NSLog(@"选择selected.SegmentIndex:%ld",sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.current_type = BAOJIA_ZL_TYPE;
            MyOrderBooL = YES;
            [MyOrdertabView reloadData];
        }
            break;
        case 1:{
            self.current_type = YAOQING_TYPE;
            MyOrderBooL = YES;
            [MyOrdertabView reloadData];
        }
            break;
        case 2:{
            self.current_type = CHENGJIAO_ZL_TYPE;
            MyOrderBooL = YES;
            [MyOrdertabView reloadData];
        }
            break;
        case 3:{
            self.current_type = SHIXIAO_ZL_TYPE;
            MyOrderBooL = NO;
            [MyOrdertabView reloadData];
        }
            break;
        case 4:{
            self.current_type = QUXIAO_ZL_TYPE;
            MyOrderBooL = YES;
            [MyOrdertabView reloadData];
        }
            break;
        case 5:{
            self.current_type = WANCHENG_ZL_TYPE;
            MyOrderBooL = YES;
            [MyOrdertabView reloadData];
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - DZNSegmentedControlDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionAny;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar
{
    return UIBarPositionAny;
}

#pragma mark ===================ZL修改结束==================

- (NSMutableArray *)baoJiaArray{
    if (!_baoJiaArray) {
        _baoJiaArray = [NSMutableArray new];
    }
    return _baoJiaArray;
}
- (NSMutableArray *)shiXiaoArray{
    if (!_shiXiaoArray) {
        _shiXiaoArray = [NSMutableArray new];
    }
    return _shiXiaoArray;
}
- (NSMutableArray *)quXiaoArray{
    if (!_quXiaoArray) {
        _quXiaoArray = [NSMutableArray new];
    }
    return _quXiaoArray;
}
- (NSMutableArray *)chengJiaoArray{
    if (!_chengJiaoArray) {
        _chengJiaoArray = [NSMutableArray new];
    }
    return _chengJiaoArray;
}
- (NSMutableArray *)wanChengArray{
    if (!_wanChengArray) {
        _wanChengArray = [NSMutableArray new];
    }
    return _wanChengArray;
}
- (NSMutableArray *)yaoQingArray{
    if (!_yaoQingArray) {
        _yaoQingArray = [NSMutableArray new];
    }
    return _yaoQingArray;
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
