//
//  TimeLineCell.h
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface TimeLineCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
