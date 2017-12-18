//
//  PageHomeHeadView.h
//  BookingCar
//
//  Created by mac on 2017/8/4.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PageHomeHeadView : UIView<UITextFieldDelegate>
{
    NSArray * _dataArray;
}
@property (weak, nonatomic) IBOutlet UITextField *TextfieldMoney;//Money
@property (weak, nonatomic) IBOutlet UIButton *ButGoTime;//出发时间
@property (weak, nonatomic) IBOutlet UIButton *ButPeoCar;//乘车人数
@property (weak, nonatomic) IBOutlet UIButton *ButSwag;//行李数
@property (weak, nonatomic) IBOutlet UIView *VePeoCar;//车行人数
@property (weak, nonatomic) IBOutlet UIView *VePeoSwag;//行李数
@property (weak, nonatomic) IBOutlet UIButton *ButStart;//开始起点
@property (weak, nonatomic) IBOutlet UIButton *ButFinish;//目标终点

@property (weak, nonatomic) IBOutlet UIButton *ButImageStart;//开始的图片按钮
@property (weak, nonatomic) IBOutlet UIButton *ButImageFinish;//结束的图片按钮

@property (weak, nonatomic) IBOutlet UIButton *ButExchange;//交换

@property (weak, nonatomic) IBOutlet UIButton *ButStartCar;//开始约车
@property (weak, nonatomic) IBOutlet UIView *ViewCarHidden;//司机隐藏约车View
@property (weak, nonatomic) IBOutlet UIButton *ButWillStart;//您有一个行程即将开始
@property (weak, nonatomic) IBOutlet UIButton *ButOrderHopeCancle;//您有一个行程希望被取消
@property (weak, nonatomic) IBOutlet UIButton *ButOrderWatingGo;//您有一个行程等待出发
@property (weak, nonatomic) IBOutlet UIButton *ButMoneyIng;//您有一个行程正在竞价
@property (weak, nonatomic) IBOutlet UILabel *LabOfferMoney;//建议价格

@property (strong, nonatomic) IBOutlet PPNumberButton *personNumButton;
@property (strong, nonatomic) IBOutlet PPNumberButton *xingLiButton;



//CommonMenuView下拉列表
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) int itemCount;
@end
