//
//  BookController.m
//  BookingCar
//
//  Created by LiXiaoJing on 29/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#import "BookController.h"
#import "BHInfiniteScrollView.h"
#import "PageHomeHeadView.h"
#import "HomePageTableViewCell.h"
#import "SureCancelPicekToView.h"

#import "ZHMapAroundInfoViewController.h"//开始
#import "HomeFinshingViewController.h"//终点
#import "OrderCarViewController.h"//开始约车
#import "ZHRootTableViewController.h"

#import "OrderCarModel.h"//储存约车数据
#import "MyOrderListViewController.h"//我的订单
#import "ChooseView.h"//附近的人（车）
#import "OrderStatus.h"//首页的行程记录

#import "NearDetailModel.h"//附近的车详情

#import "OtherOshowViewController.h"//别人的动态
#pragma ----司机端页面
#import "OrderStartViewController.h"//开始接单

#import "MyOrderListViewController.h"//订单列表

#import "CarOrderListViewController.h"//司机订单

@interface BookController ()<UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,BackUpDateBookingDelegate,BackFinishUpDateBookingDelegate,CLLocationManagerDelegate>
{
    InforModel * inforMo;
    NSMutableArray * VistorArray;
    NSMutableArray * DriverArray;
    CLLocationCoordinate2D StartCoordinate;
    CLLocationCoordinate2D FinishCoordinate;
    /** 判断当前是附近的车还是人 YES为附近的人，NO为附近的车 */
    BOOL NearCarOrPeoson;
    BOOL LoctionBooL;
    NSString *RoleName;//我的角色
    NSInteger _currentPage;
    
    
}
@property (nonatomic, strong) BHInfiniteScrollView* infinitePageView;
@property (nonatomic, strong) PageHomeHeadView * pageHomeView;
@property (nonatomic, strong) UITableView * HomePageTabView;
@property (nonatomic, strong) HomePageTableViewCell * homePageTabCell;
@property (nonatomic, strong) SureCancelPicekToView * sureCancelPick;
@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) ChooseView * chooseView;
@property (nonatomic, strong) FMDatabase * db;

@property (nonatomic, strong) CLLocationManager *locationManager;
//经纬度
@property (nonatomic, strong)CLLocation * BasePointLatLngLocation;
//CommonMenuView下拉列表
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) int itemCount;
@end

@implementation BookController


- (void)viewDidLoad {
    [super viewDidLoad];
    /** 请求用户详细信息 */
    [self requsetPersondetail];
    _currentPage = 0;
    /** 新版本 检测 */
    [[ZLFisrViewModel shareInstance] isHaveNewVersionsWithBlock:^(BOOL isHave, NSString *message) {
        if (isHave == YES) {
            [JHSysAlertUtil presentAlertViewWithTitle:@"有新版本可以升级啦" message:message cancelTitle:@"取消" defaultTitle:@"升级" distinct:YES cancel:^{
                
            } confirm:^{
                /** 打开APPStore */
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOAD_APP_URL]];
            }];
        }
    }];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    //取出数据 但是数据格式尽量要对应 大部分是可以使用ObjectForKey的
    RoleName=[[NSUserDefaults standardUserDefaults] objectForKey:ROLE_TYPE_ZL];
    //    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    [self CreatHomePageView];
    [self CreatNavRightButton];
    //判断附近的车（人）
    NearCarOrPeoson = NO;
    self.chooseView.ButCar.selected = YES;
    self.chooseView.ButPeoson.selected = NO;
    //判断是否定位
    LoctionBooL = YES;
    
    [self.view addSubview:self.HomePageTabView];
    [self.view addSubview:self.sureCancelPick];
    //选择角色
    [self SwitchRoleDrive];
    //下拉刷新
    [self CreatMJRefresh];
    //[self showText:@"测试"];
    //创建定位
    [self createCLLocation];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //开始定位
    [self startLocation];
}

