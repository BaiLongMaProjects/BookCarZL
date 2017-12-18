//
//  CheckDetailViewController.h
//  BookingCar
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "BaseController.h"
#import "OShowModel.h"
@protocol BackUpDateDetailOShowVCDelegate <NSObject>
-(void)UpDateRequsetDetailOShowVCData;
@end

@interface CheckDetailViewController : BaseController
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)BOOL LoveBooL;
@property (nonatomic, assign)NSIndexPath * OShowPath;
@property (nonatomic, assign) id <BackUpDateDetailOShowVCDelegate> backUpDatedelegate;

-(instancetype)initWithDataModel:(OShowModel *)oshowModel;

@end
