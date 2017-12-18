//
//  OShowTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OShowTableViewCell.h"
#import "OShowBigPhotoScrView.h"
@implementation OShowTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
       

    }
    
    return self;
}
#pragma mark -UICollectionView 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //cell个数,根据model,点击添加,增加一条数据
    // 添加cell和普通cell的大小都一样,只是显示的内容不一样.  初始化,只放置一个,当增加了数据,就把这个往后排.  collectionView具有自动的往前/后移动的效果.
    return self.attatcheArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //从重用队列获取
    //这里,不定时崩溃  indexPath.item 貌似不能为0
    UINib * nib = [UINib nibWithNibName:@"AttachePhotoCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"reuseId"];
    
    self.attachePhotoCollectionCell = [[AttachePhotoCollectionViewCell alloc]init];
    
    self.attachePhotoCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseId" forIndexPath:indexPath];
    
        if (self.attatcheArray.count > 0) {
            AttacheOShowPhoto *model=self.attatcheArray[indexPath.item];
            [self.attachePhotoCollectionCell getInfo:model];
        }
    return _attachePhotoCollectionCell;
}

//设置每个Cell 的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (self.attatcheArray.count) {
        case 0:
            break;
        case 1:
            return CGSizeMake(260*D_width, 160*D_height);
            break;
        case 2:
            return CGSizeMake(120*D_width, 170*D_height);
            break;
        case 3:
            return CGSizeMake(80*D_width, 80*D_height);
            break;
        case 4:
            return CGSizeMake(85*D_width, 85*D_height);
            break;
        default:
            break;
    }
       return CGSizeMake(80*D_width, 80*D_height);
}
//设置Cell 之间的间距 （上，左，下，右）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (self.attatcheArray.count) {
        case 2:
            return UIEdgeInsetsMake(0, 10*D_width, 0, 10*D_height);
            break;
            
        case 4:
            return UIEdgeInsetsMake(0, 50*D_width, 0, 50*D_height);
            break;
        default:

            break;
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld,%ld",self.TabbleViewPath.row,(long)indexPath.row);
    AttacheOShowPhoto *model=self.attatcheArray[indexPath.item];
    NSLog(@"%@",model.attache);
    if (self.delegate && [self.delegate respondsToSelector:@selector(OShowPhotoImageClick:)]) {
          [self.delegate OShowPhotoImageClick:model.attache];
    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    MAXFLOAT
}
-(void)getInfo:(OShowModel *)Mo andIndexPath:(NSIndexPath *)index
{
    self.TabbleViewPath = index;
    
    self.attatcheArray = [[NSMutableArray alloc]init];

    //创建collectionView
    [self CreatCollectionView];

    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", Mo.ip]] placeholderImage:[UIImage imageNamed:@"My_Header"]];
    self.LabName.text = Mo.point;
    self.LabMessage.text = Mo.message;
    self.LabPoint.text = [NSString stringWithFormat:@"%@·%@·%@",Mo.country,Mo.province,Mo.city];
    self.LabLove.text = Mo.love;
    self.LabComments.text = [NSString stringWithFormat:@"%lu",(unsigned long)Mo.comments.count];
    self.LabTime.text = Mo.create_time;
    
    for (NSDictionary * dic in Mo.attache) {
        AttacheOShowPhoto *model = [[AttacheOShowPhoto alloc]initWithRYDict:dic];

        if ([model.attache isEqualToString:@"null"]) {
            self.ViewImage.hidden = YES;

        }
        [self.attatcheArray addObject:model];
    }
    
    if (Mo.attache.count == 0) {
        self.ViewImage.hidden = YES;
    }
    
    [self.ViewImage setFrame:CGRectMake(66*D_width, 62*D_height, 275*D_width, 350*D_height)];
    self.ViewImage.backgroundColor = [UIColor whiteColor];
    [self.ViewImage addSubview:self.AttachePhotoCollectionView];
    
    if ([Mo.status isEqualToString:@"999"]) {
        [self.ImgLove setImage:[UIImage imageNamed:@"OShow_Love"]];
    }else
    {
        [self.ImgLove setImage:[UIImage imageNamed:@"unlike"]];
    }

}
-(void)CreatCollectionView{
    //这一块,是要做自动布局的
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(275*D_width, 200);
    //设置cell之间的横向间距
    layout.minimumInteritemSpacing = 2.5; //通过这个,控制几列!!    20: 以5s这种小的为准,先显示出来
    
    //设置cell之间的纵向间距
    layout.minimumLineSpacing = 2.5*D_height;
    _AttachePhotoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 275*D_width, 350*D_height) collectionViewLayout:layout];
    _AttachePhotoCollectionView.delegate=self;
    _AttachePhotoCollectionView.dataSource=self;
    _AttachePhotoCollectionView.backgroundColor=[UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
