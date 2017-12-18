//
//  ChatController.h
//  BookingCar
//
//  Created by LiXiaoJing on 29/06/2017.
//  Copyright © 2017 LiXiaoJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "EaseConversationListViewController.h"
#import <EaseUI/EaseUI.h>
#import "ChatSubViewVC.h"
//#import "ConversationListController.h"

@interface ChatController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;
@property (nonatomic, strong) UIView *networkStateView;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@end
