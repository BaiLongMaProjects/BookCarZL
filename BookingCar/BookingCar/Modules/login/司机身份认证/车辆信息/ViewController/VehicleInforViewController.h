//
//  VehicleInforViewController.h
//  BookingCar
//
//  Created by mac on 2017/9/5.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface VehicleInforViewController : BaseController

@property (nonatomic, copy)NSString * CardIDText;//驾驶证号
@property (nonatomic, copy)NSString * PolicyText;//保险单号
@property (nonatomic, copy) NSString *jiaShiURL;
@property (nonatomic, copy) NSString *baoXIanURL;
@property (nonatomic, copy) NSString *cheZhengViewURL;
@property (nonatomic, copy) NSString *cheFanViewURL;


@property (weak, nonatomic) IBOutlet UITextField *TextBrand;//车辆品牌
@property (weak, nonatomic) IBOutlet UITextField *TextCarNumber;//车牌号

@property (weak, nonatomic) IBOutlet UIImageView *ImgaCarPic1;//车辆正面照
@property (weak, nonatomic) IBOutlet UIImageView *ImgaCarPic2;//车辆背面照
@property (weak, nonatomic) IBOutlet UIButton *ButPositivePhoto;//正面照片按钮
@property (weak, nonatomic) IBOutlet UIButton *ButReversePhoto;//反面照片按钮
@property (weak, nonatomic) IBOutlet UIButton *ButSure;//确定按钮




@end
