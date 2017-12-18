//
//  CommentsView.h
//  BookingCar
//
//  Created by mac on 2017/9/13.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadyGoModel.h"
@interface CommentsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ImgHead;//头像

@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UILabel *LabStatus;//评论状态

@property (weak, nonatomic) IBOutlet UIButton *ButStart1;
@property (weak, nonatomic) IBOutlet UIButton *ButStart2;
@property (weak, nonatomic) IBOutlet UIButton *ButStart3;
@property (weak, nonatomic) IBOutlet UIButton *ButStart4;
@property (weak, nonatomic) IBOutlet UIButton *ButStart5;

@property (weak, nonatomic) IBOutlet UIButton *ButSure;//完成

@property (weak, nonatomic) IBOutlet UIButton *ButTag1;
@property (weak, nonatomic) IBOutlet UIButton *ButTag2;
@property (weak, nonatomic) IBOutlet UIButton *ButTag3;
@property (weak, nonatomic) IBOutlet UIButton *ButTag4;
@property (weak, nonatomic) IBOutlet UIButton *ButTag5;
@property (weak, nonatomic) IBOutlet UIButton *ButTag6;
@property (weak, nonatomic) IBOutlet UIButton *ButTag7;
@property (weak, nonatomic) IBOutlet UIButton *ButTag8;

@property (weak, nonatomic) IBOutlet UITextView *CommentTextView;//编辑



-(void)getInfo:(ReadyGoModel *)readyGoModel;
@end
