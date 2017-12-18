//
//  PersonCenterTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/7/2.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *PersonCenterLab;//名称
@property (weak, nonatomic) IBOutlet UILabel *LabPerDetail;//个人信息详细
@property (strong, nonatomic) IBOutlet UIImageView *rightImage;

@end
