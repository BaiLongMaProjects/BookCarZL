//
//  DriverZiLiaoViewModel.m
//  BookingCar
//
//  Created by apple on 2017/11/29.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "DriverZiLiaoViewModel.h"

@implementation DriverZiLiaoViewModel

+ (DriverZiLiaoViewModel *)shareInstance{
    static DriverZiLiaoViewModel * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
/** 上传照片到七牛云 */
- (void)startUploadImageWithType:(NSInteger)type withImage:(UIImage *)image withSuccessBlock:(void (^)(BOOL, NSString *))successBlock withFailBlock:(void (^)(BOOL))failureBlock{
    /** 0 驾驶证正面照  1 保险单号  2 车辆正面照  3 车辆反面照片 */
    NSString * url = nil;
    switch (type) {
        case 0:{
            url = kUploaddriverPic1;
        }
            break;
        case 1:{
            url = kUploaddriverPic2;
        }
            break;
        case 2:{
            url = kUploadCarPic1;
        }
            break;
        case 3:{
            url = kUploadCarPic2;
        }
            break;
        default:
            break;
    }
    NSData * imageData = nil;
    
    if (UIImagePNGRepresentation(image) == nil) {
        imageData = UIImageJPEGRepresentation(image, 0.1);
    }else
    {
        imageData = UIImagePNGRepresentation(image);
    }
    NSMutableDictionary * params = [NSMutableDictionary new];
    
    NSArray * array = [NSArray arrayWithObject:image];
    
    [HttpTool postWithPath:url name:@"img" imagePathList:array params:params success:^(id responseObj) {
        NSLog(@"上传照片到七牛云：%@",responseObj);
        if ([responseObj[@"code"] intValue] == 0) {
            //[SVProgressHUD dismiss];
            InforModel * infor = [LoginDataModel sharedManager].inforModel;
            switch (type) {
                case 0:{
                    infor.driver_pic1 = responseObj[@"result"][@"url"];
                    self.jiaShiZhengImageUrl = responseObj[@"result"][@"url"];
                }
                    break;
                case 1:{
                    infor.driver_pic2 = responseObj[@"result"][@"url"];
                    self.baoXianDanImageUrl = responseObj[@"result"][@"url"];
                }
                    break;
                case 2:{
                    infor.car_pic1 = responseObj[@"result"][@"url"];
                    self.cheLiangZhengImageUrl = responseObj[@"result"][@"url"];
                }
                    break;
                case 3:{
                    infor.car_pic2 = responseObj[@"result"][@"url"];
                    self.cheLiangBeiImageUrl = responseObj[@"result"][@"url"];
                }
                    break;
                default:
                    break;
            }
            [[LoginDataModel sharedManager]saveLoginMemberData:infor];
            
            if (successBlock) {
                successBlock(YES,responseObj[@"result"][@"url"]);
            }
        }
        else{
            failureBlock(YES);
        }
    } failure:^(NSError *error) {
        failureBlock(NO);
        [[RYHUDManager sharedManager] showWithMessage:@"网络连接失败" customView:nil hideDelay:2.f];
        [SVProgressHUD dismiss];
    }];
}
/** 提交资料到服务器 */
- (void)startNetworkZiLiaoWithSuccessBlock:(void (^)(BOOL))successBlock withFailBlock:(void (^)(BOOL))failureBlock{
    LoginModel * login =[[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:self.jiaShiZhengImageUrl forKey:@"driver_pic1"];
    [params setValue:self.baoXianDanImageUrl forKey:@"driver_pic2"];
    [params setValue:self.chePaiString forKey:@"plate_num"];
    [params setValue:self.cheModelString forKey:@"model"];//车型
    [params setValue:self.cheLiangZhengImageUrl forKey:@"car_pic1"];
    [params setValue:self.cheLiangBeiImageUrl forKey:@"car_pic2"];
    [params setValue:self.baoXianDanString forKey:@"secure_num"];//保险单号
    //[params setValue:@"" forKey:@"identify_num"];//身份证号
    [params setValue:self.jiaShiZhengString forKey:@"driver_num"];//驾驶证号
    
    [HttpTool postWithPath:kdriverVerifySubmit params:params success:^(id responseObj) {
        NSLog(@"提交认证%@",responseObj);
        
//        MainTabViewController * main = [[MainTabViewController alloc]initWithNibName:@"BookController" bundle:[NSBundle mainBundle]];
//        [main setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//        [self presentViewController:main animated:YES completion:^{
//            NSLog(@"跳转");
//        }];
        if ([responseObj[@"status"] intValue] == 1) {
            successBlock(YES);
        }
    } failure:^(NSError *error) {
        failureBlock(YES);
        NSLog(@"提交认证上 == %@",error);
        [[RYHUDManager sharedManager] showWithMessage:@"网络连接失败" customView:nil hideDelay:2.f];
    }];
}

@end
