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

@interface DownloadTableViewController ()

@property (nonatomic)NSArray *activeTasks;
@property (nonatomic)NSArray *otherTasks;

@property (nonatomic)NSTimer *timer;

@end

@implementation DownloadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"taskCell"];
    
    self.tableView.rowHeight = 72;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
//    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"下载", @"电影库"]];
    
//    segmentControl.tintColor = [UIColor clearColor];
    
//    NSDictionary *normalAttrs = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [segmentControl setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
//    self.navigationItem.titleView = segmentControl;
//    [self.navigationItem.titleView sizeToFit];
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
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [Aria2 tellStoppedWithSuccess:^(id response) {
        self.otherTasks = (NSArray *)response;
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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

//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 54;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
