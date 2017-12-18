//
//  ForgetpasswordViewController.m
//  YiGov2
//
//  Created by mac on 2017/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ForgetpasswordViewController.h"
#import <TSMessages/TSMessageView.h>
#import "LoginModel.h"
#import "LoginDataModel.h"
#import "MainTabViewController.h"
#import "RoleViewController.h"//选择角色
#import "XWCountryCodeController.h"
@interface ForgetpasswordViewController ()<UITextFieldDelegate,XWCountryCodeControllerDelegate>
{
    NSInteger timerNo;
    NSTimer * timer;
    BOOL PhoneOrEmail;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;//请输入手机号
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTextfield;//请输入验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;//请输入密码
@property (weak, nonatomic) IBOutlet UIButton *gitCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ButCountry;//选择国家
@property (weak, nonatomic) IBOutlet UILabel *LabCountry;//国家文字

@property (weak, nonatomic) IBOutlet UIImageView *ImgUpCountry;//下拉图片

@property (weak, nonatomic) IBOutlet UIButton *ButEmailfind;//找回按钮

@end

@implementation ForgetpasswordViewController
//验证码接口
-(void)requsetYanzhengma{
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextfield.text zone:self.LabCountry.text result:^(NSError *error) {
        
        if (!error)
        {
            NSLog(@"%@",error);
            NSLog(@"请求成功");
            // 请求成功
        }
        else
        {
            NSLog(@"%@",error);
            [[RYHUDManager sharedManager] showWithMessage:@"请求失败" customView:nil hideDelay:2.f];
            // error
        }
    }];
}




-(void)requsetforgetpassword
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:self.phoneTextfield.text forKey:@"mobile"];
    [params setValue:self.LabCountry.text forKey:@"zone"];
    [params setValue:self.yanzhengmaTextfield.text forKey:@"code"];
    [params setValue:self.passwordTextfield.text forKey:@"password"];

    [HttpTool postWithPath:kResetPasswordUrl params:params success:^(id responseObj) {
    NSLog(@"%@",responseObj);
    NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
    
    if ([status isEqualToString:@"0"]) {
        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
    }
    if ([status isEqualToString:@"1"]) {
        
        LoginModel * login = [[LoginModel alloc]initWithRYDict:responseObj];
        
        LoginModel * inlogin = [[LoginModel alloc]init];
        
        inlogin.token = login.token;
        
        [[LoginDataModel sharedManager]saveLoginInData:inlogin];
        
        RoleViewController * role = [[RoleViewController alloc]init];

        [self.navigationController pushViewController:role animated:YES];
        

        [[RYHUDManager sharedManager] showWithMessage:@"修改成功" customView:nil hideDelay:2.f];
        }
    
    [SVProgressHUD dismiss];
    
} failure:^(NSError *error) {
    
    
}];
    
}
//EMAIL找回密码
-(void)requsetforgetEmailPassword
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:self.phoneTextfield.text forKey:@"email"];
    [params setValue:self.yanzhengmaTextfield.text forKey:@"code"];
    [params setValue:self.passwordTextfield.text forKey:@"password"];
    
    [HttpTool postWithPath:kChangePasswordUrl params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        
        if ([status isEqualToString:@"0"]) {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        if ([status isEqualToString:@"1"]) {
            
            LoginModel * login = [[LoginModel alloc]initWithRYDict:responseObj];
            
            LoginModel * inlogin = [[LoginModel alloc]init];
            
            inlogin.token = login.token;
            
            [[LoginDataModel sharedManager]saveLoginInData:inlogin];
            
            MainTabViewController * main = [[MainTabViewController alloc]initWithNibName:@"BookController" bundle:[NSBundle mainBundle]];
            [main setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:main animated:YES completion:^{
                NSLog(@"跳转");
            }];
            
            InforModel * infor = [[InforModel alloc]init];
            infor = [LoginDataModel sharedManager].inforModel;
            infor.password = self.passwordTextfield.text;
            [[LoginDataModel sharedManager]saveLoginMemberData:infor];
            
            [[RYHUDManager sharedManager] showWithMessage:@"修改成功" customView:nil hideDelay:2.f];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


#pragma mark- 验证码倒计时
-(void)timerAction:(NSTimer * )timerA
{
    
    timerNo--;
    
    //    self.ButGainCode.enabled = YES;
    [self.gitCodeBtn setTitle:[NSString stringWithFormat:@"(%zd)重新验证",timerNo] forState:UIControlStateNormal];
    NSLog(@"%@",self.gitCodeBtn.titleLabel.text);
    //用来判断是否验证码倒计时结束
    if (timerNo == 0) {
        timerNo = 60;
        [timer invalidate];
        self.gitCodeBtn.userInteractionEnabled = YES;
        [self.gitCodeBtn setTitle:@"(60)重新验证" forState:UIControlStateNormal];
    }
    NSLog(@"%ld",(long)timerNo);
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.phoneTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    self.yanzhengmaTextfield.delegate = self;
    
    PhoneOrEmail = YES;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-按钮点击方法
//提交
- (IBAction)SubmitButton:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    
//    if (![XYQRegexPatternHelper validateMobile:self.phoneTextfield.text]) {
//        [[RYHUDManager sharedManager] showWithMessage:@"请填写正确的手机号" customView:nil hideDelay:2.f];
//        return;
//    }
    if ([self.yanzhengmaTextfield.text isEqualToString:@""]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的验证码" customView:nil hideDelay:2.f];
        return;
    }
    
    if (![XYQRegexPatternHelper validatePassword:self.passwordTextfield.text]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入6-12位的密码" customView:nil hideDelay:2.f];
        return;
    }
    
    if (PhoneOrEmail == YES) {
        [self requsetforgetpassword];
    }else
    {
        [self requsetforgetEmailPassword];
    }
 
    
//    [TSMessage showNotificationWithTitle:@"提交失败" type:TSMessageNotificationTypeError];
}
//返回
- (IBAction)BackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//获取验证码
- (IBAction)yanzhengmaClick:(id)sender {
    if (self.phoneTextfield.text.length > 0) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:timer repeats:YES];
        self.gitCodeBtn.userInteractionEnabled = NO;
        timerNo = 60;
        [self requsetYanzhengma];
        
    }else
    {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入您的手机号" customView:nil hideDelay:2.f];
    }
}
- (IBAction)ButCountry:(id)sender {
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

#pragma mark-设置键盘回收方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)ButEmailfindClick:(id)sender {

    if (PhoneOrEmail == YES) {
        PhoneOrEmail = NO;

        self.phoneTextfield.placeholder = @"请输入您的邮箱号";
        self.ImgUpCountry.hidden = YES;
        self.LabCountry.hidden = YES;
        self.ButCountry.hidden = YES;
        [self.ButEmailfind setTitle:@"手机号找回" forState:UIControlStateNormal];
    }else
    {
        PhoneOrEmail = YES;
        self.phoneTextfield.placeholder = @"请输入您的手机号";
        self.ImgUpCountry.hidden = NO;
        self.LabCountry.hidden = NO;
        self.ButCountry.hidden = NO;
        self.ButEmailfind.titleLabel.text = @"手机号找回";
        [self.ButEmailfind setTitle:@"邮箱找回" forState:UIControlStateNormal];
    }
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
