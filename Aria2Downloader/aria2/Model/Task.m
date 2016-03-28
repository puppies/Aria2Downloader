//
//  Task.m
//  Aria2Downloader
//
//  Created by happy on 16/1/15.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "Task.h"
#import "YYModel.h"
#import "DFile.h"

@implementation Task

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"files" : [DFile class]
            };
}

@end
