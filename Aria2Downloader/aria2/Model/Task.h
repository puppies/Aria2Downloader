//
//  Task.h
//  Aria2Downloader
//
//  Created by happy on 16/1/15.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, copy) NSString        *gid;
@property (nonatomic, copy) NSString        *status;
@property (nonatomic, assign) NSUInteger    totalLength;
@property (nonatomic, assign) NSUInteger    completedLength;
@property (nonatomic, assign) NSUInteger    uploadLength;
@property (nonatomic, copy) NSString        *bitfield;
@property (nonatomic, assign) NSUInteger    downloadSpeed;
@property (nonatomic, assign) NSUInteger    uploadSpeed;
@property (nonatomic, assign) NSUInteger    numSeeders;

@property (nonatomic, assign) NSUInteger    pieceLength;
@property (nonatomic, assign) NSUInteger    numPieces;
@property (nonatomic, assign) NSUInteger    connections;
@property (nonatomic, copy) NSString        *errorCode;
@property (nonatomic, copy) NSString        *errorMessage;

@property (nonatomic)NSArray *followedBy;
@property (nonatomic, copy) NSString *belongsTo;

@property (nonatomic, copy) NSString *dir;
@property (nonatomic)NSArray *files;
//@property (nonatomic)Bittorrent *bittorrent;

@end
