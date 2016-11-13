//
//  Photo.h
//  Tweebo
//
//  Created by 苍曜石 on 16/8/26.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (copy, nonatomic) NSString *thumbnailPic;

+ (NSArray<Photo *> *)photosWithDictionary:(NSDictionary *)dict;

@end
