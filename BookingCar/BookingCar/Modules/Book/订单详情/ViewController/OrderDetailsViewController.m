//
//  OrderDetailsViewController.m
//  BookingCar
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "MapDistanceView.h"
#import "OrderDetailTableViewCell.h"
#import "ReadyGoView.h"//准备出发
#import "MyOrderListModel.h"//订单列表
#import "ReadyGoModel.h"//准备出发Model
#import "CommentsViewController.h"//评价页面
#import "ChatPageViewController.h"//聊天
#import <EaseUI.h>

@interface OrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView * BidTabView;
    UIButton * rightBut;
    NSMutableArray * orderListArray;
    NSString * quoteID;
    NSString * driverID;//司机的ID添加聊天人
    NSString * driverName;//聊天人姓名
    NSString * driverMobile;//聊天人电话
    NSString * CustomerName;//乘客姓名
    NSString * CustomerMobile;//乘客电话
    NSString * CustomerID;//乘客ID
    NSString * RoleName;//我的角色
    UIAlertView *alertviewAgree;
    UIAlertView * alertViewPhone;//拨打电话
    ReadyGoModel * readyModel;//准备出发详情
    NSString * driver_imageURLString;//司机头像
    NSString * custom_imageURLString;//乘客头像
    
}
@property (nonatomic, strong)OrderCarModel * orderModel;
@property (nonatomic, strong)MapDistanceView * mapDostanceView;
@property (nonatomic, strong)ReadyGoView * readyGoView;
@property (nonatomic, strong)OrderDetailTableViewCell * orderDetailTabCell;
@end

