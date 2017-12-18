//
//  PerNewPasswordViewController.h
//  RootDirectory
//
//  Created by 李东晓 on 16/8/8.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "BaseController.h"
@interface PerNewPasswordViewController :BaseController
@property (strong, nonatomic) IBOutlet UIButton *ButSure;//确定按钮

@property (strong, nonatomic) IBOutlet UILabel *LabPhoneNum;//电话号码

@property (strong, nonatomic) IBOutlet UITextField *TextAuthcode;//验证码填写

@property (strong, nonatomic) IBOutlet UITextField *TextNewPassword;//密码填写

@property (strong, nonatomic) IBOutlet UIButton *ButGainCode;//获取验证码

@end
