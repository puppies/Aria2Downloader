//
//  JsonRPC.m
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "JsonRPC.h"
#import "AFNetworking.h"

@interface JsonRPC ()

//@property (nonatomic)NSArray *tasks;

@end

@implementation JsonRPC

//+ (void)requestWithMethod:(NSString *)method parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"jsonrpc"] = @"2.0";
//    params[@"id"] = @"1";
//    params[@"method"] = method;
//    if (parameters) {
//        params[@"params"] = parameters;
//    }
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//    [manager POST:@"http://192.168.1.1:6800/jsonrpc" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSLog(@"%@", responseObject);
//        NSArray *tasks = [NSArray yy_modelArrayWithClass:[Task class] json:responseObject[@"result"]];
//        success(tasks);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
////        failure(error);
//    }];
//
//}


+ (void)requestWithMethod:(NSString *)method parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"jsonrpc"] = @"2.0";
    params[@"id"] = @"1";
    params[@"method"] = method;
    if (parameters) {
        params[@"params"] = parameters;
    }
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:@"http://192.168.1.1:6800/jsonrpc" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@", responseObject);
//        NSArray *tasks = [NSArray yy_modelArrayWithClass:[Task class] json:responseObject[@"result"]];
        id result = responseObject[@"result"];
        success(result);

        //return responseObject[@"result"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (failure) {
            failure(error);
        }
        //return nil;
    }];
    
}



@end
