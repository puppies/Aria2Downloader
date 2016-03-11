//
//  TaskTableViewCell.h
//  Aria2Downloader
//
//  Created by happy on 16/1/15.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Task;

typedef void (^RestartBlock)(UITableViewCell *);

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic)Task *task;
@property (nonatomic, strong)RestartBlock restartBlock;

@end
