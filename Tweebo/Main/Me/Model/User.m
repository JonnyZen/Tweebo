//
//  User.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)userWithDictionary:(NSDictionary *)dict {
    User *user = [[User alloc] init];
    user.name = dict[@"name"];
    user.idstr = dict[@"idstr"];
    user.profileImageURL = dict[@"profile_image_url"];
    return user;
}

@end
