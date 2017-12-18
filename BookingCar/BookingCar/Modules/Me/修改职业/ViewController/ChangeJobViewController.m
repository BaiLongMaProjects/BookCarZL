//
//  ChangeJobViewController.m
//  BookingCar
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "ChangeJobViewController.h"

@interface ChangeJobViewController ()
@property (weak, nonatomic) IBOutlet UITextField *TextFieldJob;//输入职业

@end

@implementation ChangeJobViewController

//上传个人信息
-(void)requsetUpdatePerson{
    
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setValue:infor.access_token forKey:@"token"];
    [params setValue:infor.nick_name forKey:@"nick_name"];
    [params setValue:infor.company1 forKey:@"company1"];
    [params setValue:infor.company2 forKey:@"company2"];
    [params setValue:@"" forKey:@"birthday"]; 
    [params setValue:infor.job forKey:@"job"];
    [params setValue:infor.email forKey:@"email"];
    [params setValue:infor.gender forKey:@"gender"];
    [params setValue:infor.portrait_image forKey:@"avatar"];
    
    [HttpTool postWithPath:kUpdatePerson params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSString * status = [NSString stringWithFormat:@"%@",responseObj[@"status"]];
        if ([status isEqualToString:@"1"]) {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [[RYHUDManager sharedManager] showWithMessage:responseObj[@"message"] customView:nil hideDelay:2.f];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"上传失败error ===  %@",error);
        
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职业";
    
    self.TextFieldJob.text = self.changeJob;
    self.view.backgroundColor = BaseLDXColor;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)ButSaveClick:(id)sender {
    
    if ([self.TextFieldJob.text isEqualToString:@""]) {
        [[RYHUDManager sharedManager] showWithMessage:@"您输入的职业不能为空" customView:nil hideDelay:2.f];
        return;
    }
    InforModel * infor = [[InforModel alloc]init];
    infor = [LoginDataModel sharedManager].inforModel;
    infor.job = self.TextFieldJob.text;
    [[LoginDataModel sharedManager]saveLoginMemberData:infor];
    //更改性别信息接口
    [self requsetUpdatePerson];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
