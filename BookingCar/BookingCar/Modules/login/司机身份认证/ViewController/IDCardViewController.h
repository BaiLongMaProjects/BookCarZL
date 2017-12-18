//
//  IDCardViewController.h
//  BookingCar
//
//  Created by mac on 2017/9/5.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface IDCardViewController : BaseController
@property (weak, nonatomic) IBOutlet UITextField *TextfieldCarID;//驾驶证号
@property (weak, nonatomic) IBOutlet UIButton *ButCarIDPhoto;//驾驶证正面照
@property (weak, nonatomic) IBOutlet UIView *ViewCarID;//驾驶证View
@property (weak, nonatomic) IBOutlet UIView *ViewPolicy;//保险单号View
@property (weak, nonatomic) IBOutlet UITextField *TextfieldPolicy;//保险单号
@property (weak, nonatomic) IBOutlet UIButton *ButPolicy;//上传保险单号按钮
@property (weak, nonatomic) IBOutlet UIButton *ButNext;//下一步
@property (weak, nonatomic) IBOutlet UIImageView *ImgCarID;//驾驶证照片
@property (weak, nonatomic) IBOutlet UIImageView *ImgPolicy;//保险单号

@property (nonatomic, copy) NSString *jiaShiZhengImageURL;
@property (nonatomic, copy) NSString *baoXianDanImageURL;



@end
