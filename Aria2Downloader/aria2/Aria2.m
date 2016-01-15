//
//  Aria2.m
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "Aria2.h"
#import "JsonRPC.h"

@interface Aria2 ()
//@property (nonatomic)NSArray *tasks;
@end

@implementation Aria2

+ (void)tellActiveWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [JsonRPC requestWithMethod:@"aria2.tellActive" parameters:@"" success:success failure:failure];
}

@end
