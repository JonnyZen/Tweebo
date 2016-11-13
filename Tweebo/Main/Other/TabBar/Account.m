//
//  Account.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/9.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (instancetype)accountWithDictionary:(NSDictionary *)dict {
    Account *account = [[self alloc] init];
    account.accessToken = dict[@"access_token"];
    account.expiresIn = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    return account;
}

+ (void)accountAccessInfoSavingWithDictionary:(NSDictionary *)dict {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accessInfoPath = [documentPath stringByAppendingString:@"accessInfo.archive"];
    
    Account *account = [Account accountWithDictionary:dict];
    [NSKeyedArchiver archiveRootObject:account toFile:accessInfoPath];
}

+ (instancetype)accountAccessInfo {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accessInfoPath = [documentPath stringByAppendingString:@"accessInfo.archive"];
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:accessInfoPath];
    return account;
}

#pragma mark - ************ NSCode Delegate

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.accessToken = [aDecoder decodeObjectForKey:@"access_token"];
        self.expiresIn = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.accessToken forKey:@"access_token"];
    [coder encodeObject:self.expiresIn forKey:@"expires_in"];
    [coder encodeObject:self.uid forKey:@"uid"];
}

@end
