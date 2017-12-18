//
//  checkDetailTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkDedatilModel.h"
@interface checkDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageHeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UILabel *LabMessage;//回复内容

-(void)getInfo:(checkDedatilModel *)Model;

@end
