//
//  Account.h
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *expiresIn;
@property (copy, nonatomic) NSString *uid;

+ (void)accountAccessInfoSavingWithDictionary:(NSDictionary *)dict;

+ (instancetype)accountWithDictionary:(NSDictionary *)dict;

+ (instancetype)accountAccessInfo;

@end
