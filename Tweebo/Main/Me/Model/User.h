//
//  User.h
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *idstr;
@property (copy, nonatomic) NSString *profileImageURL;

+ (instancetype)userWithDictionary:(NSDictionary *)dict;

@end
