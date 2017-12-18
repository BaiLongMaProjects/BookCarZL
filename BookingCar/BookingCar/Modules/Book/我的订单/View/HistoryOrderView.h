//
//  HistoryOrderView.h
//  BookingCar
//
//  Created by mac on 2017/8/19.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoStartOrderTableViewCell.h"
@interface HistoryOrderView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * HistoryTabView;
@property (nonatomic, strong)NoStartOrderTableViewCell * noStartTabCell;
@end
