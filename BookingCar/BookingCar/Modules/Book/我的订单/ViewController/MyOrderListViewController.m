//
//  MyOrderListViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "NoStartOrderTableViewCell.h"//自定义cell
#import "WaitingTripViewController.h"//等待车主接单
#import "OrderDetailsViewController.h"//订单详情

#import "OrderCarModel.h"
@interface MyOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL MyOrderBooL;
    UITableView * MyOrdertabView;
    NSInteger OrderPage;
}
@property (nonatomic, strong)NoStartOrderTableViewCell * nostartTabCell;
@property (nonatomic, strong)OrderCarModel * orderCarModel;
@end

@implementation MyOrderListViewController
-(NoStartOrderTableViewCell*)nostartTabCell
{
    if (nil == _nostartTabCell) {
        _nostartTabCell = [[[NSBundle mainBundle]loadNibNamed:@"NoStartOrderTableViewCell" owner:self options:nil]lastObject];
    }
    return _nostartTabCell;
}
#pragma mark ===================ZL修改开始==================

- (DZNSegmentedControl *)tiGongSubControl
{
    if (!_tiGongSubControl)
    {
        //_tiGongSubControl = [[DZNSegmentedControl alloc] initWithItems:@[@"已接单",@"已取消",@"已完成"]];
        _tiGongSubControl = [[DZNSegmentedControl alloc] initWithItems:@[@"等接单",@"已接单",@"超时单",@"已完成"]];
        _tiGongSubControl.tag = 3;
        _tiGongSubControl.delegate = self;
        
        _tiGongSubControl.bouncySelectionIndicator = NO;
        _tiGongSubControl.height = 50.0;
        _tiGongSubControl.width = SIZE_WIDTH;
        _tiGongSubControl.showsGroupingSeparators = NO;
        //                _control.height = 120.0f;
        //                _control.width = 300.0f;
        //                _control.showsGroupingSeparators = YES;
        //                _control.inverseTitles = YES;
        _tiGongSubControl.backgroundColor = [UIColor whiteColor];
        _tiGongSubControl.tintColor = [UIColor colorWithhex16stringToColor:Main_OrangeColor_ZL];
        _tiGongSubControl.hairlineColor = [UIColor clearColor];
        _tiGongSubControl.showsCount = NO;
        _tiGongSubControl.autoAdjustSelectionIndicatorWidth = NO;
        //                _control.selectionIndicatorHeight = 4.0;
        //                _control.adjustsFontSizeToFitWidth = YES;
        
        [_tiGongSubControl addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _tiGongSubControl;
}
- (void)didChangeSegment:(DZNSegmentedControl *)sender{
    NSLog(@"选择selected.SegmentIndex:%ld",sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.currentOrder_Type = DENGDAN_TYPE;
            MyOrderBooL = YES;
            [MyOrdertabView reloadData];
        }
            break;
        case 1:{
            self.currentOrder_Type = YIJIEDAN_TYPE;
            MyOrderBooL = YES;
             [MyOrdertabView reloadData];
        }
            break;
        case 2:{
            self.currentOrder_Type = CHAOSHI_TYPE;
            MyOrderBooL = YES;
             [MyOrdertabView reloadData];
        }
            break;
        case 3:{
            self.currentOrder_Type = FINISHEDAN_TYPE;
            MyOrderBooL = NO;
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

-(void)requsetMyOrderList
{
    [SVProgressHUD show];

    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:@"10" forKey:@"per_page"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)OrderPage] forKey:@"page"];
    [HttpTool getWithPath:kOrderMyList2 params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];
        [MyOrdertabView.mj_header endRefreshing];
        [MyOrdertabView.mj_footer endRefreshing];
        if (OrderPage == 0) {
            [self.dengDanARR removeAllObjects];
            [self.yiJieDanARR removeAllObjects];
            [self.chaoShiARR removeAllObjects];
            [self.finishedARR removeAllObjects];
        }
        NSLog(@"我的行程返回信息:%@",responseObj);
        if (responseObj[@"data"] == nil || zlObjectIsEmpty(responseObj[@"data"]) ) {
            return;
        }
        for (NSDictionary * dic in responseObj[@"data"]) {
            OrderCarModel * orderCar = [[OrderCarModel alloc]initWithRYDict:dic];
            
            //等接单
            if ([orderCar.status isEqualToString:@"1"]) {
                [self.dengDanARR addObject:orderCar];
            }
            //已接单
            if ([orderCar.status isEqualToString:@"2"] || [orderCar.status isEqualToString:@"3"] || [orderCar.status isEqualToString:@"4"] ||[orderCar.status isEqualToString:@"5"]) {
                [self.yiJieDanARR addObject:orderCar];
            }
            //已超时
            if ([orderCar.status isEqualToString:@"8"]) {
                [self.chaoShiARR addObject:orderCar];
            }
            //已完成
            if ([orderCar.status isEqualToString:@"9"] || [orderCar.status isEqualToString:@"0"]) {
                [self.finishedARR addObject:orderCar];
            }
        }
        [MyOrdertabView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MyOrdertabView.mj_header endRefreshing];
        [MyOrdertabView.mj_footer endRefreshing];
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //加载我的订单数据
    [self requsetMyOrderList];

    //[self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    /** 获取未读消息数量 */
    [self startAFNetWorkingUnReadMessageCount];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    MyOrderBooL = YES;
    self.title = @"行程";
    self.currentOrder_Type = DENGDAN_TYPE;
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(@50.0f);
    }];
    [backView addSubview:self.tiGongSubControl];
    [self CreatTabViewWith:backView];
    //加载我的订单数