//清空表单数据
- (void)clearTextFieldText{
    self.pageHomeView.ButStart.titleLabel.text = @"起始地点";
    self.pageHomeView.ButFinish.titleLabel.text = @"目标终点";
    self.pageHomeView.ButGoTime.titleLabel.text = @"出发时间";
    self.pageHomeView.TextfieldMoney.text = @"";
}

-(PageHomeHeadView *)pageHomeView
{
    if (nil == _pageHomeView) {
        _pageHomeView = [[[NSBundle mainBundle]loadNibNamed:@"PageHomeHeadView" owner:self options:nil]lastObject];
        [_pageHomeView setFrame:CGRectMake(0, 0, KScreenWidth, 570)];
        [_pageHomeView.ButGoTime addTarget:self action:@selector(ButGoTimeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_pageHomeView.ButStart addTarget:self action:@selector(ButStartClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pageHomeView.ButFinish addTarget:self action:@selector(ButFinishClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pageHomeView.ButImageStart addTarget:self action:@selector(ButImageStartClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pageHomeView.ButImageFinish addTarget:self action:@selector(ButImageFinishClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_pageHomeView.ButExchange addTarget:self action:@selector(ButExchangeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pageHomeView.ButStartCar addTarget:self action:@selector(ButStartCarClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.pageHomeView.VePeoCar setFrame:CGRectMake(73, 440*D_height, 60*D_width, 140*D_height)];
        [self.pageHomeView.VePeoSwag setFrame:CGRectMake(208, 440*D_height, 60*D_width, 140*D_height)];
//        [self.view bringSubviewToFront:self.pageHomeView.VePeoCar];
//        [self.view bringSubviewToFront:self.pageHomeView.VePeoSwag];
        }
    return _pageHomeView;
}

//下拉刷新
#pragma mark -- 下拉刷新
-(void)CreatMJRefresh{
    self.HomePageTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //开始定位
        [self startLocation];
        
//        LoctionBooL = YES;
//        if (NearCarOrPeoson == YES) {
//            //附近的人
//            [self requsetNearUsers];
//        }else
//        {
//            //附近的车
//            [self requsetNearDrivers];
//        }
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.HomePageTabView.mj_header.automaticallyChangeAlpha = YES;
}

-(UITableView *)HomePageTabView
{
    if (nil == _HomePageTabView) {
        _HomePageTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
        _HomePageTabView.delegate = self;
        _HomePageTabView.dataSource = self;
        _HomePageTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_HomePageTabView setTableHeaderView:self.pageHomeView];
    }
    return _HomePageTabView;
}

-(HomePageTableViewCell *)homePageTabCell
{
    if (nil == _homePageTabCell) {
        _homePageTabCell = [[[NSBundle mainBundle]loadNibNamed:@"HomePageTableViewCell" owner:self options:nil]lastObject];
    }
    return _homePageTabCell;
}

-(SureCancelPicekToView * )sureCancelPick
{
    if (nil == _sureCancelPick) {
        _sureCancelPick = [[[NSBundle mainBundle]loadNibNamed:@"SureCancelPicekToView" owner:self options:nil]lastObject];
        [_sureCancelPick.ButSure addTarget:self action:@selector(ButSureClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sureCancelPick.ButCancel addTarget:self action:@selector(ButCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _sureCancelPick.frame = CGRectMake(0, KScreenHeight, KScreenWidth, self.sureCancelPick.frame.size.height);
        
        self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.sureCancelPick.ButSure.frame.size.height, KScreenWidth, 200-44)];

        self.datePicker.minimumDate= [NSDate dateWithTimeInterval:15*60 sinceDate:[NSDate date]];//七天前的那天
        
        [self.sureCancelPick addSubview:self.datePicker];
    }
    return _sureCancelPick;
}

-(ChooseView *)chooseView
{
    if (nil == _chooseView) {
        _chooseView = [[[NSBundle mainBundle]loadNibNamed:@"ChooseView" owner:self options:nil]lastObject];
        [_chooseView.ButCar addTarget:self action:@selector(ButCarClick:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseView.ButPeoson addTarget:self action:@selector(ButPeosonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseView;
}
#pragma mark --- 切换到司机
-(void)SwitchRoleDrive
{
    NSLog(@"我的角色 ==== %@",RoleName);
    
    if ([RoleName isEqualToString:@"1"]) {
        NSLog(@"我的角色 ==== 司机");
        self.pageHomeView.ViewCarHidden.hidden = YES;
        self.pageHomeView.frame = CGRectMake(0, 0, KScreenWidth, 100);
        //[self requsetHomeDriverUrl];
    }else
    {
       // [self requsetHomeVisitorUrl];
    }
}

-(void)CreatNavRightButton
{
    UIButton *RightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    if ([RoleName isEqualToString:@"1"]) {
        [RightButton setTitle:@"开始接单" forState:UIControlStateNormal];
    }else
    {
        [RightButton setTitle:@"我的行程" forState:UIControlStateNormal];
    }
    [RightButton.layer setMasksToBounds:YES];
    [RightButton.layer setCornerRadius:4];
    [RightButton.layer setBorderWidth:1];
    RightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [RightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [RightButton addTarget:self action:@selector(RightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
}
-(void)RightButtonClick:(UIButton * )sender
{
    if ([RoleName isEqualToString:@"0"]) {

    MyOrderListViewController * myOrderList = [[MyOrderListViewController alloc]init];
    
    [self.navigationController pushViewController:myOrderList animated:YES];
    }
    else
    {
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        OrderStartViewController * orderStart = [[OrderStartViewController alloc]init];
        orderStart.orderLocation = infor.PointLatLngLocation;
        [self.navigationController pushViewController:orderStart animated:YES];
    }
}

-(void)CreatHomePageView{
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    NSArray* urlsArray = @[
                           @"http://osjnbo9xy.bkt.clouddn.com/banner1.png",
                           @"http://osjnbo9xy.bkt.clouddn.com/banner2.png",
                           @"http://osjnbo9xy.bkt.clouddn.com/banner3.png",
                           @"http://osjnbo9xy.bkt.clouddn.com/banner4.png"
                           ];
    
    NSArray* titlesArray = @[@"欢迎使用BHInfiniteScrollView无限轮播图",
                             @"如果你在使用过程中遇到什么疑问",
                             @"可以添加QQ群：206177395",
                             @"我会及时修复bug"
                             ];
    
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height/4;
    
    BHInfiniteScrollView* infinitePageView1 = [BHInfiniteScrollView
                                               infiniteScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100) Delegate:self ImagesArray:urlsArray];
    infinitePageView1.titlesArray = titlesArray;
    infinitePageView1.dotSize = 6;
    infinitePageView1.pageControlAlignmentOffset = CGSizeMake(40, 5);
    infinitePageView1.titleView.textColor = [UIColor whiteColor];
    infinitePageView1.titleView.margin = 30;
    infinitePageView1.titleView.hidden = YES;
    infinitePageView1.scrollTimeInterval = 3;
    infinitePageView1.autoScrollToNextPage = YES;
    infinitePageView1.delegate = self;
    infinitePageView1.scrollDirection = BHInfiniteScrollViewScrollDirectionHorizontal;
    infinitePageView1.pageControlAlignmentH = BHInfiniteScrollViewPageControlAlignHorizontalRight;
    infinitePageView1.pageControlAlignmentV = BHInfiniteScrollViewPageControlAlignVerticalButtom;
    [self.pageHomeView addSubview:infinitePageView1];
    
    [self.pageHomeView sendSubviewToBack:infinitePageView1];
    [self performSelector:@selector(stop) withObject:nil afterDelay:5];
    [self performSelector:@selector(start) withObject:nil afterDelay:10];
}

#pragma mark- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"D_height=%f",D_height);
    return 250*D_height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (NearCarOrPeoson == YES) {
        return VistorArray.count;
    }else
    {
        return DriverArray.count;
    }
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identCell = @"HomePageCell";
    self.homePageTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
    if (!self.homePageTabCell) {
        self.homePageTabCell = [[[NSBundle mainBundle]loadNibNamed:@"HomePageTableViewCell" owner:self options:nil]lastObject];
    }
    
    if (NearCarOrPeoson == NO) {
        //NO 为 附近的车
        NearDetailModel * near = [[NearDetailModel alloc]init];
        near = DriverArray[indexPath.row];
        [self.homePageTabCell getInfo:near];
    }
    else
    {
        //YES为 附近的人
        NearDetailModel * near = [[NearDetailModel alloc]init];
        near = VistorArray[indexPath.row];
        [self.homePageTabCell getInfo:near];
    }
    
    //去线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return self.homePageTabCell;
}
#pragma cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
#pragma mark - section内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return self.chooseView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击时去灰的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"点击跳转");
    if (NearCarOrPeoson == NO) {
        NearDetailModel * near = [[NearDetailModel alloc]init];
        near = DriverArray[indexPath.row];
        OtherOshowViewController * otherOshow = [[OtherOshowViewController alloc]initWithDataModel:near];
        [self.navigationController pushViewController:otherOshow animated:YES];
    }
    else
    {
        NearDetailModel * near = [[NearDetailModel alloc]init];
        near = VistorArray[indexPath.row];
        OtherOshowViewController * otherOshow = [[OtherOshowViewController alloc]initWithDataModel:near];
        [self.navigationController pushViewController:otherOshow animated:YES];

    }
}

-(void)ButSureClick:(UIButton *)sender
{
    NSLog(@"确定");
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateStr = [dateformatter stringFromDate:self.datePicker.date];
    
    NSLog(@"date====:%@",dateStr);

    [self.pageHomeView.ButGoTime setTitle:dateStr forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.sureCancelPick.frame;
        frame.origin.y = KScreenHeight;//停留的高度
        self.sureCancelPick.frame = frame;
    }];

}

-(void)ButCancelClick:(UIButton *)sender
{
    NSLog(@"取消");
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.sureCancelPick.frame;
        frame.origin.y = KScreenHeight;//停留的高度
        self.sureCancelPick.frame = frame;
    }];
}

-(void)ButGoTimeClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.sureCancelPick.frame;
        frame.origin.y = KScreenHeight-self.sureCancelPick.frame.size.height-64-54;//停留的高度
        self.sureCancelPick.frame = frame;
    }];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.HomePageTabView addGestureRecognizer:tapGestureRecognizer];
}

-(void)ButStartClick:(UIButton *)sender
{
    ZHMapAroundInfoViewController * homeStart = [[ZHMapAroundInfoViewController alloc]init];
    homeStart.backBookingDelegate = self;
    [self.navigationController pushViewController:homeStart animated:YES];
}



-(void)ButFinishClick:(UIButton *)sender
{
    HomeFinshingViewController * finish = [[HomeFinshingViewController alloc]init];
    finish.backfinishBookingDelegate = self;
    [self.navigationController pushViewController:finish animated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.sureCancelPick.frame;
        frame.origin.y = KScreenHeight;//停留的高度
        self.sureCancelPick.frame = frame;
    }];
}
- (void)stop {
    [_infinitePageView stopAutoScrollPage];
}

- (void)start {
    [_infinitePageView startAutoScrollPage];
}
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index {
//    NSLog(@"did scroll to index %ld", index);
}
#pragma mark -- 按钮点击事件

-(void)ButImageStartClick:(UIButton *)sender
{
    ZHMapAroundInfoViewController * homeStart = [[ZHMapAroundInfoViewController alloc]init];
    homeStart.backBookingDelegate = self;
    [self.navigationController pushViewController:homeStart animated:YES];
}

-(void)ButImageFinishClick:(UIButton *)sender
{
    HomeFinshingViewController * finish = [[HomeFinshingViewController alloc]init];
    finish.backfinishBookingDelegate = self;
    [self.navigationController pushViewController:finish animated:YES];
}

//交换
-(void)ButExchangeClick:(UIButton *)sender
{
    NSString * str = self.pageHomeView.ButStart.titleLabel.text;
    [self.pageHomeView.ButStart setTitle:self.pageHomeView.ButFinish.titleLabel.text forState:UIControlStateNormal];
    [self.pageHomeView.ButFinish setTitle:str forState:UIControlStateNormal];
}
//开始约车
-(void)ButStartCarClick:(UIButton *)sender
{
    if ([self.pageHomeView.ButStart.titleLabel.text isEqualToString:@"起始地点"]||[self.pageHomeView.ButStart.titleLabel.text isEqualToString:@"目标终点"]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的起始地点" customView:nil hideDelay:2.f];
        return;
    }
    if ([self.pageHomeView.ButFinish.titleLabel.text isEqualToString:@"目标终点"]||[self.pageHomeView.ButFinish.titleLabel.text isEqualToString:@"起始地点"]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的目标终点" customView:nil hideDelay:2.f];
        return;
    }
    if ([self.pageHomeView.ButGoTime.titleLabel.text isEqualToString:@"预约时间"]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的预约时间" customView:nil hideDelay:2.f];
        return;
    }
    if ([self.pageHomeView.TextfieldMoney.text isEqualToString:@""]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的期望金额" customView:nil hideDelay:2.f];
        return;
    }
//    if ([self.pageHomeView.ButPeoCar.titleLabel.text isEqualToString:@"0"]) {
//        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的乘车人数" customView:nil hideDelay:2.f];
//        return;
//    }

    //提交
    [self RequsetOrderNew];
}
-(void)ButCarClick:(UIButton *)sender
{
    if (NearCarOrPeoson == YES) {
        self.chooseView.ButPeoson.selected = NO;
        self.chooseView.ButCar.selected = YES;
        NearCarOrPeoson = NO;
        //附近的车
        [self requsetNearDrivers];
    }
    NSLog(@"附近的车");
}
-(void)ButPeosonClick:(UIButton *)sender
{
    if (NearCarOrPeoson == NO) {
        self.chooseView.ButPeoson.selected = YES;
        self.chooseView.ButCar.selected = NO;
        NearCarOrPeoson = YES;
        //附近的乘客
        [self requsetNearUsers];
    }
    NSLog(@"附近的人");
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"did select item at index %ld", index);
}

#pragma mark -- 返回的数据
-(void)UpDateRequsetfinishBooking:(CLLocationCoordinate2D)collaction StartName:(NSString *)name
{
    FinishCoordinate = collaction;
    [self.pageHomeView.ButFinish setTitle:name forState:UIControlStateNormal];
    if (FinishCoordinate.latitude > 0 && StartCoordinate.latitude > 0) {
        CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:StartCoordinate.latitude longitude:StartCoordinate.longitude];
        
        CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:FinishCoordinate.latitude longitude:FinishCoordinate.longitude];
        
        double  distance  = [curLocation distanceFromLocation:otherLocation];
        
        NSLog(@"distance == %f",distance);
        
        self.pageHomeView.LabOfferMoney.text = [NSString stringWithFormat:@"%.2f$",distance * 0.001];
    }
}
-(void)UpDateRequsetBooking:(CLLocationCoordinate2D)collaction StartName:(NSString *)name
{
    NSLog(@"collaction ==== %f, StartName ==== %@",collaction.latitude,name);
    [self.pageHomeView.ButStart setTitle:name forState:UIControlStateNormal];
    StartCoordinate = collaction;
    
    if (FinishCoordinate.latitude > 0 && StartCoordinate.latitude > 0) {
        CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:StartCoordinate.latitude longitude:StartCoordinate.longitude];
        
        CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:FinishCoordinate.latitude longitude:FinishCoordinate.longitude];
        
        double  distance  = [curLocation distanceFromLocation:otherLocation];
        
        NSLog(@"distance == %f",distance);
        self.pageHomeView.LabOfferMoney.text = [NSString stringWithFormat:@"%.2f$",distance * 0.001];
    }
}

