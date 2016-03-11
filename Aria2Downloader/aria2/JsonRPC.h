//
//  JsonRPC.h
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonRPC : NSObject

+ (void)requestWithMethod:(NSString *)method parameters:(id)parameters success:(void (^)(id response))sucess failure:(void (^)(NSError *error))failure;

@end
