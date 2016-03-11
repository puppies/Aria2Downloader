//
//  Aria2.m
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "Aria2.h"
#import "JsonRPC.h"
#import "YYModel.h"
#import "Task.h"

@class Task;

@interface Aria2 ()
//@property (nonatomic)NSArray *tasks;
@end

@implementation Aria2

+ (void)addUri:(NSString *)urlString success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [JsonRPC requestWithMethod:@"aria2.addUri" parameters:@[@[urlString]] success:^(id response) {
        NSString *gid = (NSString *)response;
        if (success) {
            success(gid);
        }
    } failure:failure];
}

+ (void)removeWithGID:(NSString *)gid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [JsonRPC requestWithMethod:@"aria2.remove" parameters:@[gid] success:^(id response) {
        NSString *gid = (NSString *)response;
        if (success) {
            success(gid);
        }
    } failure:failure];
}

+ (void)pauseWithGID:(NSString *)gid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [JsonRPC requestWithMethod:@"aria2.pause" parameters:@[gid] success:^(id response) {
        NSString *gid = (NSString *)response;
        if (success) {
            success(gid);
        }
    } failure:failure];
}

+ (void)pauseAllWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [JsonRPC requestWithMethod:@"aria2.pauseAll" parameters:nil success:^(id response) {
        NSString *gid = (NSString *)response;
        if (success) {
            success(gid);
        }
    } failure:failure];
}

+ (void)unpauseWithGID:(NSString *)gid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [JsonRPC requestWithMethod:@"aria2.unpause" parameters:@[gid] success:^(id response) {
        NSString *gid = (NSString *)response;
        if (success) {
            success(gid);
        }
    } failure:failure];
}

+ (void)unpauseAllWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [JsonRPC requestWithMethod:@"aria2.unpauseAll" parameters:nil success:^(id response) {
        NSString *gid = (NSString *)response;
        if (success) {
            success(gid);
        }
    } failure:failure];
}

+ (void)tellStatusWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    //    [JsonRPC requestWithMethod:@"aria2.tellActive" parameters:nil success:success failure:failure];
    [JsonRPC requestWithMethod:@"aria2.tellStatus" parameters:nil success:^(id response) {
        Task *task = [Task yy_modelWithJSON:response];
        success(task);
    } failure:failure];
}

+ (void)tellActiveWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    //    [JsonRPC requestWithMethod:@"aria2.tellActive" parameters:nil success:success failure:failure];
    [JsonRPC requestWithMethod:@"aria2.tellActive" parameters:nil success:^(id response) {
        NSArray *tasks = [NSArray yy_modelArrayWithClass:[Task class] json:response];
        success(tasks);
    } failure:failure];
}

+ (void)tellWaitingWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    //    [JsonRPC requestWithMethod:@"aria2.tellActive" parameters:nil success:success failure:failure];
    [JsonRPC requestWithMethod:@"aria2.tellWaiting" parameters:@[@-1, @100] success:^(id response) {
        NSArray *tasks = [NSArray yy_modelArrayWithClass:[Task class] json:response];
        success(tasks);
    } failure:failure];
}

+ (void)tellStoppedWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    //    [JsonRPC requestWithMethod:@"aria2.tellActive" parameters:nil success:success failure:failure];
    [JsonRPC requestWithMethod:@"aria2.tellStopped" parameters:@[@-1, @100] success:^(id response) {
        NSArray *tasks = [NSArray yy_modelArrayWithClass:[Task class] json:response];
        success(tasks);
    } failure:failure];
}

@end
