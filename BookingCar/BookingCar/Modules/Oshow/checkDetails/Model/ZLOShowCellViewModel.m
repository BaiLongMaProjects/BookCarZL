//
//  ZLOShowCellViewModel.m
//  BookingCar
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "ZLOShowCellViewModel.h"

@implementation ZLOShowCellViewModel

//加载数据
//-(void)requsetUpdateOShowList{
//    [SVProgressHUD showWithStatus:@"正在加载......"];
//    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    if (OShowPage == 0) {
//        self.OShowListArray = [[NSMutableArray alloc]init];
//    }
//    LoginModel * login = [[LoginModel alloc]init];
//    login = [LoginDataModel sharedManager].loginInModel;
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setValue:login.token forKey:@"token"];
//    [params setValue:@"5" forKey:@"per_page"];
//    [params setValue:[NSString stringWithFormat:@"%ld",(long)OShowPage] forKey:@"page"];
//    [HttpTool getWithPath:kOShowList2Url params:params success:^(id responseObj) {
//        NSString * message = [NSString stringWithFormat:@"%@",responseObj[@"message"]];
//        NSString * statusCode = [NSString stringWithFormat:@"%@",responseObj[@"statusCode"]];
//        if ([message isEqualToString:@"sucess"]) {
//            NSArray * data = responseObj[@"data"];
//            for (NSDictionary * showDic in data) {
//                OShowModel * showMo = [[OShowModel alloc]initWithRYDict:showDic];
//                [self.OShowListArray addObject:showMo];
//            }
//        }
//        [self.OShowTab reloadData];
//        [SVProgressHUD dismiss];
//        // 结束刷新
//        [self.OShowTab.mj_header endRefreshing];
//        [self.OShowTab.mj_footer endRefreshing];
//    } failure:^(NSError *error) {
//        [[RYHUDManager sharedManager] showWithMessage:@"当前无网络......" customView:nil hideDelay:2.f];
//        [SVProgressHUD dismiss];
//        // 结束刷新
//        [self.OShowTab.mj_header endRefreshing];
//        [self.OShowTab.mj_footer endRefreshing];
//    }];
//    
//}
////点赞
//-(void)requsetFavoriteLove{
//    
//    LoginModel * login = [[LoginModel alloc]init];
//    login= [LoginDataModel sharedManager].loginInModel;
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setValue:login.token forKey:@"token"];
//    [params setValue:Strflag forKey:@"flag"];
//    [params setValue:self.oshowModel.idTemp forKey:@"id"];
//    [HttpTool getWithPath:kFavoriteLove params:params success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:1.5f];
//    } failure:^(NSError *error) {
//        [[RYHUDManager sharedManager] showWithMessage:@"当前无网络......" customView:nil hideDelay:1.5f];
//    }];
//}
////评论
//-(void)requsetCommentUpLoad
//{
//    LoginModel * login = [[LoginModel alloc]init];
//    login= [LoginDataModel sharedManager].loginInModel;
//    
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setValue:login.token forKey:@"token"];
//    [params setValue:text.text forKey:@"message"];
//    [params setValue:self.oshowModel.idTemp forKey:@"id"];
//    
//    [HttpTool getWithPath:kOShowComment params:params success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        
//        [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:1.5f];
//        
//        checking = [[checkDedatilModel alloc]initWithRYDict:responseObj];
//        checking.comment = text.text;
//        [CommentArray addObject:checking];
//        self.checkHeadView.LabComments.text = [NSString stringWithFormat:@"%ld",CommentArray.count];
//        [self.checkDetailTab reloadData];
//        
//    } failure:^(NSError *error) {
//        [[RYHUDManager sharedManager] showWithMessage:@"当前无网络......" customView:nil hideDelay:2.f];
//    }];
//    
//}
////举报
//-(void)requsetInform
//{
//    LoginModel * login = [[LoginModel alloc]init];
//    login= [LoginDataModel sharedManager].loginInModel;
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setValue:login.token forKey:@"token"];
//    [params setValue:StrInformflag forKey:@"flag"];
//    [params setValue:self.oshowModel.idTemp forKey:@"oshow_id"];
//    [HttpTool getWithPath:kOShowReport params:params success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]]isEqualToString:@"1"]) {
//            [[RYHUDManager sharedManager] showWithMessage:@"操作成功！" customView:nil hideDelay:2.f];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [[RYHUDManager sharedManager] showWithMessage:@"当前无网络......" customView:nil hideDelay:2.f];
//    }];
//}
////屏蔽
//-(void)requsetScreening
//{
//    LoginModel * login = [[LoginModel alloc]init];
//    login= [LoginDataModel sharedManager].loginInModel;
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setValue:login.token forKey:@"token"];
//    [params setValue:StrInformflag forKey:@"flag"];
//    [params setValue:@"9" forKey:@"mark"];
//    [params setValue:self.oshowModel.idTemp forKey:@"blocked"];
//    [HttpTool getWithPath:kOShowShield params:params success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]]isEqualToString:@"1"]) {
//            [[RYHUDManager sharedManager] showWithMessage:@"操作成功！" customView:nil hideDelay:2.f];
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [[RYHUDManager sharedManager] showWithMessage:@"当前无网络......" customView:nil hideDelay:2.f];
//    }];
//}


@end