#pragma mark ===================网络请求 开始==================
#pragma mark -- 约车接口
//开始约车接口
-(void)RequsetOrderNew{
    //[SVProgressHUD show];
    [self showLoading];
    NSString *str2=self.pageHomeView.ButGoTime.titleLabel.text;
    NSArray *temp=[str2 componentsSeparatedByString:@" "];
    NSString *date = [temp objectAtIndex:0];
    NSString *time = [temp objectAtIndex:1];
    
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    
    [params setObject:login.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%f",StartCoordinate.latitude] forKey:@"from_lat"];
    [params setObject:[NSString stringWithFormat:@"%f",StartCoordinate.longitude] forKey:@"from_lng"];
    [params setObject:self.pageHomeView.ButStart.titleLabel.text forKey:@"from_location"];
    [params setObject:[NSString stringWithFormat:@"%f",FinishCoordinate.latitude] forKey:@"to_lat"];
    [params setObject:[NSString stringWithFormat:@"%f",FinishCoordinate.longitude] forKey:@"to_lng"];
    [params setObject:self.pageHomeView.ButFinish.titleLabel.text forKey:@"to_location"];
    [params setObject:date forKey:@"trip_date"];
    [params setObject:time forKey:@"trip_time"];
    [params setObject:self.pageHomeView.TextfieldMoney.text forKey:@"expect_price"];
    [params setObject:self.pageHomeView.personNumButton.currentNumber forKey:@"trip_person"];
    [params setObject:self.pageHomeView.xingLiButton.currentNumber forKey:@"trip_luggage"];
    NSLog(@"当前行李数和人数:%@----%@",self.pageHomeView.xingLiButton.currentNumber,self.pageHomeView.personNumButton.currentNumber);
    [HttpTool postWithPath:kOrderNewUrl params:params success:^(id responseObj) {
        [self dismissLoading];
        NSLog(@"%@",responseObj);
        if ([responseObj[@"status"] intValue] == 1) {
            NSString *str2=self.pageHomeView.ButGoTime.titleLabel.text;
            NSArray *temp=[str2 componentsSeparatedByString:@" "];
            NSString *date = [temp objectAtIndex:0];
            NSString *time = [temp objectAtIndex:1];
            OrderCarModel * orderCarModel = [[OrderCarModel alloc]init];
            orderCarModel.CoordinateStart = StartCoordinate;
            orderCarModel.CoordinateFinish = FinishCoordinate;
            orderCarModel.from_location = self.pageHomeView.ButStart.titleLabel.text;
            orderCarModel.to_location = self.pageHomeView.ButFinish.titleLabel.text;
            orderCarModel.trip_date = date;
            orderCarModel.trip_time = time;
            orderCarModel.expect_price = self.pageHomeView.TextfieldMoney.text;
            orderCarModel.trip_person = self.pageHomeView.ButPeoCar.titleLabel.text;
            orderCarModel.trip_luggage = self.pageHomeView.ButSwag.titleLabel.text;
            [self.HomePageTabView reloadData];
            [weak_self(self) clearTextFieldText];
        }
        
        //        OrderCarViewController * order = [[OrderCarViewController alloc]initWithDataModel:orderCarModel];
        //        [self.navigationController pushViewController:order animated:YES];
        
        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        //[SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [self dismissLoading];
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}

//附近的车
-(void)requsetNearDrivers
{
    
    //[SVProgressHUD showWithStatus:@"玩命加载中"];
    [self showLoading];
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%f",infor.PointLatLngLocation.coordinate.latitude] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%f",infor.PointLatLngLocation.coordinate.longitude] forKey:@"lng"];
    NSLog(@"附近的车的我的经纬度：%f-----%f",infor.PointLatLngLocation.coordinate.latitude,infor.PointLatLngLocation.coordinate.latitude);
    [params setObject:@"0" forKey:@"page"];
    [params setObject:@"40" forKey:@"per_page"];
    [params setObject:@"3" forKey:@"mark"];
    NSLog(@"附近的车的Params:%@",params);
    [HttpTool getWithPath:kSignNearDriver params:params success:^(id responseObj) {
        NSLog(@"附近的车 ==== %@",responseObj);
        //结束刷新
        [self.HomePageTabView.mj_header endRefreshing];
        //[SVProgressHUD dismiss];
        [self dismissLoading];
        if ([responseObj[@"status"] intValue] == 1) {
            DriverArray = [NSMutableArray new];
            for (NSDictionary * dic in responseObj[@"data"]) {
                NearDetailModel * nearDetail = [[NearDetailModel alloc]initWithRYDict:dic];
                [DriverArray addObject:nearDetail];
            }
            [self.HomePageTabView reloadData];
        }
        //[SVProgressHUD setInfoImage:[UIImage imageWithGIFNamed:@"loading.gif"]];
        //[self showImage:[UIImage imageWithGIFNamed:@"loading.gif"] text:@"ddd"];
         //[SVProgressHUD showInfoWithStatus:@"加载中..."];
    } failure:^(NSError *error) {
        NSLog(@"附近的车：错误：%@",error);
        //结束刷新
        [self.HomePageTabView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
    
}
//附近的人
-(void)requsetNearUsers
{
    //[SVProgressHUD showWithStatus:@"玩命加载中"];
    [self showLoading];
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%f",infor.PointLatLngLocation.coordinate.latitude] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%f",infor.PointLatLngLocation.coordinate.longitude] forKey:@"lng"];
    NSLog(@"附近的---人----的我的经纬度：%f-----%f",infor.PointLatLngLocation.coordinate.latitude,infor.PointLatLngLocation.coordinate.latitude);
    [params setObject:@"0" forKey:@"page"];
    [params setObject:@"30" forKey:@"per_page"];
    [params setObject:@"3" forKey:@"mark"];
    NSLog(@"附近的人的Params:%@",params);
    [HttpTool getWithPath:kSignNearUser params:params success:^(id responseObj) {
        NSLog(@"附近的乘客：%@",responseObj);
        //结束刷新
        [self.HomePageTabView.mj_header endRefreshing];
        //[SVProgressHUD dismiss];
        [self dismissLoading];
        if ([responseObj[@"status"] intValue] == 1) {
            VistorArray  = [NSMutableArray new];
            
            for (NSDictionary * dic in responseObj[@"data"]){
                NearDetailModel * nearDetail = [[NearDetailModel alloc]initWithRYDict:dic];
                [VistorArray addObject:nearDetail];
            }
            [self.HomePageTabView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"附近的人错误：%@",error);
        //结束刷新
        [self.HomePageTabView.mj_header endRefreshing];
        //[SVProgressHUD dismiss];
        [self dismissLoading];
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
#pragma mark ===================网络请求结束==================
#pragma mark ===================关于定位的代理犯法 开始==================
//开始定位
- (void)createCLLocation{
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = GAODE_APP_KEY;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    //控制定位精度,越高耗电量越
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    // 总是授权
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = 200.0f;//200米
    //[self.locationManager startUpdatingLocation];
}
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        /*
        if ([self.locationManager respondsToSelector:@selector(startUpdatingLocation)]) {
             [self.locationManager startUpdatingLocation];
        }
        else if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
             [self.locationManager requestWhenInUseAuthorization];
        }else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
             [self.locationManager requestAlwaysAuthorization];
        }
         */
    }
}
#pragma mark ===================定位代理方法==================
//2.在代理方法中获取位置信息
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还没选择***");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"受限制***");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"用户拒绝或者定位服务没开***");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"iOS8以上 任何时候***");
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"iOS8以上 在使用应用期间***");
            [self.locationManager startUpdatingLocation];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位错误error %@", error);
    [self.locationManager stopUpdatingLocation];
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
        [self loadAlertActionController];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
/** 跳转到设置页面 */
- (void)loadAlertActionController{
    //UIAlertActionStyleDestructive
    
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weak_self(self) toSettingView];
    }];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"请打开定位" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:alertAction1];
    [alertVC addAction:alertAction2];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)toSettingView{
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //ios < 10.0
    if(kDeviceVersion < 10.0){
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }else{
        //ios >= 10.0
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL  success) {
                
            }];
        }
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSTimeInterval locationAge = -[[(CLLocation *)[locations lastObject] timestamp] timeIntervalSinceNow];
    NSLog(@"多久调用定位代理方法how old the location is: %.5f", locationAge);
    if (locationAge > 1.0){
        //如果调用已经一次，不再执行
        return;
    }else{
        //NSLog(@"%f,%f",manager.location.coordinate.latitude,manager.location.coordinate.longitude);
        self.BasePointLatLngLocation = manager.location;
        InforModel * IninforMo = [[InforModel alloc]init];
        IninforMo = [LoginDataModel sharedManager].inforModel;
        IninforMo.PointLatLngLocation = self.BasePointLatLngLocation;
        [[LoginDataModel sharedManager] saveLoginMemberData:IninforMo];
        NSLog(@"定位代理经纬度回调--我的经纬度：%f-----%f",IninforMo.PointLatLngLocation.coordinate.latitude,IninforMo.PointLatLngLocation.coordinate.latitude);
        NSLog(@"定位代理经纬度回调--定位结果为：%f-----%f",self.BasePointLatLngLocation.coordinate.latitude,self.BasePointLatLngLocation.coordinate.latitude);
        // 2.停止定位
        [manager stopUpdatingLocation];
        //    if (LoctionBooL == YES) {
        if (NearCarOrPeoson == YES) {
            //附近的人
            [self requsetNearUsers];
        }else
        {
            //附近的车
            [self requsetNearDrivers];
        }
        //        LoctionBooL = NO;
        //    }
    }
}
#pragma mark ===================关于定位的代理犯法 结束==================
#pragma mark ===================加载用户详细信息==================
//登录成功后调用用户信息的方法
-(void)requsetPersondetail{
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [HttpTool getWithPath:kDetailUrl params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        if ([status isEqualToString:@"1"]) {
            NSLog(@"%@",responseObj[@"data"][@"user"][@"access_token"]);
            InforModel * inforMo = [[InforModel alloc]initWithRYDict:responseObj[@"data"][@"user"]];
            InforModel * IninforMo = [[InforModel alloc]init];
            IninforMo = [LoginDataModel sharedManager].inforModel;
            IninforMo.idTemp = inforMo.idTemp;
            IninforMo.create_time = inforMo.create_time;
            IninforMo.portrait_image = inforMo.portrait_image;
            IninforMo.nick_name = inforMo.nick_name;
            IninforMo.article_count = inforMo.article_count;
            IninforMo.mobile = inforMo.mobile;
            IninforMo.access_token = inforMo.access_token;
            IninforMo.company1 = inforMo.company1;
            IninforMo.company2 = inforMo.company2;
            IninforMo.email = inforMo.email;
            IninforMo.points = inforMo.points;
            IninforMo.job = inforMo.job;
            IninforMo.zone = inforMo.zone;
            IninforMo.gender = inforMo.gender;
            IninforMo.role = inforMo.role;
            [[LoginDataModel sharedManager]saveLoginMemberData:IninforMo];
            [[NSUserDefaults standardUserDefaults] setObject:inforMo.role forKey:ROLE_TYPE_ZL];
            [[NSUserDefaults standardUserDefaults] setValue:inforMo.nick_name forKey:USER_NICK_NAME];
            
        }
//        if ([status isEqualToString:@"0"]) {
//            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
//            [SVProgressHUD dismiss];
//        }
        //[SVProgressHUD dismiss];
    } failure:^(NSError *error) {
//        self.loginButton.enabled = YES;
//        [SVProgressHUD dismiss];
//        NSLog(@"%@",error);
//        [[RYHUDManager sharedManager] showWithMessage:@"当前无网络......" customView:nil hideDelay:2.f];
    }];
}



@end
