//
//  ZLLoginViewModel.m
//  BookingCar
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "ZLLoginViewModel.h"

@implementation ZLLoginViewModel

+ (ZLLoginViewModel *)shareInstance{
    static ZLLoginViewModel * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
/** 登录请求 */
- (void)startLoginAFNetworkingWith:(NSString *)userName withCode:(NSString *)code withCountryNum:(NSString *)countryNum withSuccessBlock:(void (^)(BOOL, int, int, int))successBlock withFailBlock:(void (^)(BOOL, NSString *))failBlock{
   NSString * deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSLog(@"登录页面DeviceToken------>%@",deviceToken);
    NSDictionary * prama = @{
                             @"mobile":userName,
                             @"zone":countryNum,
                             @"device_token":deviceToken,
                             @"code":code
                             };
    NSString * url = [NSString stringWithFormat:@"%@%@",kBaseurl,kZLSMS_Login_URL];
    [[ZLSecondAFNetworking sharedInstance] postWithURLString:url parameters:prama success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"登录成功:%@",dic);
        /** mark 0 为老用户，1 为新用户
            active 0 乘客，1 为司机，2 为未选择角色
         */
        if ([dic[@"status"] intValue] == 1) {
            [kUserDefaults setObject:dic[@"token"] forKey:USER_TOKEN_ZL];
            [kUserDefaults setObject:userName forKey:USER_PHOTO_ZL];
            [kUserDefaults setObject:USER_HUANXIN_PASSWORD forKey:USER_PASSWORD_ZL];
            /** LDX遗留问题，准备修改 */
            LoginModel * inlogin = [[LoginModel alloc]init];
            inlogin.token = dic[@"token"];
            [[LoginDataModel sharedManager]saveLoginInData:inlogin];
            //登录成功
            if ([dic[@"mark"] intValue] == 0) {
                // 0  老用户
                //自动登录 下次不用再等，默认是关闭的
                [[EMClient sharedClient] loginWithUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL] password:USER_HUANXIN_PASSWORD completion:^(NSString *aUsername, EMError *aError) {
                    if (!aError) {
                        NSLog(@"登录页面，环信登录成功");
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                    }
                    else{
                        NSLog(@"环信登录失败:%@",aError.errorDescription);
                    }
                }];
                if ([dic[@"active"] intValue] == 0) {
                    //乘客
                    successBlock(YES,0,0,11);
                    
                }else if ([dic[@"active"] intValue] == 1){
                    //司机 check_type 0 未提交资料 1审核中 2审核未通过 10 审核通过
                    if ([dic[@"check_type"] intValue] == 0) {
                        successBlock(YES,1,0,0);
                    }else if ([dic[@"check_type"] intValue] == 1){
                        successBlock(YES,1,0,1);
                    }else if ([dic[@"check_type"] intValue] == 2){
                        successBlock(YES,1,0,2);
                    }else if ([dic[@"check_type"] intValue] == 10){
                        successBlock(YES,1,0,10);
                    }
                    
                }else if ([dic[@"active"] intValue] == 2){
                    //未选择角色
                    successBlock(YES,2,0,0);
                }
                
            }
            else{
                // 1新用户
                EMError *error = [[EMClient sharedClient] registerWithUsername:userName password:[kUserDefaults valueForKey:USER_HUANXIN_PASSWORD]];
                if (error==nil) {
                    NSLog(@"环信=====注册成功");
                }
                // 因为设置了自动登录模式：[[EMClient sharedClient].options setIsAutoLogin:YES];
                // 所以，登录之前要先注销之前的用户，否则重复登录会抛异常
                EMError *error2 = [[EMClient sharedClient] logout:YES];
                if (!error2) {
                    NSLog(@"退出成功");
                }
                //自动登录 下次不用再等，默认是关闭的
                EMError *error1 = [[EMClient sharedClient] loginWithUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL] password:[kUserDefaults valueForKey:USER_HUANXIN_PASSWORD]];
                if (!error1) {
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    NSLog(@"环信注册接口中，登录成功");
                }
                successBlock(YES,0,1,12);
            }
        }
        else{
            //登录失败
            failBlock(YES,dic[@"message"]);
        }
    } failure:^(NSError *error) {
        failBlock(NO,@"");
    }];
}
/** 获取验证码 */
- (void)startCodeAFWorkingWith:(NSString *)phoneNum withCountryNum:(NSString *)countryNum{

    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum zone:countryNum result:^(NSError *error) {
        
        if (!error)
        {
            //NSLog(@"%@",error);
            NSLog(@"验证码请求成功");
        }
        else
        {
            NSLog(@"验证码请求失败：%@",error);
            //NSLog(@"%@",error);
            //            [[RYHUDManager sharedManager] showWithMessage:@"请求失败" customView:nil hideDelay:2.f];
            
        }
    }];
}




@end
