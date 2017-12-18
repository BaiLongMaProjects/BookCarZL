//
//  OShowBigPhotoScrView.h
//  BookingCar
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OShowBigPhotoScrView : UIView<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *innerView;

@property (nonatomic, weak)UIViewController *parentVC;

@property (weak, nonatomic) IBOutlet UIImageView *ImageOShowBigPhoto;//图片放大

@property (weak, nonatomic) IBOutlet UIButton *ButBackImage;//图片变小

+ (instancetype)defaultPopupView;

@end
