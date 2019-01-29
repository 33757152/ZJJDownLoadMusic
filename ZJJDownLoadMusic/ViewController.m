//
//  ViewController.m
//  ZJJDownLoadMusic
//
//  Created by YD on 2019/1/29.
//  Copyright © 2019年 YD. All rights reserved.
//

#define URL_STR       @"http://ra01.sycdn.kuwo.cn/resource/n2/128/83/49/171019036.mp3"
#define MUSIC_NAME    @"夜曲.mp3"

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)downLoadClick:(id)sender {
    __block ViewController *weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_STR]] progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float p = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            NSString *progressStr = [NSString stringWithFormat:@"已下载%.f%%",p*100];
            [weakSelf.downLoadButton setTitle:progressStr forState:UIControlStateNormal];
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *realPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:MUSIC_NAME];
        return [NSURL fileURLWithPath:realPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.downLoadButton setTitle:@"下载" forState:UIControlStateNormal];
        });
        NSLog(@"%@",filePath.absoluteString);
    }];
    [task resume];
}

- (IBAction)cleanClick:(id)sender {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

@end
