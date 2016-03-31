//
//  DLNAPlaybackViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "DLNAPlaybackViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "mUPnP.h"
#import "UIView+extension.h"

@interface DLNAPlaybackViewController ()

@property (nonatomic)AVPlayer *player;
@property (nonatomic)AVPlayerLayer *layer;

@end

@implementation DLNAPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [ UIColor whiteColor];
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
//    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//    self.navigationController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
//    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = self.item.title;
    [title sizeToFit];
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
//
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.player play];
    
    
//    [UIViewController attemptRotationToDeviceOrientation];

    NSLog(@"%@", NSStringFromCGRect(self.view.layer.frame));

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;

}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    self.navigationController.view.transform = CGAffineTransformIdentity;
//    self.navigationController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//}

- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.item.resourceUrl];
        NSLog(@"resourceUrl: %@", self.item.resourceUrl);
        
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        _layer = [AVPlayerLayer playerLayerWithPlayer:_player];
//        _layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);

        _layer.frame = self.view.bounds;
        NSLog(@"%@", NSStringFromCGRect(_layer.frame));
        _layer.backgroundColor = [UIColor blackColor].CGColor;
//        self.view.layer.backgroundColor = [UIColor redColor].CGColor;

        [self.view.layer addSublayer:_layer];
    }
    return _player;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
    NSLog(@"%d", self.navigationController.navigationBar.isHidden);
    [UIApplication sharedApplication].statusBarHidden = ! [UIApplication sharedApplication].statusBarHidden;
    
//    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    
//    _layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);


}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeLeft;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}

- (void)didOrientation {
    CGFloat y, height;
    if ([UIDevice currentDevice].orientation & UIDeviceOrientationPortrait) {
        height = self.view.width * 9 / 16;
        y = (self.view.height - height) / 2;

    } else {
        height = self.view.height;
        y = 0;
    }
    self.layer.frame = CGRectMake(0, y, self.view.width, height);
}

@end