//    [self requsetMyOrderList];
    //下拉加载
    [self CreatMJRefresh];
    
    [self CreatNavRightButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAFNetWorkingUnReadMessageCount) name:USER_RECEIVE_MESSAGE_NOTIFICATION object:nil];

}
/** 右侧消息按钮 */
-(void)CreatNavRightButton
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"news1"] forState:UIControlStateNormal];
//    [RightButton.layer setMasksToBounds:YES];
//    [RightButton.layer setCornerRadius:4];
//    [RightButton.layer setBorderWidth:1];
//    RightButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    [RightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self setRedCount];
}
- (void)rightButtonClick:(UIButton *)sender{
    ChatController * Ease = [[ChatController alloc]init];
    Ease.showRefreshHeader = YES;
    Ease.showTableBlankView = YES;
    [self.navigationController pushViewController:Ease animated:YES];
}
/** 设置小红点 */
- (void)setRedCount{
    self.countHub = [[RKNotificationHub alloc]initWithBarButtonItem:self.navigationItem.rightBarButtonItem];
    self.countHub.count = 0;
    [self.countHub hideCount];
    //设置尺寸
    [self.countHub setCircleAtFrame:CGRectMake(0, 0, 10, 10)];
    // 移动气泡的指定位置
    [self.countHub moveCircleByX:20 Y:-5];
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
        [self requsetMyOrderList];

        
        
    }];
    
}


#pragma mark -- TabViewdelegate
-(void)CreatTabViewWith:(UIView *)view{
    MyOrdertabView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    MyOrdertabView.delegate = self;
    MyOrdertabView.dataSource = self;
    [MyOrdertabView setBackgroundColor:kGlobalBg];
    MyOrdertabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view bringSubviewToFront:MyOrdertabView];
    [self.view addSubview:MyOrdertabView];
    [MyOrdertabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(@-49.0);
        make.top.mas_equalTo(view.mas_bottom);
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.currentOrder_Type) {
        case DENGDAN_TYPE:
            return self.dengDanARR.count;
            break;
        case YIJIEDAN_TYPE:
            return self.yiJieDanARR.count;
            break;
        case CHAOSHI_TYPE:
            return self.chaoShiARR.count;
            break;
        case FINISHEDAN_TYPE:
            return self.finishedARR.count;
            break;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identCell = @"OrderListCell";
    self.nostartTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
    if (!self.nostartTabCell) {
        self.nostartTabCell = [[[NSBundle mainBundle]loadNibNamed:@"NoStartOrderTableViewCell" owner:self options:nil]lastObject];
    }
    switch (self.currentOrder_Type) {
        case DENGDAN_TYPE:{
            OrderCarModel * order = self.dengDanARR[indexPath.row];
            [self.nostartTabCell getInforModel:order];
        }
            break;
        case YIJIEDAN_TYPE:{
            OrderCarModel * order = self.yiJieDanARR[indexPath.row];
            [self.nostartTabCell getInforModel:order];
        }
            break;
        case CHAOSHI_TYPE:{
            OrderCarModel * order = self.chaoShiARR[indexPath.row];
            [self.nostartTabCell getInforModel:order];
        }
            break;
        case FINISHEDAN_TYPE:{
            OrderCarModel * order = self.finishedARR[indexPath.row];
            [self.nostartTabCell getInforModel:order];
        }
            break;
        default:
            break;
    }
    
    return self.nostartTabCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderCarModel * orderCar = [[OrderCarModel alloc]init];
    switch (self.currentOrder_Type) {
        case DENGDAN_TYPE:
        {
            orderCar = self.dengDanARR[indexPath.row];
        }
            break;
        case YIJIEDAN_TYPE:
        {
             orderCar = self.yiJieDanARR[indexPath.row];
        }
            break;
        case CHAOSHI_TYPE:
        {
             orderCar = self.chaoShiARR[indexPath.row];
        }
            break;
        case FINISHEDAN_TYPE:
        {
             orderCar = self.finishedARR[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    if ([orderCar.status isEqualToString:@"1"]) {
        double Slat = [orderCar.from_lat doubleValue];
        double Slog = [orderCar.from_lng doubleValue];
        double Flat = [orderCar.to_lat doubleValue];
        double Flog = [orderCar.to_lng doubleValue];
        NSLog(@"出发地点经纬度：%@---%@,终点经纬度：%@----%@",orderCar.from_lat,orderCar.from_lng,orderCar.to_lat,orderCar.to_lng);
        orderCar.CoordinateStart = CLLocationCoordinate2DMake(Slat, Slog);
        orderCar.CoordinateFinish = CLLocationCoordinate2DMake(Flat, Flog);
        WaitingTripViewController * wait = [[WaitingTripViewController alloc]initWithDataModel:orderCar];
        [self.navigationController pushViewController:wait animated:YES];
    }
    else{
        OrderDetailsViewController * orderDetail = [[OrderDetailsViewController alloc]initWithDataModel:orderCar];
        orderDetail.SwitchBool = NO;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

#pragma mark ===================数组初始化==================
- (NSMutableArray *)finishedARR{
    if (!_finishedARR) {
        _finishedARR = [NSMutableArray new];
    }
    return _finishedARR;
}
- (NSMutableArray *)dengDanARR{
    if (!_dengDanARR) {
        _dengDanARR = [NSMutableArray new];
    }
    return _dengDanARR;
}
- (NSMutableArray *)yiJieDanARR{
    if (!_yiJieDanARR) {
        _yiJieDanARR = [NSMutableArray new];
    }
    return _yiJieDanARR;
}
- (NSMutableArray *)chaoShiARR{
    if (!_chaoShiARR) {
        _chaoShiARR = [NSMutableArray new];
    }
    return _chaoShiARR;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
