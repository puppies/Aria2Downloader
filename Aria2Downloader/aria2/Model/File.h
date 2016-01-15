//
//  File.h
//  Aria2Downloader
//
//  Created by happy on 16/1/15.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *path;
@property (nonatomic) NSUInteger *length;
@property (nonatomic) NSUInteger *completedLength;
@property (nonatomic,assign)BOOL selected;
@property (nonatomic)NSArray *uris;

@end
