//
//  JsonRPC.m
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "JsonRPC.h"
#import "AFNetworking.h"
#import "Task.h"
#import "YYModel.h"

@interface JsonRPC ()

//@property (nonatomic)NSArray *tasks;

@end

@implementation JsonRPC

+ (void)requestWithMethod:(NSString *)method parameters:(NSString *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"jsonrpc"] = @"2.0";
    params[@"id"] = @"1";
    params[@"method"] = method;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager POST:@"http://192.168.1.1:6800/jsonrpc" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
        NSArray *tasks = [NSArray yy_modelArrayWithClass:[Task class] json:responseObject[@"result"]];
        success(tasks);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        failure(error);
    }];

}
@end
