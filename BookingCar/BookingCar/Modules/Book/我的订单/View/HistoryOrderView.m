//
//  HistoryOrderView.m
//  BookingCar
//
//  Created by mac on 2017/8/19.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "HistoryOrderView.h"

@implementation HistoryOrderView

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.HistoryTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-44-64) style:UITableViewStylePlain];
//    self.HistoryTabView.delegate = self;
//    self.HistoryTabView.dataSource = self;
//    [self addSubview:self.HistoryTabView];
}
//#pragma mark- delegate
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.noStartTabCell.frame.size.height;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}
//
//-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * identCell = @"NoStartCell";
//    self.noStartTabCell = [tableView dequeueReusableCellWithIdentifier:identCell];
//    if (!self.noStartTabCell) {
//        self.noStartTabCell = [[[NSBundle mainBundle]loadNibNamed:@"NoStartOrderTableViewCell" owner:self options:nil]lastObject];
//
//    }
////    if (indexPath.row == 0) {
////        self.noStartTabCell.LabStatus.text = @"行程已取消";
////    }
//    if (indexPath.row == 0) {
//        self.noStartTabCell.LabStatus.text = @"行程已取消";
//    }
//    if (indexPath.row == 1) {
//        self.noStartTabCell.LabStatus.text = @"已完成订单";
//        self.noStartTabCell.LabHopeMoney.text = @"成交价格";
//        self.noStartTabCell.ButGoComment.hidden = NO;
//        
//    }
//    if (indexPath.row == 2) {
//        self.noStartTabCell.LabStatus.text = @"已完成订单";
//        self.noStartTabCell.LabHopeMoney.text = @"成交价格";
//        self.noStartTabCell.ButGoComment.hidden = NO;
//    }
//    return self.noStartTabCell;
//}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
