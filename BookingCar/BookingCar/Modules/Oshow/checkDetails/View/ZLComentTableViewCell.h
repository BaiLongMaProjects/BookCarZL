//
//  ZLComentTableViewCell.h
//  BookingCar
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"
@interface ZLComentTableViewCell : UITableViewCell<MLLinkLabelDelegate>
@property (strong, nonatomic) IBOutlet MLLinkLabel *comentLabel;

- (void)bindDataModel:(CommentsModel *)model withIndexPath:(NSIndexPath *)indexPath;

@end
