//
//  DownloadTableViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/1/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "Aria2.h"
#import "Task.h"
#import "TaskTableViewCell.h"
#import "NewTaskViewController.h"
#import "UIView+extension.h"
#import "ContainerViewController.h"

@interface DownloadTableViewController ()

@property (nonatomic)NSArray *activeTasks;
@property (nonatomic)NSArray *otherTasks;

@property (nonatomic)NSTimer *timer;

@property (nonatomic)UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DownloadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载";
    
    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"taskCell"];
    
    self.tableView.rowHeight = 72;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = self.tableView.center;
    [self.tableView addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
//    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"下载", @"电影库"]];
    
//    segmentControl.tintColor = [UIColor clearColor];
    
//    NSDictionary *normalAttrs = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [segmentControl setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
//    self.navigationItem.titleView = segmentControl;
//    [self.navigationItem.titleView sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:(ContainerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController action:@selector(openSiderView)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshActiveStatus) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)refreshActiveStatus {

    [Aria2 tellActiveWithSuccess:^(id response) {
        self.activeTasks = (NSArray *)response;
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [Aria2 tellStoppedWithSuccess:^(id response) {
        self.otherTasks = (NSArray *)response;
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self.activityIndicatorView stopAnimating];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.activeTasks.count);
    if (section) {
        return self.otherTasks.count;
    } else {
        return self.activeTasks.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Task *task;
    if (indexPath.section) {
        task = self.otherTasks[indexPath.row];
        
        cell.restartBlock = ^(UITableViewCell *cell) {
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            NewTaskViewController *newTaskVC = [[NewTaskViewController alloc] init];
            newTaskVC.task = self.otherTasks[path.row];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:newTaskVC];
            [self presentViewController:nvc animated:YES completion:nil];
        };
        
    } else {
        task = self.activeTasks[indexPath.row];
        
    }
    cell.task = task;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section) {
        return @"其它";
    } else {
        return @"下载中";
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"Remove";
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
