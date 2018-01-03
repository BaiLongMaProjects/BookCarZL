//
//  CreatMeView.h
//  BookingCar
//
//  Created by mac on 2017/6/30.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatMeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *LabNiceName;//名称

@property (weak, nonatomic) IBOutlet UILabel *LabRole;//我的角色

@property (weak, nonatomic) IBOutlet UIButton *PersonCenterButton;//个人中心
@property (weak, nonatomic) IBOutlet UIButton *ButMyLife;//我的动态
@property (weak, nonatomic) IBOutlet UIButton *ButSwichRole;//切换角色
@property (weak, nonatomic) IBOutlet UIButton *ButSwichLogin;//切换账号
@property (weak, nonatomic) IBOutlet UIButton *ButIssueTrip;//发布行程
@property (weak, nonatomic) IBOutlet UIButton *ButWithMe;//关于我们
@property (weak, nonatomic) IBOutlet UIButton *ButOffer;//投诉建议

/** 清除缓存 */
@property (strong, nonatomic) IBOutlet UIButton *clearButton;


@property (strong, nonatomic) IBOutlet UIButton *headerButton;
@property (strong, nonatomic) IBOutlet UIView *headerBackShadowView;
@property (strong, nonatomic) IBOutlet UIImageView *backHeadImageVIew;

@property (strong, nonatomic) IBOutlet UIControl *dongTaiControl;
@property (strong, nonatomic) IBOutlet UIControl *xingChengControl;
@property (strong, nonatomic) IBOutlet UIControl *faBuControl;





@end
