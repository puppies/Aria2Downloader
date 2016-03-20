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

@interface AriaTabBarController ()

@end

@implementation AriaTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ButtonTabBar *tabBar = [[ButtonTabBar alloc] init];
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    tabBar.addNewTaskBlock = ^(){
        UINavigationController *ngc = [[UINavigationController alloc] initWithRootViewController:[[NewTaskViewController alloc] init]];
        [self presentViewController:ngc animated:YES completion:nil];
    };
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

@end
