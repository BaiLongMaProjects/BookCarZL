//
//  OShowDetailTableViewCell.h
//  BookingCar
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OShowModel.h"
#import "CommentsModel.h"
#import "AttacheOShowPhoto.h"
#import "ZLComentTableViewCell.h"

#import "UITableView+FDTemplateLayoutCell.h"

@class OShowDetailTableViewCell;

@protocol OShowDetailTableViewCellDelegate <NSObject>

/**
 *==========ZL注释start===========
 *1.图片浏览框架 MWPhotoBrowser
 *
 *2.MWPhotoBrowser.h
 *3.传入UIImageView数组或者image的URL数组
 ===========ZL注释end==========*/
- (void)oShowDetailTableViewCell:(OShowDetailTableViewCell *)cell withCurrentImage:(NSString *) currentImageURL withImageArray:(NSMutableArray *)imageArray withIndexPath:(NSIndexPath *)indexPath withCurrenImageIndex:(NSInteger )currentIndex;

/**
 *==========ZL注释start===========
 *1.图片浏览器  ZJImageViewBrowser
 *
 *2.ZJImageViewBrowser
 *3.传入当前UIImageVIew和UIImageView的数组和父视图
 ===========ZL注释end==========*/
-(void)didClickImageViewWithCurrentView:(UIImageView *)imageView imageViewArray:(NSMutableArray *)array imageSuperView:(UIView *)view indexPath:(NSIndexPath *)indexPath;

/**
 *==========ZL注释start===========
 *1.点击评论按钮
 *
 *2.当前 indexPath
 *3.<#注释描述#>
 *4.<#注释描述#>
 ===========ZL注释end==========*/
- (void)didClickCommentBtnWithIndexPath:(NSIndexPath *)indexPath;

/**
 *==========ZL注释start===========
 *1.点赞
 *
 *2.当前indexPath
 *3.<#注释描述#>
 *4.<#注释描述#>
 ===========ZL注释end==========*/
- (void)didClickLoveBtnWithIndexPath:(NSIndexPath *)indexPath;

/**
 *==========ZL注释start===========
 *1.点击某一行回复
 *
 *2.<#注释描述#>
 *3.<#注释描述#>
 *4.<#注释描述#>
 ===========ZL注释end==========*/
- (void)didClickRowWithFirstIndexPath:(NSIndexPath *)firIndexPath secondIndex:(NSIndexPath *)secIndexPath;

/**
 *==========ZL注释start===========
 *1.举报
 *
 *2.<#注释描述#>
 *3.<#注释描述#>
 *4.<#注释描述#>
 ===========ZL注释end==========*/
- (void)juBaoButtonActionWithIndexPath:(NSIndexPath *)indexPath;

/**
 *==========ZL注释start===========
 *1.点击头像按钮
 *
 *2.<#注释描述#>
 *3.<#注释描述#>
 *4.<#注释描述#>
 ===========ZL注释end==========*/
- (void)touXiangButtonActionWithIndexPath:(NSIndexPath *)indexPath;



@end


@interface OShowDetailTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

#pragma mark ===================UI属性 START==================
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *zanLabel;
@property (strong, nonatomic) IBOutlet UIButton *zanButton;
@property (strong, nonatomic) IBOutlet UILabel *pingNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *pingButton;
@property (strong, nonatomic) IBOutlet UITableView *pingTableView;

#pragma mark ===================UI属性 END==================
#pragma mark ===================约束 START==================

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pingTableviewHeight;

#pragma mark ===================约束 END==================

@property (nonatomic, strong) NSMutableArray<AttacheOShowPhoto *> *collectionImageArray;
@property (nonatomic, strong) NSMutableArray<CommentsModel *> *pingLunArray;
@property (nonatomic, strong) OShowModel *currentModel;
@property (nonatomic, weak) id<OShowDetailTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *currentCellIndexPath;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;

@property (nonatomic, assign) double comentTableViewHeight;

@property (strong, nonatomic) IBOutlet UIButton *juBaoButton;
@property (strong, nonatomic) IBOutlet UIButton *touXiangButton;



/**
 *==========ZL注释start===========
 *1.绑定数据
 *
 *2.OShowModel
 *3.
 *4.
 ===========ZL注释end==========*/
- (void)bindDataModel:(OShowModel *)model withIndexPath:(NSIndexPath *)indexPath;

@end
