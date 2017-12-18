//
//  ChatController.m
//  BookingCar
//
//  Created by LiXiaoJing on 29/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#import "ChatController.h"
#import "ChatTableViewCell.h"//自定义Cell
#import <EaseUI.h>
#import "ChatModel.h"//聊天
#import "ChatPageViewController.h"
@interface ChatController ()<EMChatManagerDelegate,EMGroupManagerDelegate,EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>
{
    NSMutableArray * chatListArray;
    NSString * _myHeaderImageString;
}
@property (nonatomic,strong)UITableView * chatViewTabView;//tabView列表
@property (nonatomic,strong)ChatTableViewCell * chatTabCell;//自定义列表Cell

@end

@implementation ChatController
//聊天列表接口
-(void)requsetChatList
{
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    
    
    LoginModel * login = [[LoginModel alloc]init];
    login = [LoginDataModel sharedManager].loginInModel;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:login.token forKey:@"token"];
    [HttpTool getWithPath:kDialogList params:params success:^(id responseObj) {
        NSLog(@"聊天列表chat === %@",responseObj);
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"1"]) {
            [chatListArray removeAllObjects];
            for (NSDictionary * dic in responseObj[@"data"]) {
                ChatModel * chat = [[ChatModel alloc]initWithRYDict:dic];
                _myHeaderImageString = chat.my_portrait_image;
                [chatListArray addObject:chat];
            }
        }
        //[self.tableView reloadData];
        [self refresh];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
         [SVProgressHUD dismiss];
        [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
    }];
}

-(ChatTableViewCell *)chatTabCell
{
    if (nil == _chatTabCell) {
        NSArray * nibs = [[NSBundle mainBundle]loadNibNamed:@"ChatTableViewCell" owner:self options:nil];
        _chatTabCell = [nibs lastObject];
    }
    return _chatTabCell;
}

//NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

- (void)loadAlertActionController{
    //UIAlertActionStyleDestructive
    
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weak_self(self) toSettingView];
    }];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"请允许通知" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:alertAction1];
    [alertVC addAction:alertAction2];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


- (void)toSettingView{
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //ios < 10.0
    if(kDeviceVersion < 10.0){
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }else{
        //ios >= 10.0
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL  success) {
                
            }];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    chatListArray = [[NSMutableArray alloc]init];
    self.title = @"聊天";
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.delegate = self;
    self.dataSource = self;
    self.showRefreshHeader = YES;
    //self.chatViewTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self tableViewDidTriggerHeaderRefresh];
    NOTIFY_ADD(refresh, USER_RECEIVE_MESSAGE_NOTIFICATION);

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
//        EMError *error = [[EMClient sharedClient] loginWithUsername:[kUserDefaults valueForKey:USER_PHOTO_ZL] password:[kUserDefaults valueForKey:USER_PASSWORD_ZL]];
//        if (!error)
//        {
//            [[EMClient sharedClient].options setIsAutoLogin:YES];
//            NSLog(@"登录成功");
//        }
//    }
    //获取所有会话(内存中有则从内存中取，没有则从db中取)
    //NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    //获取会话未读消息数
    //int weiDu = EMConversation.unreadMessagesCount;
    //[EMConversation unreadMessagesCount];
    
    
    [self requsetChatList];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    if (IOS8) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            NSLog(@"没有开启允许通知");
            [self loadAlertActionController];
        }
    }else{ // ios7 一下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
            NSLog(@"没有开启允许通知");
            [self loadAlertActionController];
        }
    }
    
    [self refresh];
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
    /*
    ChatModel * chat = [[ChatModel alloc]init];
    chat = chatListArray[indexPath.row];
    
    ChatSubViewVC *chatController = [[ChatSubViewVC alloc] initWithConversationChatter:chat.mobile conversationType:EMConversationTypeChat];
    chatController.title = chat.nick_name;
    chatController.showRefreshHeader = YES;
    chatController.showRefreshFooter = YES;
    [self.navigationController pushViewController:chatController animated:YES];
    */
    
 
    
//    EaseEmotionManager *manager = [[ EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:5 emotions:[EaseEmoji allEmoji]];
//    ChatPageViewController * messageVC = [[ChatPageViewController alloc]initWithConversationChatter:chat.mobile         conversationType:EMConversationTypeChat];
//    messageVC.OtherName = chat.nick_name;
//    messageVC.OtherHeadPhoto = chat.portrait_image;
//    messageVC.MeName = chat.my_nick_name;
//    messageVC.MeHeadPhoto = chat.my_portrait_image;
//    messageVC.OtherID = chat.to;
//    messageVC.hidesBottomBarWhenPushed=YES;
//    // 默认下拉刷新是关闭的,需要手动打开
//    messageVC.showRefreshHeader = YES;
//    messageVC.title = chat.nick_name;
//    [messageVC.faceView setEmotionManagers:@[manager]];
//    [self.navigationController pushViewController:messageVC animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
    
    
    
//}

////从环信中获取好友
//-(void)CreatMyfriend
//{
//    EMError *error = nil;
//    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
//    if (!error) {
//        NSLog(@"获取成功 -- %@",userlist);
//    }
//}

//#pragma mark- delegate
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 90.0;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return chatListArray.count;
//}
//-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * identifier = @"ChatTableViewCellID";
//    self.chatTabCell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!self.chatTabCell) {
//        self.chatTabCell = [[[NSBundle mainBundle]loadNibNamed:@"ChatTableViewCell" owner:self options:nil]lastObject];
//    }
//    if (chatListArray.count>0) {
//        ChatModel *model = chatListArray[indexPath.row];
//        [self.chatTabCell getInfo:model];
//    }
//
//    //点击没反应方法
//    self.chatTabCell.backgroundColor = RGBA(245, 245, 245, 1);
//    self.chatTabCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return self.chatTabCell;
//}

#pragma mark ===================Conver代理方法==================
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel{
    NSLog(@"conversationListViewController执行了代理方法");
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            ChatSubViewVC *chatController = [[ChatSubViewVC alloc]initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
           chatController.title = conversationModel.title;
            chatController.yourHeaderImageString = conversationModel.avatarURLPath;
            chatController.myHeaderImageString = _myHeaderImageString;
           [self.navigationController pushViewController:chatController animated:YES];
           }
        
      [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
       NOTIFY_POST(kSetupUnreadMessageCount);
       [self.tableView reloadData];
    }
}
#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation{
    NSLog(@"执行了Convert方法Model");
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
//    if (model.conversation.type == EMConversationTypeChat) {
//        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
//            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
//        } else {
//            UserCacheInfo * userInfo = [UserCacheManager getById:conversation.conversationId];
//            if (userInfo) {
//                model.title = userInfo.NickName;
//                model.avatarURLPath = userInfo.AvatarUrl;
//            }
//        }
//    }
    //model.title = @"小二";
    [chatListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ChatModel * chatModelZL = (ChatModel *)obj;
        if ([chatModelZL.mobile isEqualToString:model.title]) {
            model.avatarURLPath = chatModelZL.portrait_image;
        }
    }];
    
    return model;
}
- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }

//        if (lastMessage.direction == EMMessageDirectionReceive) {
//            NSString *from = [UserCacheManager getNickById:lastMessage.from];
//            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
//        }

//        NSDictionary *ext = conversationModel.conversation.ext;
//        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
//            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
//
//        }
//        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
//            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
//        }
//        else {
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//        }
        attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}

//公用方法a#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
    [self refreshDataSource];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}
#pragma mark - getter
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ===================刷新聊天页面==================
- (void)reloadLiaoTianLisView{
    
    
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
