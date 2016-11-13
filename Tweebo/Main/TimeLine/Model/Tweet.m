//
//  Tweet.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/26.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Tweet.h"
#import "Photo.h"
#import "User.h"

@implementation Tweet

+ (instancetype)tweetWithDictionary:(NSDictionary *)dict {
    Tweet *tweet = [[Tweet alloc] init];
    tweet.idstr = dict[@"idstr"];
    tweet.text = dict[@"text"];
    tweet.user = [User userWithDictionary:dict[@"user"]];
    tweet.creatTime = dict[@"created_at"];
    tweet.photos = [Photo photosWithDictionary:dict[@"pic_urls"]];
    tweet.retweet = [Tweet retweetWithDictionary:dict[@"retweeted_status"]];
    tweet.retweetsCount = dict[@"reposts_count"];
    tweet.commentsCount = dict[@"comments_count"];
    tweet.attitudesCount = dict[@"attitudes_count"];
    
    return tweet;
}

+ (instancetype)retweetWithDictionary:(NSDictionary *)dictionary {
    Tweet *retweet = [[Tweet alloc] init];
    retweet.idstr = dictionary[@"idstr"];
    retweet.text = dictionary[@"text"];
    retweet.user = [User userWithDictionary:dictionary[@"user"]];
    retweet.creatTime = dictionary[@"created_at"];
    retweet.photos = [Photo photosWithDictionary:dictionary[@"pic_urls"]];
    retweet.retweetsCount = dictionary[@"reposts_count"];
    retweet.commentsCount = dictionary[@"comments_count"];
    retweet.attitudesCount = dictionary[@"attitudes_count"];
    return retweet;
}

- (NSString *)creatTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    
    NSDate *creatTime = [formatter dateFromString:_creatTime];
    NSDate *currentTime = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour fromDate:creatTime toDate:currentTime options:0];
    NSInteger hourComps = [calendar component:NSCalendarUnitHour fromDate:currentTime];
    //    NSLog(@"comps = %ld", comps.hour);
    
    if (comps.day == 0 && comps.hour < hourComps) {
        formatter.dateFormat = @"HH:mm";
    } else {
        formatter.dateFormat = @"M-d HH:mm";
    }
    
    
    
    //    NSDate *currentTime = [NSDate date];
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //    NSDateComponents *comps = [calendar components:calendarUnit fromDate:creatTime toDate:currentTime options:0];
    
    
    return [formatter stringFromDate:creatTime];
}

//- (BOOL)isThisYear:(NSDate *)date {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear fromDate:date];
//    NSDateComponents *currentComps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
//    return dateComps.year == currentComps.year;
//}

@end
