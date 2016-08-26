//
//  WeiboAccessViewController.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "WeiboAccessViewController.h"
#import "AFNetworking.h"
#import "Account.h"
#import "TimeLineViewController.h"

@interface WeiboAccessViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *accessWebView;

@end

@implementation WeiboAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *accessWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:accessWebView];
    accessWebView.delegate = self;
    self.accessWebView = accessWebView;
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=1726021155&redirect_uri=http://www.baidu.com&response_type=code"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [accessWebView loadRequest:request];
    
}

//获取授权code
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"1");
    
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"code="];
    if (range.length) {
        NSUInteger index = range.location + range.length;
        NSString *code = [url substringFromIndex:index];
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}

//使用获取到的code来换取AccessToken
- (void)accessTokenWithCode:(NSString *)code {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"client_id"] = @"1726021155";
    parameters[@"client_secret"] = @"93322b95c3a88a26b36675ba260b7162";
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"redirect_uri"] = @"http://www.baidu.com";
    parameters[@"code"] = code;
    
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功，信息：%@", responseObject);
        
//将AccessToken保存至本地以便调用
        [Account accountAccessInfoSavingWithDictionary:responseObject];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[TimeLineViewController alloc] init];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！错误信息：%@", error);
    }];
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
