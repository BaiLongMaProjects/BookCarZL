//
//  HomePageTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/8/7.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearDetailModel.h"
@interface HomePageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgBackground;//背景图片

@property (weak, nonatomic) IBOutlet UILabel *LabTown;//家乡

@property (weak, nonatomic) IBOutlet UIImageView *ImgHead;//头像

@property (weak, nonatomic) IBOutlet UIImageView *ImgGender;//性别

@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UILabel *LabBelongs;//所属地

@property (weak, nonatomic) IBOutlet UILabel *LabLoveNum;//点赞数

@property (weak, nonatomic) IBOutlet UIButton *ButLove;//红心按钮

@property (weak, nonatomic) IBOutlet UIButton *ButLoveClick;//点赞按钮


-(void)getInfo:(NearDetailModel *)Model;

@end