@implementation OrderDetailsViewController
-(instancetype)initWithDataModel:(OrderCarModel *)orderCarModel
{
    if (self = [super init]) {
        _orderModel = [[OrderCarModel alloc]init];
        _orderModel = orderCarModel;
    }
    return self;
}
//地图
-(MapDistanceView *)mapDostanceView
{
    if (nil == _mapDostanceView) {
        _mapDostanceView = [[[NSBundle mainBundle]loadNibNamed:@"MapDistanceView" owner:self options:nil]lastObject];
        //[_mapDostanceView setFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/2)];
    }
    return _mapDostanceView;
}
-(OrderDetailTableViewCell *)orderDetailTabCell
{
    if (nil == _orderDetailTabCell) {
        _orderDetailTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailTableViewCell" owner:self options:nil]lastObject];
    }
    return _orderDetailTabCell;
}
//准备出发
-(ReadyGoView *)readyGoView
{
    if (nil == _readyGoView) {
        _readyGoView = [[[NSBundle mainBundle]loadNibNamed:@"ReadyGoView" owner:self options:nil]lastObject];
        [_readyGoView.ButCancelTrip addTarget:self action:@selector(ButCancelTripClick:) forControlEvents:UIControlEventTouchUpInside];
        //聊天
        [_readyGoView.ButMessage addTarget:self action:@selector(ButMessageClick) forControlEvents:UIControlEventTouchUpInside];
        
        //电话
        [_readyGoView.ButPhone addTarget:self action:@selector(ButPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //去评价
        [_readyGoView.ButGoComment addTarget:self action:@selector(ButGoCommentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readyGoView;
}
//加载竞价列表
-(void)requsetOrderQuotes
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    
    [params setObject:login.token forKey:@"token"];
    [params setObject:self.orderModel.idTemp forKey:@"order_id"];
    //    [params setObject:@"151" forKey:@"order_id"];
    [HttpTool getWithPath:kOrderQuotes params:params success:^(id responseObj) {
        NSLog(@"quotes === %@",responseObj);
        for (NSDictionary * dic in responseObj[@"data"]) {
            MyOrderListModel * myorder = [[MyOrderListModel alloc]initWithRYDict:dic];
            [orderListArray addObject:myorder];
        }
        [BidTabView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//取消行程
-(void)requsetCancelUrl
{
    __weak typeof(self) weakSelf = self;
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:self.orderModel.idTemp forKey:@"order_id"];
    [params setObject:@"已取消" forKey:@"message"];
//    NSString * urls = nil;
    [HttpTool getWithPath:kOrderCancel params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        [[RYHUDManager sharedManager] showWithMessage:[NSString stringWithFormat:@"%@",responseObj[@"message"]] customView:nil hideDelay:2.f];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//同意竞价
-(void)requsetOrderAgree
{
    __weak typeof(self) weakSelf =self;
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:quoteID forKey:@"quote_id"];
    [params setObject:@"乘客同意了报价" forKey:@"message"];
    [HttpTool getWithPath:kOrderAgree params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        [[RYHUDManager sharedManager] showWithMessage:[NSString stringWithFormat:@"%@",responseObj[@"message"]] customView:nil hideDelay:2.f];
        //获取订单详情
        //[self resqusetOrderInfo];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//订单详情
-(void)resqusetOrderInfo
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:self.orderModel.idTemp forKey:@"order_id"];
    
    [HttpTool getWithPath:kOrderInfo params:params success:^(id responseObj) {
        NSLog(@"ORDER DETAIL  ZL: -----> %@",responseObj);
        readyModel = [[ReadyGoModel alloc]initWithRYDict:responseObj[@"order"]];
        if ([RoleName isEqualToString:@"1"]) {
            driverID = readyModel.user_id;//添加乘客ID
        }else
        {
            driverID = readyModel.driver_id;//添加车主ID
        }
        driverName = readyModel.d_nick_name;//添加车主姓名
        driverMobile = readyModel.d_mobile;//添加车主电话
        CustomerMobile = readyModel.c_mobile;//乘客电话
        //NSLog(@"乘客电话：%@",readyModel.c_mobile);
        CustomerName = readyModel.c_nick_name;//乘客姓名
        driver_imageURLString = readyModel.d_portrait_image;
        custom_imageURLString = readyModel.c_portrait_image;
        
        [self.readyGoView getInforOrderCar:readyModel];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
    
}
//添加聊天人
-(void)requsetChatNew
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;

    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [params setObject:driverID forKey:@"to"];
    
    [HttpTool postWithPath:kDialogNew params:params success:^(id responseObj) {
        NSLog(@"添加新聊天人成功 === %@",responseObj);
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"statusCode"]] isEqualToString:@"1"]) {
            
            //            if ([RoleName isEqualToString:@"1"]) {
            //                NSLog(@"我的角色 ==== 司机");
            
            //self.tabBarController.selectedIndex = 1;
            
        }
    } failure:^(NSError *error) {
        //NSLog(@"添加新聊天人失败：%@",error);
        //[[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    orderListArray = [[NSMutableArray alloc]init];
    //取出数据 但是数据格式尽量要对应 大部分是可以使用ObjectForKey的
    RoleName=[[NSUserDefaults standardUserDefaults] objectForKey:ROLE_TYPE_ZL];
    
    [self.view addSubview:self.mapDostanceView];
    [self.mapDostanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-220.0);
    }];
    [self.view addSubview:self.readyGoView];
    [self.readyGoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(335.0f);
    }];
    
    [self CreatTabViewBid];
    
    BidTabView.hidden = YES;
    self.readyGoView.hidden = YES;
    
    self.view.backgroundColor = kGlobalBg;
//    if (self.SwitchBool == YES) {
//        [self CreatSwitchYesStyle];
//    }else
//    {
//        [self CreatSwitchNoStyle];
//    }
    NSLog(@"订单详情中当前角色为：%@",RoleName);
    [self loadOrderViewWithRoleName:RoleName withOderStatus:_orderModel.status];
    double Slat = [self.orderModel.from_lat doubleValue];
    double Slog = [self.orderModel.from_lng doubleValue];
    double Flat = [self.orderModel.to_lat doubleValue];
    double Flog = [self.orderModel.to_lng doubleValue];
    self.orderModel.CoordinateStart = CLLocationCoordinate2DMake(Slat, Slog);
    self.orderModel.CoordinateFinish = CLLocationCoordinate2DMake(Flat, Flog);
    [self.mapDostanceView getInfoModel:self.orderModel];
}
#pragma mark ===================ZL修改 样式开始==================
- (void)loadOrderViewWithRoleName:(NSString *)role withOderStatus:(NSString *)orderStatus{
    //   司机端的订单状态  0  订单取消  2 已报价    3 订单达成    4 司机取消  5 乘客同意取消   8 超时   9 订单完成  11 订单成交司机不是我
    //   乘客端的订单状态  0  订单取消  1 等待接单  2 司机竞价    3 订单达成  4 司机取消   5 乘客同意取消   8 超时  9订单完成
    NSLog(@"当前的role为：%@,当前的orderStatus:%@",role,orderStatus);
    //0 为乘客  1  为司机
    if([role isEqualToString:@"0"]){
        //为乘客
        //已接单
        if([orderStatus isEqualToString:@"2"]){
            self.readyGoView.hidden = YES;
            BidTabView.hidden = NO;
            rightBut.hidden = NO;
            self.title = @"车主已竞价请求同意";
            [self requsetOrderQuotes];
        }
        if([orderStatus isEqualToString:@"3"]){
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"准备出发";
            rightBut.hidden = NO;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        if ([orderStatus isEqualToString:@"4"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"车主希望取消订单";
            rightBut.hidden = NO;
            self.readyGoView.ButHopeCancel.hidden = NO;
            [self resqusetOrderInfo];
        }
        if ([orderStatus isEqualToString:@"5"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"订单取消";
            rightBut.hidden = YES;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        //超时单
        if ([orderStatus isEqualToString:@"8"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"订单超时";
            rightBut.hidden = YES;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        //已完成
        if ([orderStatus isEqualToString:@"9"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"订单完成";
            rightBut.hidden = YES;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        if ([orderStatus isEqualToString:@"0"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"订单完成";
            rightBut.hidden = YES;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        
    }
    else{
        //为司机
        //已报价
        if([orderStatus isEqualToString:@"2"]){
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"已报价";
            rightBut.hidden = NO;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        //已失效
        //超时单
        if ([orderStatus isEqualToString:@"8"] || [orderStatus isEqualToString:@"11"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"订单超时";
            rightBut.hidden = YES;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        //已取消
        if ([orderStatus isEqualToString:@"0"] || [orderStatus isEqualToString:@"4"] || [orderStatus isEqualToString:@"5"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"订单取消";
            rightBut.hidden = YES;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        //已成交
        if([orderStatus isEqualToString:@"3"]){
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"准备出发";
            rightBut.hidden = NO;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        //已完成
        if ([orderStatus isEqualToString:@"9"]) {
            self.readyGoView.hidden = NO;
            BidTabView.hidden = YES;
            self.title = @"订单完成";
            rightBut.hidden = YES;
            self.readyGoView.ButHopeCancel.hidden = YES;
            [self resqusetOrderInfo];
        }
        
        //被邀请

    }
}



#pragma mark ===================ZL修改 样式结束==================


#pragma mark --- 根据状态样式切换

//页面样式切换
-(void)CreatTabViewBid
{
    BidTabView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    BidTabView.delegate = self;
    BidTabView.dataSource = self;
    BidTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:BidTabView];
    [BidTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(220);
    }];
    
    
    rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut setTitle:@"取消行程" forState:UIControlStateNormal];
    [rightBut.layer setBorderWidth:1];
    [rightBut addTarget:self action:@selector(rightButClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBut.layer setMasksToBounds:YES];
    [rightBut.layer setCornerRadius:5];
    [rightBut setFrame:CGRectMake(0, 0, 70, 25)];
    [rightBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBut.titleLabel setFont:[UIFont systemFontOfSize:13]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * orderDetailCell = @"orderDetailCellid";
    self.orderDetailTabCell = [tableView dequeueReusableCellWithIdentifier:orderDetailCell];
    if (!self.orderDetailTabCell) {
        self.orderDetailTabCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailTableViewCell" owner:self options:nil]lastObject];
    }
    MyOrderListModel * order = [[MyOrderListModel alloc]init];
    order = orderListArray[indexPath.row];
    self.orderDetailTabCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.orderDetailTabCell getInfoModel:order];
    
    //点击了同意
    return self.orderDetailTabCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    alertviewAgree = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要同意该价格吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertviewAgree show];
    
    MyOrderListModel * order = [[MyOrderListModel alloc]init];
    order = orderListArray[indexPath.row];
    quoteID = order.idTemp;
    
}

//取消行程按钮---竞价
-(void)rightButClick{
    NSLog(@"取消行程");
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要取消行程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
}
//取消行程按钮---准备出发
-(void)ButCancelTripClick:(UIButton*)sender
{
    NSLog(@"取消行程");
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要取消行程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertViewPhone) {
        if ([RoleName isEqualToString:@"0"]) {
            if ([alertViewPhone.title isEqualToString:@"拨打电话"]) {
                if (buttonIndex==1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",driverMobile?:@"411"]]];
                }
            }
            
        }else
        {
            if ([alertViewPhone.title isEqualToString:@"拨打电话"]) {
                if (buttonIndex==1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",CustomerMobile?:@"411"]]];
                }
            }
        }
        return;
    }
    //同意价格
    if (alertView == alertviewAgree) {
        if (buttonIndex == 1) {
            //同意竞价
            [self requsetOrderAgree];
        }
    }else
    {
        NSLog(@"%ld",(long)buttonIndex);
        if (buttonIndex == 1) {
            //取消接口
            [self requsetCancelUrl];
        }
    }
    
    
    
}

-(void)ButMessageClick
{
    NSLog(@"点击了聊天");
    [self requsetChatNew];
    NSString * converID = nil;
    if ([RoleName isEqualToString:@"0"]) {
      
        converID = driverMobile;
    }else
    {
        converID = CustomerMobile;
    }
#pragma mark -- 添加好友
    EMError *error = [[EMClient sharedClient].contactManager addContact:converID message:@"我想加您为好友"];
    if (!error) {
        NSLog(@"添加成功");
    }
    else{
        NSLog(@"添加好友失败:%@",error.errorDescription);
    }

    NSLog(@"订单详情中，点击了聊天，司机的电话:%@,用户的电话:%@",converID,[kUserDefaults valueForKey:USER_PHOTO_ZL]);
    EMError *error1 = [[EMClient sharedClient].contactManager acceptInvitationForUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL]];
    if (!error1) {
        NSLog(@"开启聊天发送同意成功");
    }
    else{
        
        NSLog(@"开启聊天失败:%@",error1.errorDescription);
    }
    
    ChatSubViewVC *chatController = [[ChatSubViewVC alloc]initWithConversationChatter:converID conversationType:EMConversationTypeChat];
    chatController.title = converID;
    if ([RoleName isEqualToString:@"0"]) {
        
        chatController.myHeaderImageString = custom_imageURLString;
        chatController.yourHeaderImageString = driver_imageURLString;
    }else
    {
        chatController.myHeaderImageString = driver_imageURLString;
        chatController.yourHeaderImageString = custom_imageURLString;
    }
    
    [self.navigationController pushViewController:chatController animated:YES];
}

-(void)ButPhoneClick:(UIButton*)sender
{
    NSLog(@"拨打电话");
    if ([RoleName isEqualToString:@"0"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",driverMobile?:@"411"]]];
    }else
    {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",CustomerMobile?:@"411"]]];
    }
//    NSString * phoneString = nil;
//    if([RoleName isEqualToString:@"0"]){
//        phoneString = driverName;
//
//    }else{
//        phoneString = CustomerName;
//
//    }
//
//    alertViewPhone = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:[NSString stringWithFormat:@"拨打电话%@",phoneString]
//                                              delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertViewPhone show];
    
}



-(void)ButGoCommentClick
{
    CommentsViewController * comment = [[CommentsViewController alloc]initWithDataModel:readyModel];
    [self.navigationController pushViewController:comment animated:YES];
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
