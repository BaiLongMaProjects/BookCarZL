//
//  AttachePhotoCollectionViewCell.h
//  BookingCar
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttacheOShowPhoto.h"
@interface AttachePhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgAttachePhoto;

-(void)getInfo:(AttacheOShowPhoto *)Mo;

@end
