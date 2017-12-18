//
//  PDFfileViewController.m
//  BookingCar
//
//  Created by mac on 2017/9/23.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "PDFfileViewController.h"

@interface PDFfileViewController ()<UIWebViewDelegate>
{
    NSString * url;
    NSString * url1;
    NSString* fileUrl;
}
@property (nonatomic ,strong)UIWebView * webView;
@end

@implementation PDFfileViewController

-(void)requsetWebView
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [HttpTool getWithPath:kSignPortocol params:params success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        url = [NSString stringWithFormat:@"%@",responseObj[@"fw_url"]];
        url1 = [NSString stringWithFormat:@"%@",responseObj[@"ys_url"]];

        [self requsetPDF];
    } failure:^(NSError *error) {
        
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
    self.navigationController.navigationBar.hidden = NO;
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requsetWebView];
    // Do any additional setup after loading the view.
}
-(void)requsetPDF
{
    //设置下载文件保存的目录
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* _filePath = [paths objectAtIndex:0];
    
    //File Url
    if ([self.StrMessage isEqualToString:@"1"]) {
        fileUrl = url;
        self.title = @"服务条款";
    }else
    {
        fileUrl = url1;
        self.title = @"隐私条款";
    }
    
    //Encode Url 如果Url 中含有空格，一定要先 Encode
    fileUrl = [fileUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    NSString* fileName = @"down_form.pdf";
    
    
    NSString* filePath = [_filePath stringByAppendingPathComponent:fileName];
    
    //下载进行中的事件
    AFURLConnectionOperation *operation =   [[AFURLConnectionOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载的进度，如 0.53，就是 53%
        float progress =   (float)totalBytesRead / totalBytesExpectedToRead;
        
        //下载完成
        //该方法会在下载完成后立即执行
        if (progress == 1.0) {
            //            [downloadsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"完成加载时调用的方法");
            
            [self PDFLoadView];
        }
    }];
    
    //下载完成的事件
    //该方法会在下载完成后 延迟 2秒左右执行
    //根据完成后需要处理的及时性不高，可以采用该方法
    [operation setCompletionBlock:^{
        
    }];
    
    [operation start];
    
}
-(void)PDFLoadView
{
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* filePath = [paths objectAtIndex:0];
    
    NSString* fileName = @"down_form.pdf";
    NSString *path = [filePath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists) {
        //        path = [Util urlEncodeString:path];
        NSURL* url = [[NSURL alloc]initWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
    [self.view addSubview:webView];
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
