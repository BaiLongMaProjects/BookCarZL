//
//  RegisterViewController.m
//  YiGov2
//
//  Created by mac on 2017/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainTabViewController.h"
#import "RoleViewController.h"//角色切换
#import "RegisterFinishViewController.h"//下一步注册
#import "XWCountryCodeController.h"//选择国家
#import "ForgetpasswordViewController.h"//忘记密码
#import "LoginModel.h"
#import "LoginDataModel.h"

#import "PDFfileViewController.h"//pdf文件
@interface RegisterViewController ()<UITextFieldDelegate,XWCountryCodeControllerDelegate>
{
    NSInteger timerNo;
    NSTimer * timer;
    
    NSString * deviceToken;
    BOOL CodeBooL;
    
}

@property (weak, nonatomic) IBOutlet UITextField *PhoneTextfield;//手机号

@property (weak, nonatomic) IBOutlet UITextField *YanzhengmaTextfield;//验证码

@property (weak, nonatomic) IBOutlet UITextField *NiceNameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;//密码

@property (weak, nonatomic) IBOutlet UIButton *gitCodeBtn;//验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *ButCountry;//选择国家
@property (weak, nonatomic) IBOutlet UILabel *LabCountry;//文字

@end

@implementation RegisterViewController


//验证码接口
-(void)requsetYanzhengma{
    
    NSString * str = [_LabCountry.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.PhoneTextfield.text zone:str result:^(NSError *error) {
        
        if (!error)
        {
            NSLog(@"%@",error);
            NSLog(@"请求成功");
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:timer repeats:YES];
            self.gitCodeBtn.userInteractionEnabled = NO;

            CodeBooL = NO;
            // 请求成功
        }
        else
        {
            NSLog(@"%@",error);
            [[RYHUDManager sharedManager] showWithMessage:@"请求失败" customView:nil hideDelay:2.f];
            CodeBooL = YES;
            // error
        }
    }];
}
//注册接口
-(void)requsetRegister{
    NSString * str = [_LabCountry.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:self.PhoneTextfield.text forKey:@"mobile"];
    [params setValue:str forKey:@"zone"];
    [params setValue:self.YanzhengmaTextfield.text forKey:@"code"];
    [params setValue:self.PasswordTextField.text forKey:@"password"];
    [params setValue:self.NiceNameTextfield.text forKey:@"nick_name"];
    [params setValue:deviceToken forKey:@"device_token"];
    
    [HttpTool postWithPath:kRegisterUrl params:params success:^(id responseObj) {
        NSLog(@"注册返回信息:%@",responseObj[@"data"]);
        NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            
            LoginModel * login = [[LoginModel alloc]initWithRYDict:responseObj];
            
            LoginModel * inlogin = [[LoginModel alloc]init];
            
            inlogin.token = login.token;
            
            [[LoginDataModel sharedManager]saveLoginInData:inlogin];
            
//            MainTabViewController * main = [[MainTabViewController alloc]initWithNibName:@"BookController" bundle:[NSBundle mainBundle]];
//            [main setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//            [self presentViewController:main animated:YES completion:^{
//                NSLog(@"跳转");
//            }];
            RoleViewController * role = [[RoleViewController alloc]init];
            [self.navigationController pushViewController:role animated:YES];
            
            EMError *error = [[EMClient sharedClient] registerWithUsername:self.PhoneTextfield.text password:self.PasswordTextField.text];
            if (error==nil) {
                NSLog(@"=====注册成功");
            }
            //储存用户密码
            [kUserDefaults setValue:self.PasswordTextField.text forKey:USER_PASSWORD_ZL];
            
            // 因为设置了自动登录模式：[[EMClient sharedClient].options setIsAutoLogin:YES];
            // 所以，登录之前要先注销之前的用户，否则重复登录会抛异常
            EMError *error2 = [[EMClient sharedClient] logout:YES];
            if (!error2) {
                NSLog(@"退出成功");
            }
            //自动登录 下次不用再等，默认是关闭的
            EMError *error1 = [[EMClient sharedClient] loginWithUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL] password:[kUserDefaults valueForKey:USER_PASSWORD_ZL]];
            if (!error1) {
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                NSLog(@"环信注册接口中，登录成功");
            }
            //获取个人信息
            [self requsetPersondetail];
        }else
        {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        
        [SVProgressHUD dismiss];
        self.regButton.enabled = YES;
    } failure:^(NSError *error) {
        self.regButton.enabled = YES;
        NSLog(@"注册链接失败:%@",error);
        
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
            IninforMo.password = self.PasswordTextField.text;
            [[LoginDataModel sharedManager]saveLoginMemberData:IninforMo];
            [[NSUserDefaults standardUserDefaults] setValue:inforMo.nick_name forKey:USER_NICK_NAME];
            [[NSUserDefaults standardUserDefaults] setValue:inforMo.mobile forKey:USER_PHOTO_ZL];
        }
        
        if ([status isEqualToString:@"0"]) {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        
        [SVProgressHUD dismiss];
        self.regButton.enabled = YES;
    } failure:^(NSError *error) {
        self.regButton.enabled = YES;
        NSLog(@"error请求失败 ===  %@",error);
    }];

}

