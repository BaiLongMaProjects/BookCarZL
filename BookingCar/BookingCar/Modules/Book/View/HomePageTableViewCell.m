//
//  HomePageTableViewCell.m
//  BookingCar
//
//  Created by mac on 2017/8/7.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell
{
    BOOL Lovebool;
    NSString * HomePageID;
    NSString * flag;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.ImgHead.layer setMasksToBounds:YES];
    [self.ImgHead.layer setCornerRadius:self.ImgHead.frame.size.height/2];
    self.ImgBackground.contentMode = UIViewContentModeScaleAspectFill;
    self.ImgBackground.clipsToBounds = YES;
}

-(void)requsetHomePage
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
-(void)getInfo:(NearDetailModel *)Model
{
    Lovebool = YES;

    [self.ImgHead sd_setImageWithURL:[NSURL URLWithString:Model.portrait_image] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    //defaultzl
    [self.ImgBackground sd_setImageWithURL:[NSURL URLWithString:Model.backgroud] placeholderImage:[UIImage imageNamed:Default_ImageView]];
    self.LabName.text = ![Model.nick_name isEqualToString:@""] ? Model.nick_name :@"小马哥";
    self.LabTown.text = ![Model.company1 isEqualToString:@""]? Model.company1:@"我在这，你在哪儿";//家乡
    NSString * cityString = [NSString stringWithFormat:@"%@  %@",Model.current_province,Model.current_city];
    self.LabBelongs.text = ![cityString isEqualToString:@""]?cityString:@"美国 芝加哥";//所属地
    //NSLog(@"附近乘客信息：%@---%@----%@,self.LabBelongs.text=%@,self.LabTown.text=%@",Model.company1,Model.company2,Model.nick_name,self.LabTown.text,self.LabTown.text);
    if ([Model.gender isEqualToString:@"男"]) {
        [self.ImgGender setImage:[UIImage imageNamed:@"Home_boy"]];
    }else
    {
        [self.ImgGender setImage:[UIImage imageNamed:@"Home_girl"]];
    }
    
    self.LabLoveNum.text = Model.love;
    if ([Model.status isEqualToString:@"999"]) {
        [self.ButLove setImage:[UIImage imageNamed:@"OShow_Love"] forState:UIControlStateNormal];
        Lovebool = NO;
    }
    else
    {
        [self.ButLove setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        Lovebool = YES;
    }

    
    HomePageID = Model.idTemp;
    
    [self.ButLoveClick addTarget:self action:@selector(ButLoveClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)ButLoveClick:(UIButton *)sender
{
    if (Lovebool == YES) {
        [self.ButLove setImage:[UIImage imageNamed:@"OShow_Love"] forState:UIControlStateNormal];
        Lovebool = NO;
        flag = @"1";
        self.LabLoveNum.text =[NSString stringWithFormat:@"%ld",[self.LabLoveNum.text integerValue] +1];
        [self requsetHomePage];
    }
    else
    {
        [self.ButLove setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        Lovebool = YES;
        flag = @"0";
        self.LabLoveNum.text =[NSString stringWithFormat:@"%ld",[self.LabLoveNum.text integerValue] - 1];
        [self requsetHomePage];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
