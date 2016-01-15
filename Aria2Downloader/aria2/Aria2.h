//
//  Aria2.h
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aria2 : NSObject

+ (void)tellActiveWithSuccess:(void (^)(id response))sucess failure:(void (^)(NSError *error))failure;

@end
