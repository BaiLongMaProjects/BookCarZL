//
//  BigPhotoView.h
//  BookingCar
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigPhotoView : UIView

@property (strong, nonatomic) IBOutlet UIView *innerView;

@property (nonatomic, weak)UIViewController *parentVC;
@property (weak, nonatomic) IBOutlet UIImageView *ImgPhotoHead;//头像


+ (instancetype)defaultPopupView;

@end
