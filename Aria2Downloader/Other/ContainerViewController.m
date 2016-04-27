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

const int SettingViewWidth = 250;

@interface ContainerViewController () <UIGestureRecognizerDelegate>

@property (nonatomic)SettingTableViewController *settingViewController;
@property (nonatomic)UITapGestureRecognizer *tapRecognizer;
//@property (nonatomic)UIPanGestureRecognizer *swipeRightRecognizer;
@property (nonatomic)UIPanGestureRecognizer *swipeLeftRecognizer;

@property (nonatomic)AriaTabBarController *tabBarController;

@end

@implementation ContainerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIStoryboard *settingTableViewStoryBoard = [UIStoryboard storyboardWithName:@"SettingTableViewController" bundle:nil];
        SettingTableViewController *settingViewController = [settingTableViewStoryBoard instantiateViewControllerWithIdentifier:@"settingTableView"];
        
        //    settingViewController.view.backgroundColor = [UIColor redColor];
//        [self.view addSubview:settingViewController.view];
//        [self addChildViewController:settingViewController];
//        [settingViewController didMoveToParentViewController:self];
        self.settingViewController = settingViewController;
        
        AriaTabBarController *tabBarController = [[AriaTabBarController alloc] init];
        
        [self addChildViewController:tabBarController];
        [self.view addSubview:tabBarController.view];
        [tabBarController didMoveToParentViewController:self];
        self.tabBarController = tabBarController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSiderView)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    self.tapRecognizer = tapRecognizer;
    
    UIPanGestureRecognizer *swipeLeftRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    self.swipeLeftRecognizer = swipeLeftRecognizer;
    
//    UIPanGestureRecognizer *swipeRightRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(openSiderView)];
////    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRightRecognizer];
//    self.swipeRightRecognizer = swipeRightRecognizer;

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
    NSLog(@"%s", __func__);
//    self.swipeRightRecognizer.enabled = NO;
    
    [self addChildViewController:self.settingViewController];
    
    self.settingViewController.view.x = -SettingViewWidth;
    NSLog(@"%@", NSStringFromCGRect(self.settingViewController.view.frame));
//    self.settingViewController.view.x = -250;

    self.settingViewController.view.size = CGSizeMake(SettingViewWidth, self.view.height );
    self.settingViewController.view.centerY = self.view.centerY;
    
    [self.view addSubview:self.settingViewController.view];
    [self.settingViewController didMoveToParentViewController:self];
    
    self.tabBarController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
        self.settingViewController.view.x = 0;
//        self.tabBarController.view.x = SettingViewWidth;
    } completion:^(BOOL finished) {
        self.swipeLeftRecognizer.enabled = YES;
    }];
    
}

- (void)closeSiderView {
    NSLog(@"%s", __func__);

    self.swipeLeftRecognizer.enabled = NO;
    
    self.tabBarController.view.userInteractionEnabled = YES;
    NSLog(@"%@", NSStringFromCGRect(self.settingViewController.view.frame));


    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:0 animations:^{
        self.settingViewController.view.x = -SettingViewWidth - 10;
//        self.tabBarController.view.x = 0;
    } completion:^(BOOL finished) {
        [self.settingViewController.view removeFromSuperview];
        [self.settingViewController willMoveToParentViewController:nil];
        [self.settingViewController removeFromParentViewController];
//        self.swipeRightRecognizer.enabled = YES;

        NSLog(@"%@", NSStringFromCGRect(self.settingViewController.view.frame));

    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer {
    NSLog(@"%s", __func__);
    if (self.settingViewController.parentViewController == nil) {
        [self addChildViewController:self.settingViewController];
        
        self.settingViewController.view.x = -SettingViewWidth;
        NSLog(@"%@", NSStringFromCGRect(self.settingViewController.view.frame));
        //    self.settingViewController.view.x = -250;
        
        self.settingViewController.view.size = CGSizeMake(SettingViewWidth, self.view.height );
        self.settingViewController.view.centerY = self.view.centerY;
        
        [self.view addSubview:self.settingViewController.view];
        [self.settingViewController didMoveToParentViewController:self];
    }
    CGPoint distance = [panGestureRecognizer translationInView:self.view];
    if (CGRectGetMaxX(self.settingViewController.view.frame) < 0 ) {
        self.settingViewController.view.x += distance.x;
    }
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
    NSLog(@"%@", NSStringFromCGRect(self.settingViewController.view.frame));

}

#pragma mark - UIGestureRecognizerDelegate

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
