//
//  IssueOShowViewController.h
//  BookingCar
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 LDX. All rights reserved.
//

#import "BaseController.h"
#import "LQPhotoPickerViewController.h"

//@protocol BackUpDateOShowVCDelegate <NSObject>

//-(void)UpDateRequsetOShowData;

//@end

@interface IssueOShowViewController : LQPhotoPickerViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) UIView *noteTextBackgroudView;
//备注
@property(nonatomic,strong) UITextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;

//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//提交按钮
@property(nonatomic,strong) UIButton *submitBtn;

@property (nonatomic, strong)NSMutableArray * AddPhoto;

//经纬度
@property (nonatomic, strong)CLLocation * PointLatLngLocation;

//@property (nonatomic, assign) id <BackUpDateOShowVCDelegate> backUpDatedelegate;

@end
