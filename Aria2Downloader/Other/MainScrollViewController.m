//
//  MainScrollViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/13.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "MainScrollViewController.h"
#import "DownloadTableViewController.h"
#import "UpnpDeviceTableViewController.h"
#import "UIView+extension.h"

@interface MainScrollViewController () <UIScrollViewDelegate>

@property (nonatomic)DownloadTableViewController *downloadTableViewController;
@property (nonatomic)UpnpDeviceTableViewController *deviceTableViewController;

@end

@implementation MainScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DownloadTableViewController *downloadTableViewController = [[DownloadTableViewController alloc] init];
    self.downloadTableViewController = downloadTableViewController;
    [self addChildViewController:downloadTableViewController];
    
    UpnpDeviceTableViewController *deviceTableViewController = [[UpnpDeviceTableViewController alloc] init];
    self.deviceTableViewController = deviceTableViewController;
    [self addChildViewController:deviceTableViewController];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    NSLog(@"%@", NSStringFromCGRect(scrollView.frame));
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.view.width * self.childViewControllers.count, 0);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
//    scrollView.backgroundColor = [UIColor redColor];
//    downloadTableViewController.view.frame = self.view.bounds;


//    [scrollView addSubview:downloadTableViewController.view];
    
    [self.view addSubview:scrollView];
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));

    NSLog(@"%@", NSStringFromCGRect(downloadTableViewController.view.frame));
    NSLog(@"%d", self.automaticallyAdjustsScrollViewInsets);
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.downloadTableViewController viewWillAppear:animated];
    
    self.downloadTableViewController.view.frame = self.view.bounds;
    NSLog(@"%d", self.automaticallyAdjustsScrollViewInsets);

    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    NSLog(@"%@", NSStringFromCGRect(self.downloadTableViewController.view.frame));

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.downloadTableViewController viewWillDisappear:animated];
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    
    UITableViewController *tvc = self.childViewControllers[index];
    tvc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, self.tabBarController.tabBar.height, 0);
//    tvc.view.size = self.view.size;
    
    tvc.view.x = scrollView.contentOffset.x;
    tvc.view.y = scrollView.y;
    [scrollView addSubview:tvc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
