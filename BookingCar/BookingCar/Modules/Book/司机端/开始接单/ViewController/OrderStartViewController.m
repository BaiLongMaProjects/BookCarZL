//
//  OrderStartViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/25.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OrderStartViewController.h"
#import "OrderStartListTableViewCell.h"
#import "CarOrderListViewController.h"
#import "OrderWaitingViewController.h"
#import "OrderCarModel.h"
#import "UserIDModel.h"//用户名
@interface OrderStartViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BackUpDateWatingVCDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSMutableArray * OrderCarArray;
    NSInteger OrderPage;
}
@property (nonatomic, strong)UITableView * orderCarTabView;
@property (nonatomic, strong)OrderStartListTableViewCell * orderStartListCarTabCell;
@property (nonatomic, strong) CLLocationManager *locationManager;
//经纬度
@property (nonatomic, strong)CLLocation * PointLatLngLocation;
@end

@implementation OrderStartViewController
-(OrderStartListTableViewCell *)orderStartListCarTabCell
{
    if (nil == _orderStartListCarTabCell) {
        _orderStartListCarTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderStartListTableViewCell" owner:self options:nil]lastObject];
    }
    return _orderStartListCarTabCell;
}
-(UITableView *)orderCarTabView
{
    if (nil == _orderCarTabView) {
        _orderCarTabView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderCarTabView.delegate = self;
        _orderCarTabView.dataSource = self;
        _orderCarTabView.backgroundColor = RGBA(245, 245, 245, 1);
        _orderCarTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        /** 设置空白页 */
        _orderCarTabView.emptyDataSetSource = self;
        _orderCarTabView.emptyDataSetDelegate = self;
    }
    return _orderCarTabView;
}

-(void)requsetNearCar{
    [self showLoading];
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:@"30" forKey:@"per_page"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)OrderPage] forKey:@"page"];
    [params setValue:login.token forKey:@"token"];
    [params setValue:[NSString stringWithFormat:@"%f",infor.PointLatLngLocation.coordinate.longitude] forKey:@"lng"];
    [params setValue:[NSString stringWithFormat:@"%f",infor.PointLatLngLocation.coordinate.latitude] forKey:@"lat"];
    NSLog(@"开始接单：%@",params);
    [HttpTool getWithPath:kWaitingList params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        [self dismissLoading];
        for (NSDictionary * dic in responseObj[@"data"]) {
            OrderCarModel * order = [[OrderCarModel alloc]initWithRYDict:dic];
            if (![[dic objectForKey:@"user_id"] isKindOfClass:[NSNull class]]) {
                order.nick_name = [order.user_id objectForKey:@"nick_name"];
                order.gender = [order.user_id objectForKey:@"gender"];
                order.portrait_image = [order.user_id objectForKey:@"portrait_image"];
            }
            [OrderCarArray addObject:order];
        }
        [self.orderCarTabView reloadData];
        //结束刷新
        [self.orderCarTabView.mj_header endRefreshing];
        [self.orderCarTabView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self dismissLoading];
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        //结束刷新
        [self.orderCarTabView.mj_header endRefreshing];
        [self.orderCarTabView.mj_footer endRefreshing];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
    /** 小红点更新 */
    [self startAFNetWorkingUnReadMessageCount];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近订单";
    OrderPage = 0;
    OrderCarArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.orderCarTabView];
    [self.orderCarTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    
    [self CreatNavRightButton];
    //下拉刷新
    [self CreatMJRefresh];
    //开始定位
    [self startLocation];
    //附近的订单
    [self requsetNearCar];
    // Do any additional setup after loading the view from its nib.
    [self CreatNavLeftButton];
    
//    /** 接收到新消息 */
//    __weak typeof(self) weakself = self;
//    [self xw_addNotificationForName:USER_RECEIVE_MESSAGE_NOTIFICATION block:^(NSNotification * _Nonnull notification) {
//        [weakself startAFNetWorkingUnReadMessageCount];
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAFNetWorkingUnReadMessageCount) name:USER_RECEIVE_MESSAGE_NOTIFICATION object:nil];

}
/** 右侧消息按钮 */
-(void)CreatNavLeftButton
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"news2"] forState:UIControlStateNormal];
    //    [RightButton.layer setMasksToBounds:YES];
    //    [RightButton.layer setCornerRadius:4];
    //    [RightButton.layer setBorderWidth:1];
    //    RightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    //    [RightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self setRedCount];
}
- (void)leftButtonClick:(UIButton *)sender{
    ChatController * Ease = [[ChatController alloc]init];
    Ease.showRefreshHeader = YES;
    Ease.showTableBlankView = YES;
    [self.navigationController pushViewController:Ease animated:YES];
}
/** 设置小红点 */
- (void)setRedCount{
    self.countHub = [[RKNotificationHub alloc]initWithBarButtonItem:self.navigationItem.leftBarButtonItem];
    self.countHub.count = 0;
    [self.countHub hideCount];
    //设置尺寸
    [self.countHub setCircleAtFrame:CGRectMake(0, 0, 10, 10)];
    // 移动气泡的指定位置
    [self.countHub moveCircleByX:20 Y:-5];
}

- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 200.0f;
        //[self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"%f,%f",manager.location.coordinate.latitude,manager.location.coordinate.longitude);
    self.PointLatLngLocation = manager.location;
    
}

-(void)CreatNavRightButton
{
    UIButton *RightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [RightButton setTitle:@"我的订单" forState:UIControlStateNormal];
    //[RightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[RightButton setTintColor:[UIColor whiteColor]];
    [RightButton.layer setMasksToBounds:YES];
    [RightButton.layer setCornerRadius:4];
    [RightButton.layer setBorderWidth:1];
    [RightButton.layer setBorderColor: [UIColor whiteColor].CGColor];
    RightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [RightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [RightButton addTarget:self action:@selector(RightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
}
#pragma mark- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return OrderCarArray.count;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identCell = @"OrderStartCarCellID";
    self.orderStartListCarTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
    if (!self.orderStartListCarTabCell) {
        self.orderStartListCarTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderStartListTableViewCell" owner:self options:nil]lastObject];
    }
    if (OrderCarArray.count > 0) {
        OrderCarModel * orderCarModel = OrderCarArray[indexPath.row];
        [self.orderStartListCarTabCell getInfoOrderCarModel:orderCarModel];
    }
    self.orderStartListCarTabCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.orderStartListCarTabCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderCarModel * order = [[OrderCarModel alloc]init];
    order = OrderCarArray[indexPath.row];
    OrderWaitingViewController * wait = [[OrderWaitingViewController alloc]initWithDataModel:order];
    wait.delegate = self;
    [self.navigationController pushViewController:wait animated:YES];
}
-(void)RightButtonClick:(UIButton *)sender
{
    CarOrderListViewController * order = [[CarOrderListViewController alloc]init];
    [self.navigationController pushViewController:order animated:YES];
}
#pragma mark -- 下拉刷新
-(void)CreatMJRefresh{
    self.orderCarTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        OrderPage = 0;
        [OrderCarArray removeAllObjects];
        [self requsetNearCar];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.orderCarTabView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.orderCarTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        OrderPage ++;
        
        if (OrderPage >= 0) {
                [self requsetNearCar];
        }
        
    }];
    
}

#pragma mark -- delegate
-(void)UpDateRequsetWatingVCData
{
    OrderCarArray = [[NSMutableArray alloc]init];
    [self requsetNearCar];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ===================请求未读消息个数==================
- (void)startAFNetWorkingUnReadMessageCount{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    int weiDuCount = 0;
    for ( EMConversation * conversation in conversations) {
        weiDuCount = weiDuCount + [conversation unreadMessagesCount];
    }
    NSLog(@"未读消息数：%d",weiDuCount);
    if (weiDuCount > 0) {
        self.countHub.count = weiDuCount;
    }else{
        self.countHub.count = 0;
    }
}
#pragma mark ===================请求未读消息个数 结束==================

#pragma mark - DZNEmptyDataSetSource 空白页设置方法
// 返回图片
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
//    return [UIImage imageNamed:@"kongBai"];
//}
// 返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"空空如也";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:21.0f],NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}
// 返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"点击刷新";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}
// 返回可以点击的按钮 上面带文字
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
//    return [[NSAttributedString alloc] initWithString:@"哈喽" attributes:attribute];
//}

//#pragma mark - DZNEmptyDataSetDelegate
// 处理按钮的点击事件
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.baidu.com"]];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
//}
//// 标题文字与详情文字的距离
//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
//    return 100;
//}
//// 返回空白区域的颜色自定义
//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIColor cyanColor];
//}
//// 标题文字与详情文字同时调整垂直偏移量
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -100;
//}
// 空白区域点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.orderCarTabView.mj_header beginRefreshing];
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
