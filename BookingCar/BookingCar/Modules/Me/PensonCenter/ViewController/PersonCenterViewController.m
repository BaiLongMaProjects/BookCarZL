//
//  PersonCenterViewController.m
//  BookingCar
//
//  Created by mac on 2017/7/2.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonCenterTableViewCell.h"
#import "PerCenterHeadView.h"
#import "PerNewPasswordViewController.h"//重新设置密码
#import "InformationPickView.h"//滚动选项
#import "ChangeNameViewController.h"//修改姓名
#import "ChangeJobViewController.h"//修改职业
#import "MyAreaViewController.h"//我的所属区域
#import "HomeTownViewController.h"//我的家乡
#import "UpLoadOldViewController.h"//年龄
@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource,InformationPickViewDelegate>
{
    NSArray * perCenterArr;//装载前缀名
    NSArray * perLastArr;//装载后缀的数组
    UIImage * Image;//储存头像的部分
    NSString *HeardPhotoStrName;//图片的地址
    NSMutableArray * pickerSexArray;//储存性别数组
    NSString * StrSex;//性别
    NSIndexPath * SexIndexPath;//储存性别的位置

}
@property (nonatomic, strong)UITableView * PerCenterTab;//个人中心列表
@property (nonatomic, strong)PersonCenterTableViewCell * perCenterCell;//自定义Cell
@property (nonatomic, strong)PerCenterHeadView * perCenterHeadView;//头视图
@property (nonatomic ,strong)InformationPickView *pickViewAddress;//滚动选项

@end

@implementation PersonCenterViewController
-(PerCenterHeadView *)perCenterHeadView
{
    if (nil == _perCenterHeadView) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PerCenterHeadView" owner:self options:nil];
            _perCenterHeadView = [nibs lastObject];
        [_perCenterHeadView.HeadButton addTarget:self action:@selector(HeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
   
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;

    //加载头像
    [_perCenterHeadView.HeadImg sd_setImageWithURL:[NSURL URLWithString:infor.portrait_image] placeholderImage:[UIImage imageNamed:@"My_header"]];
    if (infor.portrait_image.length == 0) {
        [_perCenterHeadView.HeadImg setImage:[UIImage imageNamed:@"My_header"]];
    }
    return _perCenterHeadView;
}
-(UITableView *)PerCenterTab
{
    if (nil == _PerCenterTab) {
        _PerCenterTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _PerCenterTab.delegate = self;
        _PerCenterTab.dataSource = self;
        _PerCenterTab.backgroundColor = [UIColor whiteColor];
        _PerCenterTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _PerCenterTab.tableHeaderView = self.perCenterHeadView;
        self.pickViewAddress.hidden = YES;
        [self.PerCenterTab addSubview:self.pickViewAddress];
    }
    return _PerCenterTab;
}
#pragma mark -Property Methods
-(InformationPickView *)pickViewAddress
{
    if (nil == _pickViewAddress) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InformationPickView" owner:self options:nil];
        _pickViewAddress = [nibs lastObject];
        _pickViewAddress.delegate = self;
        
    }
    return _pickViewAddress;
}

-(void)HeadButtonClick:(UIButton *)sender
{
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            self.perCenterHeadView.HeadImg.image = image;
            //NSLog(@"%@",image);
            Image = image;
            //[SVProgressHUD show];
            [self requsetHeardPhotoSelected];
        }
    }];
}
#pragma mark -- 网络数据请求
//上传头像
-(void)requsetHeardPhotoSelected
{
    [self showLoading];
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    
    NSData * imageData;
    if (UIImagePNGRepresentation(Image) == nil) {
        imageData = UIImageJPEGRepresentation(Image, 0.2);
    }else
    {
        imageData = UIImagePNGRepresentation(Image);
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSArray * array = [NSArray arrayWithObject:Image];
    [HttpTool postWithPath:kUploadPrefixHeadphoto name:@"img" imagePathList:array params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        [self dismissLoading];
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        infor.portrait_image = responseObj[@"result"][@"url"];
        [[LoginDataModel sharedManager]saveLoginMemberData:infor];
        //上传个人信息
        [self requsetUpdatePerson];
    } failure:^(NSError *error) {
        NSLog(@"上传失败  == %@",error);
        [self dismissLoading];
    }];
}

