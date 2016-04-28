//
//  UpnpServerContentTableViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/14.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "UpnpServerContentTableViewController.h"
#import "mUPnP/mUPnP.h"
#import "DLNAPlaybackViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UpnpServerContentTableViewController ()

@property (nonatomic)NSCache *cache;
@property (assign)BOOL shouldDelayAnimation;

@end

@implementation UpnpServerContentTableViewController

- (id)initWithAvServer:(CGUpnpAvServer *)aServer atIndexPath:(NSIndexPath*)aIndexPath objectId:(NSString *)anObjectId
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.server = (CGUpnpAvServer *)aServer;
        self.objects = [self.server browseDirectChildren:anObjectId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contentCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.cache = [[NSCache alloc] init];
    self.cache.countLimit = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.shouldDelayAnimation = YES;
}

//- (void)setObjects:(NSArray *)objects {
//    _objects = objects;
//    
//    for (CGUpnpAvObject *object in _objects) {
//        <#statements#>
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    CGUpnpAvObject *object = self.objects[indexPath.row];
    
    cell.textLabel.text = object.title;
    
    if (object.isItem) {
        CGUpnpAvItem *item = (CGUpnpAvItem *)object;
        
//        dispatch_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
        
//        cell.imageView.image = [self getVideoPreViewImage:item.resourceUrl];
        cell.imageView.image = [UIImage imageNamed:@"file-unknown"];
    } else if (object.isContainer) {
        cell.imageView.image = [UIImage imageNamed:@"folder"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUpnpAvObject *object = self.objects[indexPath.row];
    if (object.isItem) {
        CGUpnpAvItem *item = (CGUpnpAvItem *)object;
        CGUpnpAvResource *resource = item.resource;
        NSLog(@"item: %@, resource: %@, url:%@", item.title, resource.protocolInfo, item.resourceUrl);
                
        DLNAPlaybackViewController *playbackViewController = [[DLNAPlaybackViewController alloc] init];
        playbackViewController.item = item;

        [self presentViewController:playbackViewController animated:YES completion:nil];
        
    } else {
        UpnpServerContentTableViewController *contentController = [[UpnpServerContentTableViewController alloc] initWithAvServer:self.server atIndexPath:indexPath objectId:object.objectId];
        
        contentController.title = object.title;
        
        [self.navigationController pushViewController:contentController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSTimeInterval delay = 0;
    if (self.shouldDelayAnimation) {
        delay = 0.05 * indexPath.row;
    }
    
    cell.transform = CGAffineTransformMakeTranslation(tableView.bounds.size.width, 0);
    [UIView animateWithDuration:1.7 delay:delay usingSpringWithDamping:0.77 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

- (UIImage *) getVideoPreViewImage:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
    
//    [gen generateCGImagesAsynchronouslyForTimes:@[time] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
//        UIImage *img = [[UIImage alloc] initWithCGImage:image];
//        CGImageRelease(image);
//        
//    }]
//    
//    
//    return img;
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.shouldDelayAnimation = NO;
}

@end
