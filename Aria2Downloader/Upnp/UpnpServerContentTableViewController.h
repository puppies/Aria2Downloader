//
//  UpnpServerContentTableViewController.h
//  Aria2Downloader
//
//  Created by happy on 16/3/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGUpnpAvServer;

@interface UpnpServerContentTableViewController : UITableViewController

@property (nonatomic)CGUpnpAvServer *server;
@property (nonatomic)NSArray *objects;

- (id)initWithAvServer:(CGUpnpAvServer *)aServer atIndexPath:(NSIndexPath*)aIndexPath objectId:(NSString*)anObjectId;

@end
