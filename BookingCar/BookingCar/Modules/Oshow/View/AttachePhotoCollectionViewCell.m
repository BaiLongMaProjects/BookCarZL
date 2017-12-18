//
//  AttachePhotoCollectionViewCell.m
//  BookingCar
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "AttachePhotoCollectionViewCell.h"

@implementation AttachePhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _ImgAttachePhoto.contentMode = UIViewContentModeScaleAspectFill;
    _ImgAttachePhoto.clipsToBounds = YES;
    // Initialization code
}
-(void)getInfo:(AttacheOShowPhoto *)Mo
{
    [_ImgAttachePhoto sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@",Mo.attache]] placeholderImage:[UIImage imageNamed:@"My_Header"]];
    
    
}
@end
