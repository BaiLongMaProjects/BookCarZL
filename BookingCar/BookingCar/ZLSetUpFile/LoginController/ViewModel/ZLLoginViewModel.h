//
//  ZLLoginViewModel.h
//  BookingCar
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLLoginViewModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *code;

+ (ZLLoginViewModel *)shareInstance;
/** 登录请求 */
- (void)startLoginAFNetworkingWith:(NSString *)userName withCode:(NSString *)code withCountryNum:(NSString *)countryNum withSuccessBlock:(void (^)(BOOL success,int active,int mark,int checkType))successBlock withFailBlock:(void (^)(BOOL fail,NSString *message))failBlock;
/** 注册请求 暂时不用*/
- (void)startRegisterAFWorkingWith:(NSString *)userName withPassword:(NSString *)password withCode:(NSString *)code withNickName:(NSString *)nickName;
/** 获取验证码 */
- (void)startCodeAFWorkingWith:(NSString *)phoneNum withCountryNum:(NSString *)countryNum;
/** <#属性注释#> */


@end
