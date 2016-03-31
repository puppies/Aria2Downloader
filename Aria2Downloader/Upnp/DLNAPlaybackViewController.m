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

@property (nonatomic)IBOutlet UIView *topView;
@property (nonatomic)IBOutlet UIToolbar *bottomToolBar;


@property (weak, nonatomic) IBOutlet UILabel *timePassedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (nonatomic)UIButton            *infoButton;

@property (nonatomic)UIBarButtonItem     *playBtn;
@property (nonatomic)UIBarButtonItem     *pauseBtn;
@property (nonatomic)UIBarButtonItem     *rewindBtn;
@property (nonatomic)UIBarButtonItem     *fforwardBtn;
@property (nonatomic)UIBarButtonItem     *spaceItem;
@property (nonatomic)UIBarButtonItem     *fixedSpaceItem;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic)id playerObserver;

@end

@implementation DLNAPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ UIColor blackColor];
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
//    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//    self.navigationController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
//    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = NO;
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    
    
//    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
//    _activityIndicatorView.center = self.view.center;
//    [self.view addSubview:_activityIndicatorView];
//    
//    CGFloat width = self.view.bounds.size.width;
//    CGFloat height = self.view.bounds.size.height;
//    CGFloat topH = 50;
//    CGFloat botH = 50;
//    
//    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, topH)];
//    _topView.tintColor = [UIColor whiteColor];
//    _bottomToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height - botH, width, botH)];
//    [self.view addSubview:_topView];
//    [self.view addSubview:_bottomToolBar];
    
    [self.activityIndicatorView startAnimating];
}

- (void)setItem:(CGUpnpAvItem *)item {
    _item = item;
    
    if (!self.player) {
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.item.resourceUrl];
        NSLog(@"resourceUrl: %@", self.item.resourceUrl);
        
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:nil];
    }
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
//
//}
    
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
    NSLog(@"%ld", (long)self.player.status);

//    [self.player play];

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

static NSString * formatTimeInterval(CGFloat seconds, BOOL isLeft)
{
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%ld:%0.2ld", (long)h, (long)m];
    else        [format appendFormat:@"%ld", (long)m];
    [format appendFormat:@":%0.2ld", (long)s];
    
    return format;
}

//- (AVPlayer *)player {
//    if (!_player) {
//        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.item.resourceUrl];
//        NSLog(@"resourceUrl: %@", self.item.resourceUrl);
//        
//        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
//        
//        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//        
//        _layer = [AVPlayerLayer playerLayerWithPlayer:_player];
//
//        _layer.frame = self.view.bounds;
//        NSLog(@"%@", NSStringFromCGRect(_layer.frame));
//        _layer.backgroundColor = [UIColor blackColor].CGColor;
////        self.view.layer.backgroundColor = [UIColor redColor].CGColor;
//
//        [self.view.layer insertSublayer:_layer atIndex:0];
//    }
//    return _player;
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"] && self.player.status == AVPlayerStatusReadyToPlay) {
        
        if (!self.layer) {
            self.layer = [AVPlayerLayer playerLayerWithPlayer:_player];
            
            self.layer.frame = self.view.bounds;
            NSLog(@"%@", NSStringFromCGRect(_layer.frame));
            self.layer.backgroundColor = [UIColor blackColor].CGColor;
            //        self.view.layer.backgroundColor = [UIColor redColor].CGColor;
            
            [self.view.layer insertSublayer:self.layer atIndex:0];
        }
        
        CGFloat duration = self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
        
        CMTime interval = CMTimeMake(1.0, 1);
        __weak __typeof(&*self)weakSelf = self;
        
        self.playerObserver = [_player addPeriodicTimeObserverForInterval:interval queue:nil usingBlock:^(CMTime time) {
            CGFloat timePassed = self.player.currentTime.value / self.player.currentTime.timescale;
            weakSelf.timePassedLabel.text = formatTimeInterval(timePassed, NO);
            
            CGFloat secondsLeft = duration - timePassed;
            weakSelf.timeLeftLabel.text = formatTimeInterval(secondsLeft, YES);
            
            weakSelf.progressSlider.value = timePassed / duration;
        }];
        
        [self.activityIndicatorView stopAnimating];
        
        [self.player play];
    }
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
    [UIApplication sharedApplication].statusBarHidden = ! [UIApplication sharedApplication].statusBarHidden;
    self.topView.hidden = !self.topView.isHidden;
    self.bottomToolBar.hidden = !self.bottomToolBar.isHidden;
    
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

- (IBAction)close:(id)sender {
    [self.player pause];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
