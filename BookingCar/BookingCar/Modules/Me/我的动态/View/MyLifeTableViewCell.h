//
//  MyLifeTableViewCell.h
//  BookingCar
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OShowModel.h"
#import "AttachePhotoCollectionViewCell.h"

typedef void(^ClickImageCellBlock)(NSIndexPath *currentIndexPath);

@interface MyLifeTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *LabDateTime;//时间
@property (weak, nonatomic) IBOutlet UIView *ViewImage;//背景图
@property (weak, nonatomic) IBOutlet UILabel *LabMessage;//发布的文字
@property (weak, nonatomic) IBOutlet UILabel *LabPhotoNumber;//照片个数
@property (weak, nonatomic) IBOutlet UILabel *LabLoction;//地点
@property (nonatomic, strong)UICollectionView * AttachePhotoCollectionView;//照片展示样式
@property (nonatomic, strong)AttachePhotoCollectionViewCell * attachePhotoCollectionCell;//自定义照片Cell
@property (nonatomic, strong)NSMutableArray * attatcheArray;//照片数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstraintMessageC;//线长
@property (nonatomic, copy) ClickImageCellBlock clickBlock;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

- (void)getInfo:(OShowModel *)Model;
- (void)setClickBlockAction:(ClickImageCellBlock )block;

@end