#pragma mark- 验证码倒计时
-(void)timerAction:(NSTimer * )timerA
{
        timerNo--;
        [self.gitCodeBtn setTitle:[NSString stringWithFormat:@"%zds重新验证",timerNo] forState:UIControlStateNormal];
        NSLog(@"%@",self.gitCodeBtn.titleLabel.text);
        //用来判断是否验证码倒计时结束
        if (timerNo == 0) {
            timerNo = 60;
            [timer invalidate];
            self.gitCodeBtn.userInteractionEnabled = YES;
            [self.gitCodeBtn setTitle:@"60s重新验证" forState:UIControlStateNormal];
            CodeBooL = YES;
        }
        NSLog(@"%ld",(long)timerNo);
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];

    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
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
    
    timerNo = 60;
    [self.gitCodeBtn setTitle:@"(60)重新验证" forState:UIControlStateDisabled];
 
    self.PhoneTextfield.delegate = self;
    self.YanzhengmaTextfield.delegate = self;
    self.PasswordTextField.delegate = self;
    self.NiceNameTextfield.delegate = self;
    
    //隐私条款
    [self.ButPriPolicy addTarget:self action:@selector(ButPriPolicyClick:) forControlEvents:UIControlEventTouchUpInside];
    //服务条款
    [self.ButTermsService addTarget:self action:@selector(ButTermsServiceClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CodeBooL = YES;
    
}
#pragma mark-按钮部分
//验证码
- (IBAction)YanzhengmaClick:(id)sender {
    if (self.PhoneTextfield.text.length > 0) {
        if (CodeBooL == YES) {
            [self requsetYanzhengma];
        }
        CodeBooL = NO;
    }else
        {
    [[RYHUDManager sharedManager] showWithMessage:@"请输入您的手机号" customView:nil hideDelay:2.f];
        }
}
//注册按钮
- (IBAction)registerButton:(id)sender {
    if (self.PhoneTextfield.text.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写正确的手机号" customView:nil hideDelay:2.f];
        return;
    }
    
    if (![XYQRegexPatternHelper validatePassword:self.PasswordTextField.text]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入6-12位的密码" customView:nil hideDelay:2.f];
        return;
    }
    self.regButton.enabled = NO;
    [self requsetRegister];

}
//已是会员点击回到登录页
- (IBAction)LoginYesButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
- (IBAction)ButForgetpassword:(id)sender {
    ForgetpasswordViewController * password = [[ForgetpasswordViewController
                                                alloc]init];
    [self.navigationController pushViewController:password animated:YES];
}


//服务条款
-(void)ButTermsServiceClick:(UIButton *)sender
{
    PDFfileViewController * pdf = [[PDFfileViewController  alloc]init];
    pdf.StrMessage = @"1";
    [self.navigationController pushViewController:pdf animated:YES];
}
//隐私条款
-(void)ButPriPolicyClick:(UIButton *)sender
{
    PDFfileViewController * pdf = [[PDFfileViewController  alloc]init];
    pdf.StrMessage = @"0";
    [self.navigationController pushViewController:pdf animated:YES];
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