//加载个人信息
-(void)requsetdetail{
    
    LoginModel * login = [[LoginModel alloc]init];
    login= [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [HttpTool getWithPath:kDetailUrl params:params success:^(id responseObj) {
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
            NSLog(@"个人中心手机号：%@",IninforMo.mobile);
            IninforMo.access_token = inforMo.access_token;
            IninforMo.company1 = inforMo.company1;
            IninforMo.company2 = inforMo.company2;
            IninforMo.email = inforMo.email;
            IninforMo.points = inforMo.points;
            IninforMo.job = inforMo.job;
            IninforMo.gender = inforMo.gender;
            IninforMo.portrait_image = inforMo.portrait_image;
            IninforMo.birthday = inforMo.birthday;
            [[LoginDataModel sharedManager]saveLoginMemberData:IninforMo];
//            InforModel * infor = [[InforModel alloc]init];
//            infor = [LoginDataModel sharedManager].inforModel;
            perLastArr = [NSArray arrayWithObjects:IninforMo.nick_name,IninforMo.gender,IninforMo.mobile,IninforMo.job,IninforMo.company1,IninforMo.company2,IninforMo.birthday, nil];
            
        }
        if ([status isEqualToString:@"0"]) {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        [SVProgressHUD dismiss];
        [self.PerCenterTab reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
//上传个人信息
-(void)requsetUpdatePerson{

    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:infor.access_token forKey:@"token"];
    [params setValue:infor.nick_name forKey:@"nick_name"];
    [params setValue:infor.company1 forKey:@"company1"];
    [params setValue:infor.company2 forKey:@"company2"];
    [params setValue:infor.birthday forKey:@"birthday"];
    [params setValue:infor.job forKey:@"job"];
    [params setValue:infor.email forKey:@"email"];
    [params setValue:infor.gender forKey:@"gender"];
    [params setValue:infor.portrait_image forKey:@"avatar"];
//  [params setValue:infor.portrait_image forKey:@"icon"];
    [HttpTool postWithPath:kUpdatePerson params:params success:^(id responseObj) {
    NSLog(@"%@",responseObj);
    [[RYHUDManager sharedManager] showWithMessage:@"上传成功！" customView:nil hideDelay:2.f];
        //加载个人信息的接口
        [self requsetdetail];
        
        [self.PerCenterTab reloadData];
    } failure:^(NSError *error) {
        NSLog(@"上传失败error ===  %@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /** 设置导航栏 */
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"124Nav"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self requsetdetail];//加载个人信息

    
    [self.tabBarController.tabBar setHidden:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    perCenterArr = [NSArray arrayWithObjects:@"姓名",@"性别",@"手机号",@"职业",@"所属区域",@"我的家乡",@"年龄", nil];
    [self.view addSubview:self.PerCenterTab];
}
#pragma mark- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return perCenterArr.count ;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"perCenterCell";
    self.perCenterCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!self.perCenterCell) {
        self.perCenterCell = [[[NSBundle mainBundle]loadNibNamed:@"PersonCenterTableViewCell" owner:self options:nil]lastObject];
    }
    self.perCenterCell.PersonCenterLab.text = perCenterArr[indexPath.row];
    self.perCenterCell.LabPerDetail.text = perLastArr[indexPath.row];
    //去线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row ==2) {
        self.perCenterCell.rightImage.hidden = YES;
    }
    
    return self.perCenterCell;
}

//点击Cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SexIndexPath = indexPath;
    //NSLog(@"点击了 == %@",perCenterArr[indexPath.row]);
    //NSLog(@"点击了 == %ld",(long)indexPath.row);

    if (indexPath.row == 0) {
        
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        ChangeNameViewController * changeName = [[ChangeNameViewController alloc]init];
        
        changeName.NiceName = infor.nick_name;
        [self.navigationController pushViewController:changeName animated:YES];
        
    }
    if (indexPath.row == 1) {
        pickerSexArray = [[NSMutableArray alloc]initWithObjects:@"男",@"女", nil];
        [self.pickViewAddress InformationPickViewForDataOfSexArray:pickerSexArray];
        [self showInformationPickView];
    }
    
//    if (indexPath.row == 3) {
//        InforModel * infor = [[InforModel alloc]init];
//        infor = [LoginDataModel sharedManager].inforModel;
//
//        PerNewPasswordViewController * perNew = [[PerNewPasswordViewController alloc]init];
//        perNew.LabPhoneNum.text = infor.mobile;
//        [self.navigationController pushViewController:perNew animated:YES];
//    }
    if (indexPath.row == 3) {
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        ChangeJobViewController * changeJob = [[ChangeJobViewController alloc]init];
        changeJob.changeJob = infor.job;
        [self.navigationController pushViewController:changeJob animated:YES];
    }
    if (indexPath.row == 4) {
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        MyAreaViewController * myarea = [[MyAreaViewController alloc]init];
        myarea.myArea = infor.company1;
        [self.navigationController pushViewController:myarea animated:YES];
    }  if (indexPath.row == 5) {
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        HomeTownViewController * hometown = [[HomeTownViewController alloc]init];
        hometown.homeTown = infor.company2;
        [self.navigationController pushViewController:hometown animated:YES];
    }
    if (indexPath.row == 6) {
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        UpLoadOldViewController * UpLoadold = [[UpLoadOldViewController alloc]init];
        UpLoadold.StrOld = infor.birthday;
        [self.navigationController pushViewController:UpLoadold animated:YES];

    }
}

#pragma mark - Privities Methods
//展示选择城市和选择性别的
-(void)showInformationPickView
{
    [self.PerCenterTab setContentOffset:CGPointMake(0, 0) animated:YES];
    self.PerCenterTab.scrollEnabled = NO;
    
    self.pickViewAddress.frame = CGRectMake(0, 0,KScreenWidth, KScreenHeight);
    if (self.pickViewAddress.hidden == NO) {
        return;
    }
    self.pickViewAddress.hidden = NO;
    self.pickViewAddress.bjView.alpha = 0;
    CGRect rectOriginal = self.pickViewAddress.pickView.frame;
    rectOriginal.origin.y = self.pickViewAddress.bounds.size.height;
    self.pickViewAddress.pickView.frame = rectOriginal;
    [UIView animateWithDuration:0.3f animations:^{
        self.pickViewAddress.bjView.alpha = 0.3f;
        CGRect rect = self.pickViewAddress.pickView.frame;
        rect.origin.y = self.pickViewAddress.bounds.size.height - 200;
        self.pickViewAddress.pickView.frame = rect;
    } completion:nil];
    
}
//影藏选择城市和选择性别的
-(void)hiddenInformationPickView
{
    
    if (self.pickViewAddress.hidden == YES) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.pickViewAddress.bjView.alpha = 0;
        CGRect rect = self.pickViewAddress.pickView.frame;
        rect.origin.y = self.pickViewAddress.bounds.size.height;
        self.pickViewAddress.pickView.frame = rect;
    } completion:^(BOOL finished) {
        self.pickViewAddress.hidden = YES;
    }];
}
#pragma mark - InformationPickViewDelegate
-(void)informationPickViewCancelButtonClick
{
    [self.PerCenterTab setContentOffset:CGPointMake(0, -64) animated:YES];

    self.PerCenterTab.scrollEnabled = YES;

    [self hiddenInformationPickView];
    
}
//性别的text添加
-(void)informationPickViewTrueButtonClickOfTheSexString:(NSString *)name
{
    
    [self.PerCenterTab setContentOffset:CGPointMake(0, -64) animated:YES];
    
    self.PerCenterTab.scrollEnabled = YES;
    
    StrSex = name;
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;
    infor.gender = name;
    [[LoginDataModel sharedManager]saveLoginMemberData:infor];
    //更改性别信息接口

    [self requsetUpdatePerson];
    
    perLastArr = [NSArray arrayWithObjects:infor.nick_name,infor.gender,infor.mobile,infor.job,infor.company1,infor.company2,infor.birthday, nil];
    
    [self.PerCenterTab reloadData];
    //隐藏选项栏
    [self hiddenInformationPickView];
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
