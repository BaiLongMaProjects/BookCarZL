//
//  VehicleInforViewController.m
//  BookingCar
//
//  Created by mac on 2017/9/5.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "VehicleInforViewController.h"
#import "MainTabViewController.h"
@interface VehicleInforViewController ()
{
    UIImage * Image;//储存头像的部分
}
@end

@implementation VehicleInforViewController
//正面照
-(void)requsetCarPic1
{
    NSData * imageData;
    
    if (UIImagePNGRepresentation(Image) == nil) {
        imageData = UIImageJPEGRepresentation(Image, 0.1);
    }else
    {
        imageData = UIImagePNGRepresentation(Image);
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    
    NSArray * array = [NSArray arrayWithObject:Image];
    
    [HttpTool postWithPath:kUploadCarPic1 name:@"img" imagePathList:array params:params success:^(id responseObj) {
        NSLog(@"正面照%@",responseObj);
        [SVProgressHUD dismiss];
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        infor.car_pic1 = responseObj[@"result"][@"url"];
        [[LoginDataModel sharedManager]saveLoginMemberData:infor];
        self.cheZhengViewURL = responseObj[@"result"][@"url"];
    } failure:^(NSError *error) {
        NSLog(@"上传失败  == %@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [SVProgressHUD dismiss];
    }];

}
//反面照
-(void)requsetCarPic2
{
    NSData * imageData;
    
    if (UIImagePNGRepresentation(Image) == nil) {
        imageData = UIImageJPEGRepresentation(Image, 0.1);
    }else
    {
        imageData = UIImagePNGRepresentation(Image);
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    
    NSArray * array = [NSArray arrayWithObject:Image];
    
    [HttpTool postWithPath:kUploadCarPic2 name:@"img" imagePathList:array params:params success:^(id responseObj) {
        NSLog(@"反面照：%@",responseObj);
        [self dismissLoading];
        InforModel * infor = [[InforModel alloc]init];
        infor = [LoginDataModel sharedManager].inforModel;
        infor.car_pic2 = responseObj[@"result"][@"url"];
        [[LoginDataModel sharedManager]saveLoginMemberData:infor];
        self.cheFanViewURL = responseObj[@"result"][@"url"];
    } failure:^(NSError *error) {
        NSLog(@"上传失败  == %@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [self dismissLoading];
    }];

}
-(void)requsetUpdataCar
{
    LoginModel * login =[[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    InforModel * info = [[InforModel alloc]init];
    info = [LoginDataModel sharedManager].inforModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:self.jiaShiURL forKey:@"driver_pic1"];
    [params setValue:self.baoXIanURL forKey:@"driver_pic2"];
    [params setValue:self.TextCarNumber.text forKey:@"plate_num"];
    [params setValue:self.TextBrand.text forKey:@"model"];//车型
    [params setValue:self.cheZhengViewURL forKey:@"car_pic1"];
    [params setValue:self.cheFanViewURL forKey:@"car_pic2"];
    [params setValue:self.PolicyText forKey:@"secure_num"];//保险单号
    //[params setValue:@"" forKey:@"identify_num"];//身份证号
    [params setValue:self.CardIDText forKey:@"driver_num"];//驾驶证号

    [HttpTool postWithPath:kdriverVerifySubmit params:params success:^(id responseObj) {
        NSLog(@"提交认证%@",responseObj);
        MainTabViewController * main = [[MainTabViewController alloc]initWithNibName:@"BookController" bundle:[NSBundle mainBundle]];
        [main setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:main animated:YES completion:^{
            NSLog(@"跳转");
        }];
    } failure:^(NSError *error) {
        NSLog(@"提交认证上 == %@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    //键盘设置
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘一建回收
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车辆信息";
    [self.TextBrand.layer setMasksToBounds:YES];
    [self.TextBrand.layer setCornerRadius:4];
    [self.TextCarNumber.layer setMasksToBounds:YES];
    [self.TextCarNumber.layer setCornerRadius:4];
    [self.ButSure.layer setBorderWidth:1];
    [self.ButSure.layer setMasksToBounds:YES];
    [self.ButSure.layer setCornerRadius:4];
    [self.ButPositivePhoto addTarget:self action:@selector(ButPositivePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButReversePhoto addTarget:self action:@selector(ButReversePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButSure addTarget:self action:@selector(ButSureClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.ImgaCarPic1.contentMode = UIViewContentModeScaleAspectFill;
    self.ImgaCarPic1.clipsToBounds = YES;
    self.ImgaCarPic2.contentMode = UIViewContentModeScaleAspectFill;
    self.ImgaCarPic2.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}
//上传车辆正面照片
-(void)ButPositivePhotoClick{
//    [CCHeadImagePicker showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
//        if (image) {
//            [self.ImgaCarPic1 setImage:image];
//            NSLog(@"%@",image);
//            Image = image;
//            [self requsetCarPic1];
//            [SVProgressHUD show];
//        }
//    }];
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.ImgaCarPic1 setImage:image];
            NSLog(@"%@",image);
            Image = image;
            [self requsetCarPic1];
            [self showLoading];
            
            
        }
    }];
}
//上传车辆反面照片
-(void)ButReversePhotoClick
{
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.ImgaCarPic2 setImage:image];
            NSLog(@"%@",image);
            Image = image;
            [self requsetCarPic2];
            [self showLoading];
        }
    }];
}
//确定
-(void)ButSureClick
{
    if (self.TextBrand.text.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入车辆品牌" customView:nil hideDelay:2.f];
        return;
    }
    if (self.TextCarNumber.text.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"请输入车辆型号" customView:nil hideDelay:2.f];
        return;
    }
    if (self.cheZhengViewURL.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"别忘记正面照哦" customView:nil hideDelay:2.f];
        return;
    }
    if (self.cheFanViewURL.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"还有反面照哦" customView:nil hideDelay:2.f];
        return;
    }
    [self requsetUpdataCar];
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
