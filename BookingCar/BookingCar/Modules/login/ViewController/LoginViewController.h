//
//  LoginViewController.h
//  YiGov2
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewControllerDelegate<NSObject>
@end

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *loginButton;


@end
