//
//  UpnpServerContentTableViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "UpnpServerContentTableViewController.h"
#import "mUPnP/mUPnP.h"
#import "DLNAPlaybackViewController.h"

@interface UpnpServerContentTableViewController ()

@end

@implementation UpnpServerContentTableViewController

- (id)initWithAvServer:(CGUpnpAvServer *)aServer atIndexPath:(NSIndexPath*)aIndexPath objectId:(NSString *)anObjectId
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.server = (CGUpnpAvServer *)aServer;
        self.objects = [self.server browseDirectChildren:anObjectId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contentCell"];
    
//    self.title = self.server.friendlyName;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.objects = [self.server browseDirectChildren:self.objectId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    CGUpnpAvObject *object = self.objects[indexPath.row];
    
    cell.textLabel.text = object.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUpnpAvObject *object = self.objects[indexPath.row];
    if (object.isItem) {
        CGUpnpAvItem *item = (CGUpnpAvItem *)object;
        CGUpnpAvResource *resource = item.resource;
        NSLog(@"item: %@, resource: %@, url:%@", item.title, resource.protocolInfo, item.resourceUrl);
        
        self.title = item.title;
        
        
        DLNAPlaybackViewController *playbackViewController = [[DLNAPlaybackViewController alloc] init];
        playbackViewController.item = item;

        [self.navigationController pushViewController:playbackViewController animated:YES];
        
    } else {
        UpnpServerContentTableViewController *contentController = [[UpnpServerContentTableViewController alloc] initWithAvServer:self.server atIndexPath:indexPath objectId:object.objectId];
        
        contentController.title = object.title;
        
        [self.navigationController pushViewController:contentController animated:YES];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

@end
