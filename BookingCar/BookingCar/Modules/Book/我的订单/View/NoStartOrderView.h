//
//  NoStartOrderView.h
//  BookingCar
//
//  Created by mac on 2017/8/19.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoStartOrderTableViewCell.h"//自定义cell
@protocol NoStartSelectDelegate <NSObject>

-(void)TabViewAndTab:(UITableView *)tableView didSelectIndex:(NSIndexPath *)index NSMutableArray:(NSMutableArray *)dataArray;

@end
@interface NoStartOrderView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * NoStartTabView;
@property (nonatomic, strong)NoStartOrderTableViewCell * noStartTabCell;
@property (nonatomic, assign) id <NoStartSelectDelegate>delegate;
@property (nonatomic, strong)NSMutableArray * DataArray;
@end
