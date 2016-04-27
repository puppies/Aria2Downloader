//
//  UpnpDeviceTableViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "UpnpDeviceTableViewController.h"
#import "mUPnP/mUPnP.h"
#import "UpnpServerContentTableViewController.h"
@interface UpnpDeviceTableViewController () <CGUpnpControlPointDelegate>

@property (nonatomic)NSArray *renderers;
@property (nonatomic)NSArray *servers;

@property (nonatomic)UIActivityIndicatorView *activityIndicatorView;

@end

@implementation UpnpDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DLNA";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"deviceCell"];
    
    self.tableView.rowHeight = 72;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    CGUpnpAvController *avController = [[CGUpnpAvController alloc] init];
    avController.delegate = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [avController search];
    });
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = self.tableView.center;
    [self.tableView addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
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
    return self.servers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    
    // Configure the cell...
    CGUpnpDevice *device = self.servers[indexPath.row];
    cell.textLabel.text = device.friendlyName;
    cell.imageView.image = [UIImage imageNamed:@"device-drive"];
//    cell.detailTextLabel.text = device.deviceType;
//    NSLog(@"%@", device.deviceType);
//

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UpnpServerContentTableViewController *contentController = [[UpnpServerContentTableViewController alloc] initWithAvServer:self.servers[indexPath.row] atIndexPath:indexPath objectId:@"0"];
    UpnpServerContentTableViewController *contentController = [[UpnpServerContentTableViewController alloc] initWithAvServer:self.servers[indexPath.row] atIndexPath:indexPath objectId:@"0"];

    contentController.title = [self.servers[indexPath.row] friendlyName];
    
    [self.navigationController pushViewController:contentController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.transform = CGAffineTransformMakeTranslation(tableView.bounds.size.width, 0);
    [UIView animateWithDuration:1.6 delay:0.05 * indexPath.row usingSpringWithDamping:0.77 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:nil];

}

#pragma mark - CGUpnpAvControllerDelegate

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
    CGUpnpAvController *avController = (CGUpnpAvController *)controlPoint;
    self.renderers = avController.renderers;
    self.servers = avController.servers;

//    for (CGUpnpAvServer *servrer in self.servers) {
//        NSLog(@"%@ %@", servrer.friendlyName, servrer.deviceType);
//        [servrer start];
//    }
    [self.activityIndicatorView stopAnimating];
    
    [self.tableView reloadData];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
