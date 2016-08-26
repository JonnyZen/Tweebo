//
//  Photo.m
//  Tweebo
//
//  Created by 苍曜石 on 16/8/26.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+ (NSArray<Photo *> *)photosWithDictionary:(NSDictionary *)dict {
    if (dict) {
        NSMutableArray *photos = [NSMutableArray array];
        for (NSDictionary *dictionary in dict) {
            Photo *photo = [[Photo alloc] init];
            photo.thumbnailPic = dictionary[@"thumbnail_pic"];
            [photos addObject:photo];
        }
        return photos;
    }
    else return nil;
}

@end
