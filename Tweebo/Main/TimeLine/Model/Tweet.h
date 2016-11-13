//
//  Tweet.h
//  Tweebo
//
//  Created by 苍曜石 on 16/8/26.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, Photo;

@interface Tweet : NSObject

@property (copy, nonatomic) NSString *idstr;
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) User *user;
@property (copy, nonatomic) NSString *creatTime;

@property (strong, nonatomic) NSArray<Photo *> *photos;

@property (strong, nonatomic) Tweet *retweet;

@property (strong, nonatomic) NSNumber *retweetsCount;
@property (strong, nonatomic) NSNumber *commentsCount;
@property (strong, nonatomic) NSNumber *attitudesCount;

+ (instancetype)tweetWithDictionary:(NSDictionary *)dict;


@end
