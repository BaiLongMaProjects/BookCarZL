//
//  MyLifeHeadView.h
//  BookingCar
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLifeHeadModel.h"
@interface MyLifeHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *ButBack;//返回按钮
@property (weak, nonatomic) IBOutlet UIImageView *ImgBigPhoto;//大图
@property (weak, nonatomic) IBOutlet UIImageView *ImgHeadPhoto;//点击了头像
@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UILabel *LabTown;//家乡
@property (weak, nonatomic) IBOutlet UILabel *LabJob;//职业
@property (weak, nonatomic) IBOutlet UILabel *LabBelongs;//所属地
@property (weak, nonatomic) IBOutlet UILabel *LabSingleNum;//成单量
@property (weak, nonatomic) IBOutlet UILabel *LabComments;//评价数
@property (weak, nonatomic) IBOutlet UILabel *LabLoveNum;//点赞数

-(void)getInfo:(MyLifeHeadModel *)Model;


@end
