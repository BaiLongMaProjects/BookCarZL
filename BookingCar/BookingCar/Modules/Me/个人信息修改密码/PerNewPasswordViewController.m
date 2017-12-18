//
//  PerNewPasswordViewController.m
//  RootDirectory
//
//  Created by 李东晓 on 16/8/8.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "PerNewPasswordViewController.h"
#define krequsetSetPasswordDownloaderKey @"requsetSetPasswordSelected"//设置新密码
#define kYanzhenmaDownlaoderKey @"YanzhenmaDownlaoderKey"//验证码

@interface PerNewPasswordViewController ()
{
    NSInteger timerNo;
    NSTimer * timer;
}

@end

@implementation PerNewPasswordViewController

#pragma mark --- 数据层
-(void)requsetforgetpassword
{
    InforModel * inforMo = [[InforModel alloc]init];
    inforMo = [LoginDataModel sharedManager].inforModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:self.LabPhoneNum.text forKey:@"mobile"];
    [params setValue:@"86" forKey:@"zone"];
    [params setValue:self.TextAuthcode.text forKey:@"code"];
    [params setValue:self.TextNewPassword.text forKey:@"password"];
    
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
            
            [[RYHUDManager sharedManager] showWithMessage:@"修改成功" customView:nil hideDelay:2.f];
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
//验证码
//验证码接口
-(void)requsetYanzhengma{
    
    InforModel * inforMo = [[InforModel alloc]init];
    inforMo = [LoginDataModel sharedManager].inforModel;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.LabPhoneNum.text zone:@"86" result:^(NSError *error) {
        if (!error)
        {
            NSLog(@"%@",error);
            NSLog(@"请求成功");
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:timer repeats:YES];
            self.ButGainCode.userInteractionEnabled = NO;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置新密码";
    [self NibFrameSize];
    timerNo = 60;
    [self.ButGainCode setTitle:@"(60)重新验证" forState:UIControlStateDisabled];
    
    
}
//验证码
- (IBAction)ButGainCodeClick:(id)sender {
    
    [self requsetYanzhengma];
}
//确定
- (IBAction)ButSureClick:(id)sender {
    // 一.设置textField的enabled属性为NO。
    //找到编译窗口
    UITextField *textField = self.view.subviews[0];
    
    // 二.让textField处于非编辑状态
    [textField endEditing:YES];
    
    // 三.让textField取消第一响应者
    [textField resignFirstResponder];

    if ([self.TextAuthcode.text isEqualToString:@""]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的验证码" customView:nil hideDelay:2.f];
        return;
    }
    if ([self.TextNewPassword.text isEqualToString:@""]) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的新密码" customView:nil hideDelay:2.f];
        return;
    }
    if (self.TextNewPassword.text.length < 6 ||self.TextNewPassword.text.length >30) {
        [[RYHUDManager sharedManager] showWithMessage:@"密码长度为6到30位" customView:nil hideDelay:2.f];
        return;
    }
    
    NSRange passwordRange = [self.TextNewPassword.text rangeOfString:@" "];
    if (passwordRange.location != NSNotFound) {
        [[RYHUDManager sharedManager] showWithMessage:@"密码设置不能含有空格" customView:nil hideDelay:2.f];
        return;
    }
    [self requsetforgetpassword];
}
#pragma mark- 验证码倒计时
-(void)timerAction:(NSTimer * )timerA
{
    timerNo--;
    
//    self.ButGainCode.enabled = YES;
    [self.ButGainCode setTitle:[NSString stringWithFormat:@"(%zd)重新验证",timerNo] forState:UIControlStateNormal];
    NSLog(@"%@",self.ButGainCode.titleLabel.text);
    //用来判断是否验证码倒计时结束
    if (timerNo == 0) {
        timerNo = 60;
        [timer invalidate];
        self.ButGainCode.userInteractionEnabled = YES;
        [self.ButGainCode setTitle:@"(60)重新验证" forState:UIControlStateNormal];
    }
    NSLog(@"%ld",(long)timerNo);
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
#pragma mark - downloadDelegate

- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    //设置新密码
    if ([downloader.purpose isEqualToString:krequsetSetPasswordDownloaderKey]) {
        
        NSDictionary * NewPassword = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        [[RYHUDManager sharedManager] showWithMessage:NewPassword[@"msg"] customView:nil hideDelay:2.f];
        if ([NewPassword[@"code"]intValue] == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //发送短信
    if ([downloader.purpose isEqualToString:kYanzhenmaDownlaoderKey]) {
        NSDictionary * Yanzheng = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       
        if ([Yanzheng[@"code"] intValue]==200) {
            NSLog(@"验证码：%@",Yanzheng[@"verify_code"]);
        }else{
            NSString *mes = @"验证码已失效";
            [[RYHUDManager sharedManager] showWithMessage:mes customView:nil hideDelay:2.f];
        }
        
    }
}

- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    
     [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}


-(void)NibFrameSize
{
    self.ButSure.layer.cornerRadius = 4;
    self.ButSure.layer.masksToBounds = YES;
    
    self.ButGainCode.layer.cornerRadius = 4;
    self.ButGainCode.layer.masksToBounds = YES;
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;

    self.LabPhoneNum.text = infor.mobile;
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
