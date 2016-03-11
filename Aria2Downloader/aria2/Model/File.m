//
//  File.m
//  Aria2Downloader
//
//  Created by happy on 16/1/15.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "File.h"
#import "Uri.h"

@implementation File

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"uris" : [Uri class]
             };
}

@end
