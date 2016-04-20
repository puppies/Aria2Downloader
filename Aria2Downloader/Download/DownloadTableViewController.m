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

//@property (assign)BOOL shouldAnimate;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:(ContainerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController action:@selector(openSiderView)];
    
//    self.shouldAnimate = YES;
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

        [self.activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [Aria2 tellStoppedWithSuccess:^(id response) {
        self.otherTasks = (NSArray *)response;

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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.shouldAnimate) {
//        cell.transform = CGAffineTransformMakeTranslation(tableView.width, 0);
//        [UIView animateWithDuration:1.6 delay:0.05 * indexPath.row usingSpringWithDamping:0.77 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            cell.transform = CGAffineTransformIdentity;
//        } completion:nil];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (cell == tableView.visibleCells.lastObject) {
//        self.shouldAnimate = NO;
//    }
//}

@end
