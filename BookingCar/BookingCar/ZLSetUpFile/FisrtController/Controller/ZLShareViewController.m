//
//  ZLShareViewController.m
//  BookingCar
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Zhou. All rights reserved.
//

#import "ZLShareViewController.h"

@interface ZLShareViewController ()

@end

@implementation ZLShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self successViewPOPAnimation];
    });
}
/** pop动画测试 */
- (void)successViewPOPAnimation{
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    sprintAnimation.springBounciness = 20.f;
    [self.successView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.2;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1,1)];
        [self.successView pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    });
}
- (IBAction)backButtonAction:(UIButton *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)shareButtonAction:(id)sender {
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
    
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"我有一个新的订单等待接送！" descr:@"点击查看订单详情" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.urlString?:@"http://manxiren.com";//@"http://mobile.umeng.com/social";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSLog(@"分享错误：%@",error);
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                /** 返回按钮实现 */
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weak_self(self) dismissViewControllerAnimated:YES completion:nil];
                });
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        NSLog(@"分享错误：%@",error);
        //ZLALERT_TEXTINFO(error);
        //[self alertWithError:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
