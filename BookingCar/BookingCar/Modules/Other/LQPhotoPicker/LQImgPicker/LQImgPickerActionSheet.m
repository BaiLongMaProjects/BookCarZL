//
//  LQImgPickerActionSheet.m
//  QQImagePicker
//
//  Created by lawchat on 15/9/23.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import "LQImgPickerActionSheet.h"

@implementation LQImgPickerActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
    }
    return self;
}

#pragma mark - 显示选择照片提示sheet
- (void)showImgPickerActionSheetInView:(UIViewController*)controller{
    viewController = controller;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!imaPic) {
            imaPic = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            imaPic.delegate = self;
            [viewController presentViewController:imaPic animated:YES completion:nil];
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImgDataAndShowAllGroup];
    }]];
    
    
    [controller presentViewController:alertVC animated:YES completion:nil];

}
#pragma mark - 加载照片数据
- (void)loadImgDataAndShowAllGroup{
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if ( self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                if (_arrSelected) {
                    svc.arrSeleted = _arrSelected;
                    svc.mvc.arrSelected = _arrSelected;
                }
                svc.maxCout = _maxCount;
                [viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}


#pragma mark - 相机拍照得到的UIImage
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    if (theImage) {
//      UIImageWriteToSavedPhotosAlbum(theImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        // 保存图片到相册中
//        MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
//        [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//            NSLog(@"assetURL===:%@",assetURL.absoluteString);
//            if (error) {
//
//            } else {
//
//            }
//        }];
//        //获取图片路径
//        [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//            NSLog(@"获取图片路径成功:%@",asset);
//            if (asset) {
//            }
//        } failureBlock:^(NSError *error) {
//            NSLog(@"获取图片路径失败：%@",error);
//        }];
        
        [_arrSelected addObject:theImage];
        //[self finishSelectImg];
        if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImgWithALAssetArray:thumbnailImgImageArray:)]) {
            [self.delegate getSelectImgWithALAssetArray:_arrSelected thumbnailImgImageArray:_arrSelected];
        }
        
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        

        NSArray * array = [NSArray arrayWithObject:theImage];
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
        
        [HttpTool postWithPath:kUploadUrl indexName:@"img" imagePathList:array params:params success:^(id responseObj) {
            NSLog(@"拍照上传成功");
           // [AddImage addObject:responseObj[@"result"][@"url"]];
                NSString * urlString = responseObj[@"result"][@"url"];
                NSMutableArray * imageURL = [NSMutableArray arrayWithObject:urlString];

            
            [self SaveResqustUpPhotoClick:imageURL];
            
            [SVProgressHUD dismiss];
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"拍照上传失败  == %@",error);
            [[RYHUDManager sharedManager] showWithMessage:FAIL_NETWORKING_CONNECT customView:nil hideDelay:2.f];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 完成选择后返回的图片Array(ALAsset*)
- (void)finishSelectImg{
    //正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    
    for (ALAsset *set in _arrSelected) {
        CGImageRef cgImg = [set thumbnail];
        UIImage* image = [UIImage imageWithCGImage: cgImg];
        [thumbnailImgArr addObject:image];
    }

    [self.delegate  getSelectImgWithALAssetArray:_arrSelected thumbnailImgImageArray:thumbnailImgArr];
}
- (void)SaveResqustUpPhotoClick:(NSMutableArray *)AddPhoto
{
    NSLog(@"打印选择图片:所选择的照片个数为：%ld",AddPhoto.count);
    [self.delegate SaveResqustUpPhotoClick:AddPhoto];
    
}
@end
