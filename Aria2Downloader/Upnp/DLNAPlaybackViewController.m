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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *playBtn;

@property (nonatomic)UIBarButtonItem     *pauseBtn;
@property (nonatomic)UIBarButtonItem     *rewindBtn;
@property (nonatomic)UIBarButtonItem     *fforwardBtn;
@property (nonatomic)UIBarButtonItem     *spaceItem;
@property (nonatomic)UIBarButtonItem     *fixedSpaceItem;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic)id playerObserver;

@property (nonatomic)NSTimer *hideTimer;

@end

@implementation DLNAPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ UIColor blackColor];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];    
    
    [self.activityIndicatorView startAnimating];
    self.playBtn.target = self;
    self.playBtn.action = @selector(play);
    
    [self.progressSlider addTarget:self action:@selector(seek) forControlEvents:UIControlEventValueChanged];
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
    
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:8 target:self selector:@selector(hideUI) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.hideTimer = timer;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self.player removeTimeObserver:self.playerObserver];
    
    [self.hideTimer invalidate];
    self.hideTimer = nil;
}

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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"] && self.player.status == AVPlayerStatusReadyToPlay) {
        
        if (!self.layer) {
            self.layer = [AVPlayerLayer playerLayerWithPlayer:_player];
            self.layer.contentsGravity = kCAGravityResizeAspect;
            
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
        self.playBtn.image = [UIImage imageNamed:@"playback_pause"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.hideTimer) {
        [self.hideTimer invalidate];
        self.hideTimer = nil;
    } else {
        NSTimer *timer = [NSTimer timerWithTimeInterval:8 target:self selector:@selector(hideUI) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.hideTimer = timer;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].statusBarHidden withAnimation:UIStatusBarAnimationSlide];
    if (!CGAffineTransformEqualToTransform(self.topView.transform, CGAffineTransformIdentity)) {
        self.topView.hidden = !self.topView.isHidden;
        self.bottomToolBar.hidden = !self.bottomToolBar.isHidden;
        [UIView animateWithDuration:0.5 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
            self.bottomToolBar.transform = CGAffineTransformIdentity;
        }];
    } else {
        [self hideUI];
    }
    
}


- (void)didOrientation {
//    CGFloat y, height;
//    if ([UIDevice currentDevice].orientation & UIDeviceOrientationPortrait) {
//        height = self.view.width * 9 / 16;
//        y = (self.view.height - height) / 2;
//
//    } else {
//        height = self.view.height;
//        y = 0;
//    }
//    self.layer.frame = CGRectMake(0, y, self.view.width, height);
    self.layer.frame = self.view.frame;
}

- (IBAction)close:(id)sender {
    [self.player pause];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)play {
    if (self.player.rate) {
        [self.player pause];
        self.playBtn.image = [UIImage imageNamed:@"playback_play"];
    } else {
        [self.player play];
        self.playBtn.image = [UIImage imageNamed:@"playback_pause"];
    }
}

- (void)seek {
    CMTime time = CMTimeMake(self.player.currentItem.duration.value * self.progressSlider.value, self.player.currentItem.duration.timescale);
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        if (finished) {
            [self.player play];
            self.playBtn.image = [UIImage imageNamed:@"playback_pause"];
        } else {
            [self.player pause];
            self.playBtn.image = [UIImage imageNamed:@"playback_play"];
        }
    }];
}

- (void)hideUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:0.7 animations:^{
        self.topView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(self.topView.frame));
        self.bottomToolBar.transform = CGAffineTransformMakeTranslation(0, self.bottomToolBar.size.height);
    } completion:^(BOOL finished) {
        self.topView.hidden = YES;
        self.bottomToolBar.hidden = YES;
        
        [self.hideTimer invalidate];
        self.hideTimer = nil;
    }];
}

@end
