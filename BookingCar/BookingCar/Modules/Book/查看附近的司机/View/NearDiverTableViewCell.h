//
//  NearDiverTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearDetailModel.h"
@interface NearDiverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *ButPickMe;//请他来接
@property (weak, nonatomic) IBOutlet UIButton *ButtonLove;//点赞
@property (weak, nonatomic) IBOutlet UIImageView *LabImgHeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UILabel *LabTown;//家乡
@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UIImageView *ImgGender;//性别
@property (weak, nonatomic) IBOutlet UILabel *LabBelongs;//所属地
@property (weak, nonatomic) IBOutlet UIImageView *ImgBackgroud;//背景图片
@property (weak, nonatomic) IBOutlet UIButton *ButLoveSelect;//红心
@property (weak, nonatomic) IBOutlet UILabel *LabLoveNum;//点赞数




-(void)getInfo:(NearDetailModel *)Model;
@end
