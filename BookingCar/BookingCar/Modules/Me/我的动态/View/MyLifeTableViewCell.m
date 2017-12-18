//
//  MyLifeTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "MyLifeTableViewCell.h"

@implementation MyLifeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark -UICollectionView 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //cell个数,根据model,点击添加,增加一条数据
    // 添加cell和普通cell的大小都一样,只是显示的内容不一样.  初始化,只放置一个,当增加了数据,就把这个往后排.  collectionView具有自动的往前/后移动的效果.
    if (self.attatcheArray.count >= 4) {
        return 4;
    }
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
            return CGSizeMake(75, 75);
            break;
        case 2:
            return CGSizeMake(35, 75);
            break;
        case 3:
            return CGSizeMake(35, 35);
            break;
        case 4:
            return CGSizeMake(35, 35);
            break;
        default:
            break;
    }
    return CGSizeMake(35, 35);
}

//设置Cell 之间的间距 （上，左，下，右）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.clickBlock(self.currentIndexPath);
}

- (void)setClickBlockAction:(ClickImageCellBlock)block{
    self.clickBlock = block;
}

-(void)CreatCollectionView{
    //这一块,是要做自动布局的
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 75);
    //设置cell之间的横向间距
    layout.minimumInteritemSpacing = 2.5; //通过这个,控制几列!!    20: 以5s这种小的为准,先显示出来
    
    //设置cell之间的纵向间距
    layout.minimumLineSpacing = 2.5;
    _AttachePhotoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 75, 75) collectionViewLayout:layout];
    _AttachePhotoCollectionView.delegate=self;
    _AttachePhotoCollectionView.dataSource=self;
    _AttachePhotoCollectionView.backgroundColor=[UIColor whiteColor];
}

-(void)getInfo:(OShowModel *)Model
{
    //self.LabLoction.text = Model.point;
    //self.LabPhotoNumber.text = [NSString stringWithFormat:@"%lu",(unsigned long)Model.attache.count];
    self.LabDateTime.text = [NSString stringWithFormat:@"%@",Model.create_time];
    self.LabMessage.text = Model.message;
    
    //创建collectionView
    [self CreatCollectionView];
    self.attatcheArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dic in Model.attache) {
        AttacheOShowPhoto *model = [[AttacheOShowPhoto alloc]initWithRYDict:dic];
        
        if ([model.attache isEqualToString:@"null"]) {
            self.ViewImage.hidden = YES;
           // self.LabPhotoNumber.hidden = YES;
            self.ConstraintMessageC.constant = 8;
        }
        [self.attatcheArray addObject:model];
    }
    
    if (Model.attache.count == 0) {
        self.ViewImage.hidden = YES;
        //self.LabPhotoNumber.hidden = YES;
        self.ConstraintMessageC.constant = 8;
    }
    
    [self.ViewImage addSubview:self.AttachePhotoCollectionView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
