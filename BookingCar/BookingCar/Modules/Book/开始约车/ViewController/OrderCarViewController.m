//
//  OrderCarViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/14.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OrderCarViewController.h"
#import "OrderCarTableViewCell.h"
#import "WaitingTripViewController.h"//查看详情
@interface OrderCarViewController ()<UITableViewDelegate,UITableViewDataSource,BackUpDateOrderCarVCDelegate>
{
    NSMutableArray * orderMyListArray;
    NSInteger OrderPage;
}
/**
 *  地图显示
 */
@property (nonatomic, strong)OrderCarModel * orderModel;
@property (nonatomic, strong)UITableView * orderCarTabView;
@property (nonatomic, strong)OrderCarTableViewCell * orderCarTabCell;
@end
@implementation OrderCarViewController
-(instancetype)initWithDataModel:(OrderCarModel *)orderModel
{
    if (self=[super init]) {
        _orderModel=[[OrderCarModel alloc]init];
        _orderModel=orderModel;
    }
    return self;
}
-(OrderCarTableViewCell*)orderCarTabCell
{
    if (nil == _orderCarTabCell) {
        _orderCarTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderCarTableViewCell" owner:self options:nil]lastObject];
    }
    return _orderCarTabCell;
}

-(void)RequsetOrderMyList{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%f",self.orderModel.CoordinateStart.latitude] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%f",self.orderModel.CoordinateStart.longitude] forKey:@"lng"];
    [params setObject:login.token forKey:@"token"];
    [params setObject:@"10" forKey:@"per_page"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)OrderPage] forKey:@"page"];

    [HttpTool getWithPath:kWaitingList params:params success:^(id responseObj) {
        //结束刷新
        [self.orderCarTabView.mj_header endRefreshing];
        [self.orderCarTabView.mj_footer endRefreshing];
    NSLog(@"%@",responseObj);
        for (NSDictionary * dic in responseObj[@"data"]) {
            OrderCarModel * order = [[OrderCarModel alloc]initWithRYDict:dic];
            order.nick_name = [order.user_id objectForKey:@"nick_name"];
            order.portrait_image = [order.user_id objectForKey:@"portrait_image"];
            [orderMyListArray addObject:order];
        }
        
        [self.orderCarTabView reloadData];
        
    [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"]customView:nil hideDelay:2.f];
        
    } failure:^(NSError *error) {
    [SVProgressHUD dismiss];
    [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        //结束刷新
        [self.orderCarTabView.mj_header endRefreshing];
        [self.orderCarTabView.mj_footer endRefreshing];

    }];

}
//下拉刷新
#pragma mark -- 下拉刷新
-(void)CreatMJRefresh{
    self.orderCarTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        OrderPage = 0;
        orderMyListArray = [[NSMutableArray alloc]init];
            [self RequsetOrderMyList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.orderCarTabView.mj_header.automaticallyChangeAlpha = YES;
   
    // 上拉刷新
    self.orderCarTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        OrderPage ++;
        [self RequsetOrderMyList];

    }];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self RequsetOrderMyList];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"等待车主接单";

    orderMyListArray = [[NSMutableArray alloc]init];
    self.orderCarTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    self.orderCarTabView.delegate = self;
    self.orderCarTabView.dataSource = self;
    [self CreatMJRefresh];
    [self.view addSubview:self.orderCarTabView];
}
#pragma mark- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.orderCarTabCell.frame.size.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderMyListArray.count;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identCell = @"OrderCarCellid";
    self.orderCarTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
    if (!self.orderCarTabCell) {
        self.orderCarTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderCarTableViewCell" owner:self options:nil]lastObject];
    }

    if (orderMyListArray.count > 0) {
        OrderCarModel * orderCarModel = orderMyListArray[indexPath.row];
        [self.orderCarTabCell getInfoOrderCarModel:orderCarModel];
    }
//    去线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    return self.orderCarTabCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCarModel * orderCarModel = orderMyListArray[indexPath.row];
    double Slat = [orderCarModel.from_lat doubleValue];
    double Slog = [orderCarModel.from_lng doubleValue];
    double Flat = [orderCarModel.to_lat doubleValue];
    double Flog = [orderCarModel.to_lng doubleValue];
    orderCarModel.CoordinateStart = CLLocationCoordinate2DMake(Slat, Slog);
    orderCarModel.CoordinateFinish = CLLocationCoordinate2DMake(Flat, Flog);

    WaitingTripViewController * watiting = [[WaitingTripViewController alloc]initWithDataModel:orderCarModel];
    watiting.backUpDatedelegate = self;
    [self.navigationController pushViewController:watiting animated:YES];
}


#pragma mark --- 返回的代理
-(void)UpDateRequsetOrderCarVCData
{
    [self RequsetOrderMyList];
    orderMyListArray = [[NSMutableArray alloc]init];
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
