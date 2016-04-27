//
//  AriaTabBarController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/4.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "AriaTabBarController.h"
#import "ButtonTabBar.h"
#import "NewTaskViewController.h"
#import "MainScrollViewController.h"
#import "DownloadTableViewController.h"
#import "UpnpDeviceTableViewController.h"
#import "SegmentNavigationController.h"

@interface AriaTabBarController ()

@end

@implementation AriaTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        DownloadTableViewController *downloadTableViewController = [[DownloadTableViewController alloc] init];
        SegmentNavigationController *nvc1 = [[SegmentNavigationController alloc] initWithRootViewController:downloadTableViewController];
        nvc1.tabBarItem.title = @"下载";
        nvc1.tabBarItem.image = [UIImage imageNamed:@"download"];
        nvc1.tabBarItem.selectedImage = [UIImage imageNamed:@"download-selected"];
        [self addChildViewController:nvc1];
        
        UpnpDeviceTableViewController *upnpDeviceTableViewController = [[UpnpDeviceTableViewController alloc] init];
        SegmentNavigationController *nvc2 = [[SegmentNavigationController alloc] initWithRootViewController:upnpDeviceTableViewController];
        nvc2.tabBarItem.title = @"DLNA";
        nvc2.tabBarItem.image = [UIImage imageNamed:@"dlna"];
        nvc2.tabBarItem.selectedImage = [UIImage imageNamed:@"dlna-selected"];
        [self addChildViewController:nvc2];
        
        ButtonTabBar *tabBar = [[ButtonTabBar alloc] init];
        
        [self setValue:tabBar forKeyPath:@"tabBar"];
        
        tabBar.addNewTaskBlock = ^(){
            UINavigationController *ngc = [[UINavigationController alloc] initWithRootViewController:[[NewTaskViewController alloc] init]];
            [self presentViewController:ngc animated:YES completion:nil];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

@end
