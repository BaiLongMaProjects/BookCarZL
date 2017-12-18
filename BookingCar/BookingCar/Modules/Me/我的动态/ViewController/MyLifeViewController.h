//
//  MyLifeViewController.h
//  BookingCar
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "BaseController.h"
#import <MWPhotoBrowser.h>  //图片浏览器
#import "ZLPhotoScaleManager.h"
#import "ZJImageViewBrowser.h"
@interface MyLifeViewController : BaseController<UIGestureRecognizerDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *currentPhotoArray;

@end
