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
#import "avformat.h"
#import "imgutils.h"
#import "swscale.h"

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
    
    AVFormatContext *pFormatCtx = NULL;
//    pFormatCtx = avformat_alloc_context();
    
    const char *url = "http://192.168.1.1:49152/web/2406.mp4";
    
    av_register_all();
    avformat_network_init();
    
    avformat_open_input(&pFormatCtx, url, NULL, NULL);
    avformat_find_stream_info(pFormatCtx, NULL);
    
    av_dump_format(pFormatCtx, 0, url, 0);
    
    AVCodecContext *pCodecCtx = NULL;
    int i;
    int videoStream = -1;
    for (i = 0; i < pFormatCtx->nb_streams; i++) {
        if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoStream = i;
        }
    }
    
    if (videoStream == -1) {
        return;
    }
    
    pCodecCtx = pFormatCtx->streams[videoStream]->codec;
    
    /* find the decoder */
    AVCodec *pCodec = NULL;
    pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
    if (!pCodec) {
        return;
    }
    
//    AVDictionary *opts;
//    opts = filter_codec_opts(
    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0) {
        return;
    }
    
    AVFrame *pFrame = NULL;
    pFrame = av_frame_alloc();
    AVFrame *pFrameRGB = av_frame_alloc();
    
    int numBytes = av_image_get_buffer_size(AV_PIX_FMT_RGB24, pCodecCtx->width, pCodecCtx->height, 1);
    uint8_t *buffer = (uint8_t *)av_malloc(numBytes * sizeof(uint8_t));
    av_image_fill_arrays(pFrameRGB->data, pFrameRGB->linesize, buffer, AV_PIX_FMT_RGB24, pCodecCtx->width, pCodecCtx->height, 1);
    
    struct SwsContext *swsCtx = NULL;
    swsCtx = sws_getContext(pCodecCtx->width,
                            pCodecCtx->height,
                            pCodecCtx->pix_fmt,
                            pCodecCtx->width,
                            pCodecCtx->height,
                            AV_PIX_FMT_RGB24,
                            SWS_BILINEAR,
                            NULL,
                            NULL,
                            NULL);
    AVPacket packet;
    int frameFinished = 0;
    while (av_read_frame(pFormatCtx, &packet)>=0) {
        if (packet.stream_index == videoStream) {
            avcodec_decode_video2(pCodecCtx, pFrame, &frameFinished, &packet);
        }
        if (frameFinished) {
            /* convert the image from the native format to RGB24 */
            sws_scale(swsCtx, (const uint8_t * const *)pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameRGB->data, pFrameRGB->linesize);
            
            /* do something like "show the image" etc */
        }
        /* free packet.data */
        av_packet_unref(&packet);
    }
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
