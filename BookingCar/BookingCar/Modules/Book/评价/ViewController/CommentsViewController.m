//
//  CommentsViewController.m
//  BookingCar
//
//  Created by mac on 2017/9/13.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsView.h"//评价View
#import "ReadyGoModel.h"
@interface CommentsViewController ()
@property (nonatomic, strong)ReadyGoModel * readyGoModel;
@property (nonatomic, strong)CommentsView * commentView;
@property (nonatomic, strong)UIScrollView * MyScr;
@end

@implementation CommentsViewController
-(instancetype)initWithDataModel:(ReadyGoModel*)readyGoModel
{
    if (self = [super init]) {
        _readyGoModel = [[ReadyGoModel alloc]init];
        _readyGoModel = readyGoModel;
    }
    return self;
}
-(CommentsView*)commentView
{
    if (nil == _commentView) {
        _commentView = [[[NSBundle mainBundle]loadNibNamed:@"CommentsView" owner:self options:nil]lastObject];
        _commentView.frame = CGRectMake(0, 0, KScreenWidth, 667);
        
        [_commentView getInfo:self.readyGoModel];
    }
    return _commentView;
}
-(UIScrollView*)MyScr
{
    if (nil == _MyScr) {
        _MyScr = [[UIScrollView alloc]init];
        _MyScr.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _MyScr.backgroundColor = kGlobalBg;
        _MyScr.contentSize = CGSizeMake(KScreenWidth, 667);
    }
    return _MyScr;
}
-(void)requsetCommentUpdate
{
    
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
    [self.MyScr addSubview:self.commentView];
    [self.view addSubview:self.MyScr];
    // Do any additional setup after loading the view from its nib.
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
