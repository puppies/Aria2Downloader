//
//  Aria2.h
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aria2 : NSObject

+ (void)addUri:(NSString *)urlString success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)removeWithGID:(NSString *)gid success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)pauseWithGID:(NSString *)gid success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)pauseAllWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)unpauseWithGID:(NSString *)gid success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)unpauseAllWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)tellStatusWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)tellActiveWithSuccess:(void (^)(id))sucess failure:(void (^)(NSError *))failure;
+ (void)tellWaitingWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)tellStoppedWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
