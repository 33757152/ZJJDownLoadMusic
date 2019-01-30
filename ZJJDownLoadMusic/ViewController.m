//
//  ViewController.m
//  ZJJDownLoadMusic
//
//  Created by YD on 2019/1/29.
//  Copyright © 2019年 YD. All rights reserved.
//
#define WEAKSELF __block ViewController *weakSelf = self;

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *idTF;
@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self downLoadButtonTitle:@"下载"];
}

- (void)downLoadButtonTitle:(NSString *)title {
    [self.downLoadButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)downLoadClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self.idTF.text isEqualToString:@""] || !self.idTF.text) {
        return;
    }
    if (![sender.currentTitle isEqualToString:@"下载"]) {
        return;
    }
    WEAKSELF
    [self downLoadButtonTitle:@"下载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"http://player.kuwo.cn/webmusic/st/getNewMuiseByRid?rid=MUSIC_%@",_idTF.text];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = responseObject;
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [weakSelf obtainUrlDetailInfoWithString:dataStr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)obtainUrlDetailInfoWithString:(NSString *)dataString {
    // music name
    NSString *namePart = [[dataString componentsSeparatedByString:@"</name>"] firstObject];
    NSString *name = [[[namePart componentsSeparatedByString:@"<name>"] lastObject] stringByAppendingString:@".mp3"];
    // mp3dl
    NSString *mp3dlPart = [[dataString componentsSeparatedByString:@"</mp3dl>"] firstObject];
    NSString *mp3dlTotal = [[mp3dlPart componentsSeparatedByString:@"<mp3dl>"] lastObject];
    NSString *mp3dl = [mp3dlTotal stringByReplacingOccurrencesOfString:@"other.web." withString:@""];
    // mp3path
    NSString *mp3pathPart = [[dataString componentsSeparatedByString:@"</mp3path>"] firstObject];
    NSString *mp3path = [[mp3pathPart componentsSeparatedByString:@"<mp3path>"] lastObject];
    // 最终的URL
    NSString *mp3Url = [NSString stringWithFormat:@"http://%@/resource/%@",mp3dl,mp3path];
    [self beginDownLoadMusicWithPathUrl:mp3Url fileName:name];
}

- (void)beginDownLoadMusicWithPathUrl:(NSString *)pathUrl fileName:(NSString *)fileName {
    WEAKSELF;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathUrl]] progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float p = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            NSString *progressStr = [NSString stringWithFormat:@"已下载%.f%%",p*100];
            [weakSelf downLoadButtonTitle:progressStr];
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *realPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:realPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf downLoadButtonTitle:@"下载"];
        });
        NSLog(@"%@",filePath.absoluteString);
    }];
    [task resume];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
