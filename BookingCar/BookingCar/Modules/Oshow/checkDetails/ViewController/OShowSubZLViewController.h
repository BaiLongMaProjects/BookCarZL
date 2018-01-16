//
//  OShowSubZLViewController.h
//  BookingCar
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "BaseController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "OShowDetailTableViewCell.h"
#import "OShowModel.h"
#import "IssueOShowViewController.h"
#import "OShowDetailTableViewCell.h"
#import "AttacheOShowPhoto.h"
#import "CommentsModel.h"


#import <MWPhotoBrowser.h>  //图片浏览器
#import "ZJImageViewBrowser.h"

#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"

#import "OtherOshowViewController.h"


@interface OShowSubZLViewController : BaseController<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,OShowDetailTableViewCellDelegate,ChatKeyBoardDelegate, ChatKeyBoardDataSource>


@property (strong, nonatomic) IBOutlet UITableView *backTableVIew;
@property (nonatomic, strong)NSMutableArray<OShowModel *> * oShowListArray;
@property (nonatomic, strong) NSMutableArray  *currentPhotoArray;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic,strong)NSIndexPath *commentIndexpath;
@property (nonatomic,strong)NSIndexPath *replyIndexpath;
@property (nonatomic,assign)float totalKeybordHeight;

@end
