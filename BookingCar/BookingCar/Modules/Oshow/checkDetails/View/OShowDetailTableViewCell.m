//
//  OShowDetailTableViewCell.m
//  BookingCar
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "OShowDetailTableViewCell.h"
#define Collection_item_Width  (SIZE_WIDTH-70.0-15.0)/3.0
#define Collection_item_Height  (SIZE_WIDTH-70.0-15.0)/3.0
@implementation OShowDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.pingTableView registerNib:[UINib nibWithNibName:@"ZLComentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComentCellIDZL"];
    self.pingTableView.delegate = self;
    self.pingTableView.dataSource = self;
    //self.pingTableView.backgroundColor = [UIColor colorWithhex16stringToColor:@""];
    self.pingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pingTableView.scrollEnabled = NO;
    self.pingTableView.showsVerticalScrollIndicator = NO;
    self.pingTableView.showsHorizontalScrollIndicator = NO;
    [self setPhotoesCollectionViewZL];
    
}

//绑定数据
- (void)bindDataModel:(OShowModel *)model withIndexPath:(NSIndexPath *)indexPath{
    self.currentModel = model;
    self.currentCellIndexPath = indexPath;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.ip] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    self.nameLabel.text = model.point;
    self.contentLabel.text = model.message;
    self.locationLabel.text = [NSString stringWithFormat:@"%@ %@",model.province,model.city];
    self.timeLabel.text = model.create_time;
    self.zanLabel.text = model.love;
    if ([model.status_love isEqualToString:@"1"]) {
        [self.zanButton setImage:[UIImage imageNamed:@"OShow_Love"] forState:UIControlStateNormal];
    }else{
        [self.zanButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
    }
    self.pingNumLabel.text = [NSString stringWithFormat:@"%ld",model.comments.count];
    
    //图片 类型 解析
    [self.collectionImageArray removeAllObjects];
    [self.collectionImageArray addObjectsFromArray:model.attache];
    [self.collectionView reloadData];
    
    //评论数据
    [self.pingLunArray removeAllObjects];
    [self.pingLunArray addObjectsFromArray:model.comments];
    [self.pingTableView reloadData];
    
    //NSLog(@"第几行，有几张图片，几条评论=%ld-->%ld--->%ld",indexPath.row,self.collectionImageArray.count,self.pingLunArray.count);
    //加载 图片 和评论
    [self loadUIView];
}

- (void)loadUIView{
    if (self.currentModel.attache.count == 0) {
        self.collectionViewHeight.constant = 0.0;
    }
    else if(0< self.currentModel.attache.count && self.currentModel.attache.count< 4){
        // [self setPhotoesCollectionViewZL];
        self.collectionViewHeight.constant = Collection_item_Height;
    }
    else if(3< self.currentModel.attache.count && self.currentModel.attache.count< 7){
        //[self setPhotoesCollectionViewZL];
        self.collectionViewHeight.constant = Collection_item_Height * 2.0;
        
    }
    else if (6< self.currentModel.attache.count && self.currentModel.attache.count< 10){
        //[self setPhotoesCollectionViewZL];
        self.collectionViewHeight.constant = Collection_item_Height * 3.0;
    }
    
    [self setPingLunTableView];
    //[self layoutIfNeeded];
    [self.superview layoutIfNeeded];
    //NSLog(@"collectionViewHeight----->%.1f,item_Height----->%.1f",self.collectionViewHeight.constant,Collection_item_Height);
}
- (void)setPhotoesCollectionViewZL{
    //创建一个Layout布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为
    layout.itemSize = CGSizeMake(Collection_item_Height-3.5, Collection_item_Height-3.5);
    //item距离四周的位置（上左下右）
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //item 行与行的距离
    layout.minimumLineSpacing = 5;
    //item 列与列的距离
    layout.minimumInteritemSpacing = 5;
    
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellID"];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.collectionView reloadData];
    //    });
    
    
}

