//
//  OShowTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OShowModel.h"
#import "AttachePhotoCollectionViewCell.h"
#import "JJPhotoManeger.h"

@protocol OShowPhotoImageDelegate <NSObject>

-(void)OShowPhotoImageClick:(NSString *)ImageUrl;

@end


@interface OShowTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JJPhotoDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *LabMessage;//显示文字
@property (weak, nonatomic) IBOutlet UIView *ViewImage;//放图片的View
@property (weak, nonatomic) IBOutlet UILabel *LabName;//名字
@property (weak, nonatomic) IBOutlet UILabel *LabPoint;//位置
@property (weak, nonatomic) IBOutlet UILabel *LabLove;//点赞
@property (weak, nonatomic) IBOutlet UILabel *LabComments;//评论
@property (weak, nonatomic) IBOutlet UILabel *LabTime;

@property (weak, nonatomic) IBOutlet UIImageView *ImgLove;//点赞爱心


@property (nonatomic, strong)UICollectionView * AttachePhotoCollectionView;//照片展示样式
@property (nonatomic, strong)AttachePhotoCollectionViewCell * attachePhotoCollectionCell;//自定义照片Cell
@property (nonatomic, strong)NSMutableArray * attatcheArray;//照片数组
@property (nonatomic, strong)NSIndexPath * TabbleViewPath;//行数；
@property (nonatomic, weak)id<OShowPhotoImageDelegate>delegate;

-(void)getInfo:(OShowModel *)Mo andIndexPath:(NSIndexPath *)index;

@end
