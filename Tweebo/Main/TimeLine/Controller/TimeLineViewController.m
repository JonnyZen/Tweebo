//
//  TimeLineViewController.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "TimeLineViewController.h"
#import "TweetComposeController.h"
#import "ZQNavigationController.h"
#import "AFNetworking.h"
#import "Account.h"
#import "Tweet.h"
#import "TimeLineCell.h"
#import "Constant.h"
#import "UIView+Extension.h"

@interface TimeLineViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)tweets {
    if (!_tweets) {
        _tweets = [NSMutableArray array];
    }
    return _tweets;
}

#pragma mark - *******************Data Loading
//请求数据
- (void)requestTimeLineData {
    [self.indicator startAnimating];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    Account *account = [Account accountAccessInfo];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.accessToken;
    parameters[@"count"] = @20;
    
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSArray *tweetsArray = responseObject[@"statuses"];
             for (NSDictionary *dict in tweetsArray) {
                 Tweet *tweet = [Tweet tweetWithDictionary:dict];
                 [self.tweets addObject:tweet];
                 [self.indicator stopAnimating];
//                 NSLog(@"%@", responseObject);
             }
             [self.tableView reloadData];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求错误，原因：%@", error);
         }];
}

//下拉刷新
- (void)pullDownRefresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    Account *account = [Account accountAccessInfo];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.accessToken;
    parameters[@"count"] = @20;
    
    Tweet *firstTweet = [self.tweets firstObject];
    if (firstTweet) {
        parameters[@"since_id"] = firstTweet.idstr;
    }
    
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:nil
     
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweetsArray = responseObject[@"statuses"];
        NSMutableArray *newestTweetsArray = [NSMutableArray array];
        for (NSDictionary *dict in tweetsArray) {
            Tweet *tweet = [Tweet tweetWithDictionary:dict];
            [newestTweetsArray addObject:tweet];
        }
        NSRange range = NSMakeRange(0, newestTweetsArray.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tweets insertObjects:newestTweetsArray atIndexes:set];
    }
     
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败，原因：%@", error);
    }];
    
    [control endRefreshing];
}

//上拉加载
- (void)pushUpLoadMore {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    Account *account = [Account accountAccessInfo];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.accessToken;
    parameters[@"count"] = @20;
    
    Tweet *lastTweet = self.tweets.lastObject;
    if (lastTweet) {
        NSUInteger maxID = [lastTweet.idstr longLongValue] - 1; //微博的ID很长，需要long long类型
        parameters[@"max_id"] = [NSString stringWithFormat:@"%ld", maxID];
    }
    
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parameters progress:nil
     
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweetsArray = responseObject[@"statuses"];
        NSMutableArray *moreTweetsArray = [NSMutableArray array];
        for (NSDictionary *dict in tweetsArray) {
            Tweet *tweet = [Tweet tweetWithDictionary:dict];
            [moreTweetsArray addObject:tweet];
        }
        [self.tweets addObjectsFromArray:moreTweetsArray];
        [self.tableView reloadData];
        [self.indicator stopAnimating];
    }
     
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求错误，原因：%@", error);
    }];
}

#pragma mark - *******************Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeLineCell *cell = [TimeLineCell cellWithTableView:tableView];
    
    return cell;
}


#pragma mark - *******************Table view delegate


#pragma mark - *******************Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.frame.size.height && self.tableView.contentSize.height > self.tableView.frame.size.height && ![self.indicator isAnimating]) {
//判断TableView是否滑倒底部
        [self.indicator startAnimating];
        [self pushUpLoadMore];
//    NSLog(@"contentOffset.y=%lf --- contentSize.height=%lf --- frame.height=%lf", self.tableView.contentOffset.y, self.tableView.contentSize.height, self.tableView.frame.size.height);
    }
}

#pragma mark - *******************Subview Layout

- (void)layoutPullDownRefresh {
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control setTintColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
    [control addTarget:self action:@selector(pullDownRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
}

- (void)layoutPushUpLoadMore {
    UIView *footView = [[UIView alloc] init];
    footView.width = [UIScreen mainScreen].bounds.size.width;
    footView.height = 44;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.centerX = footView.width * 0.5;
    indicator.centerY = footView.height * 0.5;
    self.indicator = indicator;
    [footView addSubview:indicator];
    self.tableView.tableFooterView = footView;
}

- (void)layoutViews {
    UIButton *peopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [peopleBtn setImage:[[UIImage imageNamed:@"icn_nav_bar_people_1~iphone"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [peopleBtn.imageView setTintColor:Maincolor];
    CGRect frame = peopleBtn.frame;
    frame.size = peopleBtn.currentImage.size;
    peopleBtn.frame = frame;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[[UIImage imageNamed:@"icn_title_search_default~iphone"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [searchBtn.imageView setTintColor:Maincolor];
    frame.size = searchBtn.currentImage.size;
    searchBtn.frame = frame;
    
    UIButton *tweetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tweetBtn setImage:[[UIImage imageNamed:@"icn_nav_bar_compose_tweet~iphone"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [tweetBtn.imageView setTintColor:Maincolor];
    frame.size = tweetBtn.currentImage.size;
    tweetBtn.frame = frame;
    [tweetBtn addTarget:self action:@selector(composeTweetClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:peopleBtn];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:tweetBtn], [[UIBarButtonItem alloc] initWithCustomView:searchBtn]];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icn_nav_bar_logo~iphone"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [logoView setTintColor:Maincolor];
    self.navigationItem.titleView = logoView;
}

- (void)composeTweetClick {
    TweetComposeController *composeController = [[TweetComposeController alloc] init];
    ZQNavigationController *navigationController = [[ZQNavigationController alloc] initWithRootViewController:composeController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