- (void)setPingLunTableView{
    //self.comentTableViewHeight = 0;//评论cell的高度
    if (self.currentModel.comments.count == 0) {
        self.pingTableviewHeight.constant = 0;
    }else if (self.currentModel.comments.count > 0){
        float height = 0;
        for(int i =0;i<self.pingLunArray.count;i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CGFloat heightFloat =[self.pingTableView fd_heightForCellWithIdentifier:@"ComentCellIDZL" cacheByIndexPath:indexPath configuration:^(ZLComentTableViewCell *cell) {
                CommentsModel * comModel = self.pingLunArray[indexPath.row];
                [cell bindDataModel:comModel withIndexPath:indexPath];
            }];
            height += heightFloat + 7.0;
        }
        self.pingTableviewHeight.constant = height;
    }
}


#pragma mark CollectionView  的  dataSource方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionImageArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"collectionViewCellID";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = 10;
    AttacheOShowPhoto * photoModel = self.collectionImageArray[indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.attache] placeholderImage:[UIImage imageNamed:Default_ImageView]];
    [cell.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(cell.contentView);
    }];
    //    NSLog(@"图片的URL：%@",photoModel.attache);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /*
     if (self.delegate && [self.delegate respondsToSelector:@selector(oShowDetailTableViewCell:withCurrentImage:withImageArray:withIndexPath:withCurrenImageIndex:)]) {
     
     [self.delegate oShowDetailTableViewCell:self withCurrentImage:nil withImageArray:self.collectionImageArray withIndexPath:self.currentCellIndexPath withCurrenImageIndex:indexPath.row];
     
     }
     */
    [self.imageViewArray removeAllObjects];
    for (int i=0; i<self.collectionImageArray.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        AttacheOShowPhoto * photoModel = self.collectionImageArray[i];
        //[imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.attache] placeholderImage:[UIImage imageNamed:Default_ImageView]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.attache] placeholderImage:[UIImage imageNamed:Default_ImageView] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];

         [self.imageViewArray addObject:imageView];

       
    }
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        UIImageView * imageiew = self.imageViewArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageViewWithCurrentView:imageViewArray:imageSuperView:indexPath:)]) {
            [self.delegate didClickImageViewWithCurrentView:imageiew imageViewArray:self.imageViewArray imageSuperView:cell.contentView indexPath:indexPath];
        }
}
#pragma mark ===================TableView  方法 开始==================
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightFloat =[tableView fd_heightForCellWithIdentifier:@"ComentCellIDZL" cacheByIndexPath:indexPath configuration:^(ZLComentTableViewCell *cell) {
        CommentsModel * comModel = self.pingLunArray[indexPath.row];
        [cell bindDataModel:comModel withIndexPath:indexPath];
    }];
    return heightFloat+7.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"self.currentModel.comments.count---->%ld",self.currentModel.comments.count);
    return self.pingLunArray.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"ComentCellIDZL";
    ZLComentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    CommentsModel * comModel = self.pingLunArray[indexPath.row];
    [cell bindDataModel:comModel withIndexPath:indexPath];
    return cell;
}
//点击Cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRowWithFirstIndexPath:secondIndex:)]) {
        [self.delegate didClickRowWithFirstIndexPath:self.currentCellIndexPath secondIndex:indexPath];
    }
}
#pragma mark ===================TableView  方法 结束==================
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark ===================评论按钮执行方法==================

- (IBAction)pingLunButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentBtnWithIndexPath:)]) {
        [self.delegate didClickCommentBtnWithIndexPath:self.currentCellIndexPath];
    }
}
#pragma mark ===================点赞按钮==================

- (IBAction)lveButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLoveBtnWithIndexPath:)]) {
        [self.delegate didClickLoveBtnWithIndexPath:self.currentCellIndexPath];
    }
}

#pragma mark ===================懒加载==================
- (NSMutableArray *)collectionImageArray{
    if (!_collectionImageArray) {
        _collectionImageArray = [NSMutableArray new];
    }
    return _collectionImageArray;
}
- (NSMutableArray *)pingLunArray{
    if (!_pingLunArray) {
        _pingLunArray = [NSMutableArray new];
    }
    return _pingLunArray;
}
- (NSMutableArray *)imageViewArray{
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray new];
    }
    return _imageViewArray;
}
//重置
- (void)prepareForReuse
{
    [super prepareForReuse];
}


- (IBAction)juBaoButtonAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(juBaoButtonActionWithIndexPath:)]) {
        [self.delegate juBaoButtonActionWithIndexPath:self.currentCellIndexPath];
    }
}

@end
