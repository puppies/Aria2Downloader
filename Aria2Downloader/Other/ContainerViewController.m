//
//  ContainerViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/28.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "ContainerViewController.h"
#import "AriaTabBarController.h"
#import "SettingTableViewController.h"
#import "UIView+extension.h"

const unsigned int SettingViewWidth = 250;

@interface ContainerViewController () <UIGestureRecognizerDelegate>

@property (nonatomic)SettingTableViewController *settingViewController;
@property (nonatomic)UITapGestureRecognizer *tapRecognizer;
@property (nonatomic)AriaTabBarController *tabBarController;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *settingTableViewStoryBoard = [UIStoryboard storyboardWithName:@"SettingTableViewController" bundle:nil];
    SettingTableViewController *settingViewController = [settingTableViewStoryBoard instantiateViewControllerWithIdentifier:@"settingTableView"];
    settingViewController.tableView.x = -SettingViewWidth;
    settingViewController.tableView.y = 0;
    settingViewController.tableView.size = CGSizeMake(SettingViewWidth, self.view.height);
//    settingViewController.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:settingViewController];
    [self.view addSubview:settingViewController.tableView];
    [settingViewController didMoveToParentViewController:self];
    self.settingViewController = settingViewController;

    AriaTabBarController *tabBarController = [[AriaTabBarController alloc] init];
    
    [self addChildViewController:tabBarController];
    [self.view addSubview:tabBarController.view];
    [tabBarController didMoveToParentViewController:self];
    self.tabBarController = tabBarController;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSiderView)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    self.tapRecognizer = tapRecognizer;
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeSiderView)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openSiderView)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
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
- (void)openSiderView {
    self.tabBarController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.settingViewController.view.x = 0;
        self.tabBarController.view.x = SettingViewWidth;
    }];
}

- (void)closeSiderView {
    self.tabBarController.view.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.settingViewController.view.x = -SettingViewWidth;
        self.tabBarController.view.x = 0;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.view];
    if (gestureRecognizer == self.tapRecognizer) {
        return (self.settingViewController.view.frame.origin.x == 0) && !CGRectContainsPoint(self.settingViewController.view.frame, point);
    }
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
