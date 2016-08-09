//
//  ZQTabBarController.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "ZQTabBarController.h"
#import "ZQNavigationController.h"

#import "TimeLineViewController.h"
#import "FavoriteViewController.h"
#import "MessageViewController.h"
#import "UserViewController.h"

@interface ZQTabBarController ()

@end

@implementation ZQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor colorWithRed:29/255.0 green:160/255.0 blue:241/255.0 alpha:1.0];
    
    [self initTabBarItem];
    
}

- (void)initTabBarItem {
    TimeLineViewController *timeLineVC = [[TimeLineViewController alloc] init];
    [self addChildViewController:timeLineVC WithTitle:@"TimeLine" andImage:[UIImage imageNamed:@"icn_tab_bar_home_large~iphone"]];
    
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self addChildViewController:messageVC WithTitle:@"私信" andImage:[UIImage imageNamed:@"icn_tab_bar_messages_large~iphone"]];
    
    FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] init];
    [self addChildViewController:favoriteVC WithTitle:@"通知" andImage:[UIImage imageNamed:@"icn_tab_bar_notifications_large~iphone"]];
    
    UserViewController *userVC = [[UserViewController alloc] init];
    [self addChildViewController:userVC WithTitle:@"我" andImage:[UIImage imageNamed:@"icn_tab_bar_profile_large~iphone"]];
    
}

- (void)addChildViewController:(UIViewController *)childController WithTitle:(NSString *)title andImage:(UIImage *)image {
    childController.title = title;
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:29/255.0 green:160/255.0 blue:241/255.0 alpha:1.0];
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateSelected];
    childController.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ZQNavigationController *navigationController = [[ZQNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
