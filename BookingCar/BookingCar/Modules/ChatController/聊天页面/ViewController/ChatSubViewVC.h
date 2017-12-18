//
//  ChatSubViewVC.h
//  BookingCar
//
//  Created by apple on 2017/10/31.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <EaseUI/EaseUI.h>
#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface ChatSubViewVC : EaseMessageViewController<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,UIAlertViewDelegate,EMClientDelegate>

@property (nonatomic, copy) NSString *myHeaderImageString;
@property (nonatomic, copy) NSString *yourHeaderImageString;

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
