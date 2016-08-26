//
//  ZQNavigationController.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "ZQNavigationController.h"
#import "Constant.h"
#import "UIView+Extension.h"

@interface ZQNavigationController ()

@end

@implementation ZQNavigationController

+ (void)initialize {
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = Maincolor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    disableTextAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:14];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = Maincolor;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"back~iphone"] forState:UIControlStateNormal];
        backButton.size = backButton.currentImage.size;
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
