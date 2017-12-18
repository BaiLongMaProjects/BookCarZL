//
//  NearDiverTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "NearDiverTableViewCell.h"

@implementation NearDiverTableViewCell
{
    BOOL Lovebool;
    NSString * OrderID;
    NSString * DriverID;
    NSString * HomePageID;
    NSString * flag;
}
//点赞的接口
-(void)requsetLovePage
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:HomePageID forKey:@"user_id"];
    [params setValue:flag forKey:@"flag"];
    
    [HttpTool getWithPath:kSignThumb params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
    
}
//车的接口
-(void)requsetHomePage
{
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:login.token forKey:@"token"];
    [params setValue:DriverID forKey:@"driver_id"];
    [params setValue:OrderID forKey:@"order_id"];
    [params setValue:flag forKey:@"flag"];
    [HttpTool postWithPath:kSelectDriver params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSString * stateString = [NSString stringWithFormat:@"%d",[responseObj[@"status"] intValue]];
        if ([stateString isEqualToString:@"1"]){
            if ([flag isEqualToString:@"1"]) {
                [[RYHUDManager sharedManager] showWithMessage:@"已经通知司机来接单啦！" customView:nil hideDelay:2.f];
            }
            else{
                [[RYHUDManager sharedManager] showWithMessage:@"您已取消，司机很难过哦！" customView:nil hideDelay:2.f];
                
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.ButPickMe addTarget:self action:@selector(ButPickMeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.LabImgHeadPhoto.layer setMasksToBounds:YES];
    [self.LabImgHeadPhoto.layer setCornerRadius:self.LabImgHeadPhoto.frame.size.height/2];
    // Initialization code
    self.ImgBackgroud.contentMode = UIViewContentModeScaleAspectFill;
    self.ImgBackgroud.clipsToBounds = YES;
}
//请他来接
-(void)ButPickMeClick:(UIButton *)sender
{
    if (self.ButPickMe.selected == YES) {
        [self.ButPickMe setImage:[UIImage imageNamed:@"mine_dlzc_zc_pre"] forState:UIControlStateNormal];
        self.ButPickMe.selected = NO;
        flag = @"1";
        [self requsetHomePage];
    }else
    {
        [self.ButPickMe setImage:[UIImage imageNamed:@"mine_dlzc_zc_nor"] forState:UIControlStateNormal];
        self.ButPickMe.selected = YES;
        flag = @"0";
        [self requsetHomePage];
    }
}


-(void)getInfo:(NearDetailModel *)Model
{
    Lovebool = YES;

    [self.LabImgHeadPhoto sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    [self.ImgBackgroud sd_setImageWithURL:[NSURL URLWithString:Model.backgroud] placeholderImage:[UIImage imageNamed:Default_ImageView]];
    self.LabTown.text = [Model.company1 isEqualToString:@""]?Model.company1:@"我在这，你在哪儿";
    NSString * citySteing = [NSString stringWithFormat:@"%@  %@",Model.current_province,Model.current_city];
    self.LabBelongs.text = ![citySteing isEqualToString:@""]?citySteing:@"美国 芝加哥";
    self.LabLoveNum.text = Model.love;
    self.LabName.text = Model.nick_name;
    DriverID = Model.driver_id;
    OrderID = Model.order_id;
    HomePageID = Model.idTemp;
    if ([Model.gender isEqualToString:@"男"]) {
        [self.ImgGender setImage:[UIImage imageNamed:@"Home_boy"]];
    }else
    {
        [self.ImgGender setImage:[UIImage imageNamed:@"Home_girl"]];
    }
    if ([Model.status isEqualToString:@"999"]) {
        [self.ButLoveSelect setImage:[UIImage imageNamed:@"OShow_Love"] forState:UIControlStateNormal];
        Lovebool = NO;
    }
    else
    {
        [self.ButLoveSelect setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        Lovebool = YES;
    }
    
    
    
    if ([Model.select_status isEqualToString:@"999"]) {
        [self.ButPickMe setImage:[UIImage imageNamed:@"mine_dlzc_zc_pre"] forState:UIControlStateNormal];
        self.ButPickMe.selected = NO;
    }else
    {
        [self.ButPickMe setImage:[UIImage imageNamed:@"mine_dlzc_zc_nor"] forState:UIControlStateNormal];
        self.ButPickMe.selected = YES;
    }
    
    
    [self.ButLoveSelect addTarget:self action:@selector(ButLoveClick:) forControlEvents:UIControlEventTouchUpInside];
}
//爱心点赞
-(void)ButLoveClick:(UIButton *)sender
{
    if (Lovebool == YES) {
        [self.ButLoveSelect setImage:[UIImage imageNamed:@"OShow_Love"] forState:UIControlStateNormal];
        Lovebool = NO;
        flag = @"1";
        [self requsetLovePage];
    }
    else
    {
        [self.ButLoveSelect setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        Lovebool = YES;
        flag = @"0";
        [self requsetLovePage];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
