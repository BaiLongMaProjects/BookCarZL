//
//  LoginViewController.m
//  YiGov2
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabViewController.h"
#import "RegisterViewController.h"//注册
#import "ForgetpasswordViewController.h"//忘记密码
#import "XWCountryCodeController.h"//选择国家
#import "LoginDataModel.h"
#import "LoginModel.h"
#import "InforModel.h"
@interface LoginViewController ()<XWCountryCodeControllerDelegate>
{
    NSString * deviceToken;
}
@property (weak, nonatomic) IBOutlet UITextField *PhoneOrEmileTextField;//输入邮箱或手机号
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;//请输入密码
@property (weak, nonatomic) IBOutlet UIButton *ButCountry;//选择国家
@property (weak, nonatomic) IBOutlet UILabel *LabCountry;//显示国家

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //取出数据 但是数据格式尽量要对应 大部分是可以使用ObjectForKey的
    deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"登录页面DeviceToken------>%@",deviceToken);
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark -- 请求数据
//登录的请求方法
-(void)requestLoginUrl
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    
    NSString * str = [_LabCountry.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:self.PhoneOrEmileTextField.text forKey:@"mobile"];
    [params setValue:str forKey:@"zone"];
    [params setValue:self.PasswordTextField.text forKey:@"password"];
    [params setValue:deviceToken forKey:@"device_token"];
    [HttpTool postWithPath:kLoginUrl params:params success:^(id responseObj) {
        NSLog(@"登录返回信息：%@",responseObj);
        NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        
        if ([status isEqualToString:@"0"]) {
                [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
                }
        if ([status isEqualToString:@"1"]) {
            
            LoginModel * login = [[LoginModel alloc]initWithRYDict:responseObj];
            
            LoginModel * inlogin = [[LoginModel alloc]init];
            
            inlogin.token = login.token;
            
            [[LoginDataModel sharedManager]saveLoginInData:inlogin];
        
            InforModel * infor = [[InforModel alloc]init];
            infor = [LoginDataModel sharedManager].inforModel;
            infor.password = self.PasswordTextField.text;
            [[LoginDataModel sharedManager]saveLoginMemberData:infor];

//            EMError *error = [[EMClient sharedClient] loginWithUsername:self.PhoneOrEmileTextField.text password:self.PasswordTextField.text];
//            if (!error) {
//                NSLog(@"登录成功");
//            }
            [self requsetPersondetail];
        }
                
        [SVProgressHUD dismiss];
        self.loginButton.enabled = YES;
    } failure:^(NSError *error) {
        self.loginButton.enabled = YES;
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [SVProgressHUD dismiss];
    }];
}
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
            [[NSUserDefaults standardUserDefaults] setValue:inforMo.mobile forKey:USER_PHOTO_ZL];
            //储存用户密码
            [kUserDefaults setValue:self.PasswordTextField.text forKey:USER_PASSWORD_ZL];
            //这一步是使数据同步，但不是必须的
            [[NSUserDefaults standardUserDefaults] synchronize];
            //自动登录 下次不用再等，默认是关闭的
            NSLog(@"换登录的用户名和密码：%@---%@",[kUserDefaults valueForKey:USER_PHOTO_ZL],[kUserDefaults valueForKey:USER_PASSWORD_ZL]);
            [[EMClient sharedClient] loginWithUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL] password:[kUserDefaults valueForKey:USER_PASSWORD_ZL] completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    NSLog(@"登录页面，环信登录成功");
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                }
                else{
                    NSLog(@"环信登录失败:%@",aError.errorDescription);
                    
                }
            }];
           
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate setRootControllerMainTabVC];
//            MainTabViewController * main = [[MainTabViewController alloc]initWithNibName:@"BookController" bundle:[NSBundle mainBundle]];
//            [main setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//            [self presentViewController:main animated:YES completion:^{
//                NSLog(@"跳转");
//            }];
            
        }
        if ([status isEqualToString:@"0"]) {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
            [SVProgressHUD dismiss];
        }
        [SVProgressHUD dismiss];
        self.loginButton.enabled = YES;
    } failure:^(NSError *error) {
        self.loginButton.enabled = YES;
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.hidden = NO;
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
}
#pragma mark- 按钮的触发方法
//登录按钮触发方法
- (IBAction)LoginButton:(id)sender {
    
    if (self.PhoneOrEmileTextField.text.length == 0 ) {
        [[RYHUDManager sharedManager] showWithMessage:@"您输入的不正确" customView:nil hideDelay:2.f];
        return;
    }
    //加载方式
    [SVProgressHUD show];
    
    
    // 因为设置了自动登录模式：[[EMClient sharedClient].options setIsAutoLogin:YES];
    // 所以，登录之前要先注销之前的用户，否则重复登录会抛异常
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"环信退出成功");
    }
    self.loginButton.enabled = NO;
    //请求登录
    [self requestLoginUrl];


//    自动登录在以下几种情况下会被取消：
//    
//    用户调用了 SDK 的登出动作；
//    用户在别的设备上更改了密码，导致此设备上自动登录失败；
//    用户的账号被从服务器端删除；
//    用户从另一个设备登录，把当前设备上登录的用户踢出。
//    所以，在您调用登录方法前，应该先判断是否设置了自动登录，如果设置了，则不需要您再调用。
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
//        EMError *error2 = [[EMClient sharedClient] loginWithUsername:self.PhoneOrEmileTextField.text password:self.PasswordTextField.text];
//        if (!error2)
//        {
//            [[EMClient sharedClient].options setIsAutoLogin:YES];
//            NSLog(@"环信登录成功");
//        }
//    }
    
}
//注册按钮
- (IBAction)RegisterButton:(id)sender {
    NSLog(@"点击了注册按钮");
    RegisterViewController * regist = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
    
}
//忘记密码按钮
- (IBAction)ForgetPassword:(id)sender {
    NSLog(@"点击了忘记密码按钮");
    ForgetpasswordViewController * forget = [[ForgetpasswordViewController alloc]init];
    
    [self.navigationController pushViewController:forget animated:YES];
}
#pragma mark- 键盘回收（邮箱及密码）
- (IBAction)emailTextfield:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)passwordTextfield:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)ButCountryClick:(id)sender {
    
    NSLog(@"进入选择国际代码界面");
    
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    
    CountryCodeVC.deleagete = self;
    
    
    //block
    
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
       
        NSString * str = countryCodeStr;
    
        NSArray *array = [str componentsSeparatedByString:@"+"];
        
        NSLog(@"%@",array[1]);
        
        self.LabCountry.text = [NSString stringWithFormat:@"+%@",array[1]];
        }];
    
    [self presentViewController:CountryCodeVC animated:YES completion:nil];
}

- (IBAction)ButWeiXin:(id)sender {
//    //例如QQ的登录
//    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
//           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//     {
//         if (state == SSDKResponseStateSuccess)
//         {
//             
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
//         }
//         
//         else
//         {
//             NSLog(@"%@",error);
//         }
//         
//     }];
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
