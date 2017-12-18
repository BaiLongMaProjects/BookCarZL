//
//  OtherOshowViewController.h
//  BookingCar
//
//  Created by mac on 2017/9/13.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearDetailModel.h"
#import <MWPhotoBrowser.h>  //图片浏览器
#import "ZJImageViewBrowser.h"
@interface OtherOshowViewController : UIViewController<MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *currentPhotoArray;
-(instancetype)initWithDataModel:(NearDetailModel *)NearModel;
@end
