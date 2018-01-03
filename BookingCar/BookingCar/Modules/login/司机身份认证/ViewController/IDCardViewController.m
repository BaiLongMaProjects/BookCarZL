//
//  IDCardViewController.m
//  BookingCar
//
//  Created by mac on 2017/9/5.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "IDCardViewController.h"
#import "VehicleInforViewController.h"//车辆信息
@interface IDCardViewController ()
{
    UIImage * Image;//储存头像的部分
}
@end

@implementation IDCardViewController
//上传正面照照片
-(void)requsetdriverPic1
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
    
    [HttpTool postWithPath:kUploaddriverPic1 name:@"img" imagePathList:array params:params success:^(id responseObj) {
        NSLog(@"上传驾驶证号好：%@",responseObj);
        [self dismissLoading];
        //InforModel * infor = [[InforModel alloc]init];
        InforModel * infor = [LoginDataModel sharedManager].inforModel;
        infor.driver_pic1 = responseObj[@"result"][@"url"];
        self.jiaShiZhengImageURL = responseObj[@"result"][@"url"];
        [[LoginDataModel sharedManager]saveLoginMemberData:infor];
    } failure:^(NSError *error) {
        NSLog(@"上传失败  == %@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        [self dismissLoading];
    }];

}
//上传保险单号
-(void)requsetdriverPic2
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
    
    [HttpTool postWithPath:kUploaddriverPic2 name:@"img" imagePathList:array params:params success:^(id responseObj) {
        NSLog(@"上传保险单号：%@",responseObj);
        [self dismissLoading];
        //InforModel * infor = [[InforModel alloc]init];
        InforModel *infor = [LoginDataModel sharedManager].inforModel;
        infor.driver_pic2 = responseObj[@"result"][@"url"];
        self.baoXianDanImageURL = responseObj[@"result"][@"url"];
        [[LoginDataModel sharedManager]saveLoginMemberData:infor];
    } failure:^(NSError *error) {
        NSLog(@"上传失败  == %@",error);
        [self dismissLoading];
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.tabBarController.tabBar setHidden:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    [self.ViewCarID.layer setMasksToBounds:YES];
    [self.ViewCarID.layer setCornerRadius:4];
    [self.ViewCarID setFrame:CGRectMake(16*D_width, 70*D_height, 343*D_width, 200*D_height)];
    [self.ButCarIDPhoto setFrame:CGRectMake(14 * D_width, 48 * D_height, 314*D_width, 150*D_height)];
    [self.ViewPolicy.layer setMasksToBounds:YES];
    [self.ViewPolicy.layer setCornerRadius:4];
    [self.ViewPolicy setFrame:CGRectMake(16 * D_width, 283 * D_height, 343 * D_width, 200 * D_height)];
    [self.ButPolicy setFrame:CGRectMake(14 * D_width, 48 * D_height, 314 * D_width, 150 * D_height)];
    [self.ButNext.layer setCornerRadius:4];
    [self.ButNext.layer setMasksToBounds:YES];
    [self.ButNext.layer setBorderWidth:1];
//    [self.TextfieldCarID.layer setMasksToBounds:YES];
//    [self.TextfieldCarID.layer setCornerRadius:4];
//    [self.TextfieldPolicy.layer setMasksToBounds:YES];
//    [self.TextfieldPolicy.layer setCornerRadius:4];
    
    [self.ButCarIDPhoto addTarget:self action:@selector(ButCarIDPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButPolicy addTarget:self action:@selector(ButPolicyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButNext addTarget:self action:@selector(ButNextClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.ImgCarID.contentMode = UIViewContentModeScaleAspectFill;
    self.ImgCarID.clipsToBounds = YES;
    self.ImgPolicy.contentMode = UIViewContentModeScaleAspectFill;
    self.ImgPolicy.clipsToBounds = YES;
}
//上传驾驶证照片
-(void)ButCarIDPhotoClick{
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.ImgCarID setImage:image];
            Image = image;
            [self showLoading];
            [self requsetdriverPic1];
        }
    }];
}
//上传保险单号照片
-(void)ButPolicyClick{
//    [CCHeadImagePicker showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
//        if (image) {
//            [self.ImgPolicy setImage:image];
//            Image = image;
//            [self requsetdriverPic2];
//            [SVProgressHUD show];
//        }
//    }];
    [ZLPhotoScaleManager showHeadImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            [self.ImgPolicy setImage:image];
            Image = image;
            [self showLoading];
            [self requsetdriverPic2];
            
        }
    }];
}

-(void)ButNextClick{
    
    //InforModel * infor = [[InforModel alloc]init];
    //InforModel * infor = [LoginDataModel sharedManager].inforModel;
    //NSLog(@"驾驶证号：%@---保险单号：%@",infor.driver_pic1,infor.driver_pic2);
    if (self.TextfieldPolicy.text.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的保险单号" customView:nil hideDelay:2.f];
        return;
    }
    if (self.TextfieldCarID.text.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的驾驶证号" customView:nil hideDelay:2.f];
        return;
    }
    if (self.jiaShiZhengImageURL.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的驾驶证正面照片" customView:nil hideDelay:2.f];
        return;
    }
    if (self.baoXianDanImageURL.length == 0) {
        [[RYHUDManager sharedManager] showWithMessage:@"请填写您的保险单号正面照片" customView:nil hideDelay:2.f];
        return;
    }
    VehicleInforViewController * vehic = [[VehicleInforViewController alloc]init];
    vehic.CardIDText = self.TextfieldCarID.text;
    vehic.PolicyText = self.TextfieldPolicy.text;
    vehic.jiaShiURL = self.jiaShiZhengImageURL;
    vehic.baoXIanURL = self.baoXianDanImageURL;
    [self.navigationController pushViewController:vehic animated:YES];
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
