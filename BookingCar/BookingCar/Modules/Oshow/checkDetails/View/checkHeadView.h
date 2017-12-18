//
//  checkHeadView.h
//  BookingCar
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OShowModel.h"
#import "AttachePhotoCollectionViewCell.h"
@protocol OShowPhotoImageDelegate <NSObject>

-(void)OShowPhotoImageClick:(NSString *)ImageUrl;

@end

@interface checkHeadView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *ImageHeadPhoto;//头像
@property (weak, nonatomic) IBOutlet UILabel *LabName;//姓名
@property (weak, nonatomic) IBOutlet UILabel *LabMessage;//文字
@property (weak, nonatomic) IBOutlet UIView *ViewImage;//图片
@property (weak, nonatomic) IBOutlet UILabel *LabLocation;//位置
@property (weak, nonatomic) IBOutlet UILabel *LabCreatTime;//时间
@property (weak, nonatomic) IBOutlet UIButton *ButLove;//点赞
@property (weak, nonatomic) IBOutlet UILabel *LabLove;//点赞数
@property (weak, nonatomic) IBOutlet UIButton *ButComments;//评论
@property (weak, nonatomic) IBOutlet UILabel *LabComments;//评论数

@property (weak, nonatomic) IBOutlet UIImageView *ImageLove;


@property (nonatomic, strong)UICollectionView * AttachePhotoCollectionView;//照片展示样式
@property (nonatomic, strong)AttachePhotoCollectionViewCell * attachePhotoCollectionCell;//自定义照片Cell
@property (nonatomic, strong)NSMutableArray * attatcheArray;//照片数组
@property (nonatomic, strong)NSIndexPath * TabbleViewPath;//行数；
@property (nonatomic, weak)id<OShowPhotoImageDelegate>delegate;


-(void)getInfo:(OShowModel *)Model;

@end
