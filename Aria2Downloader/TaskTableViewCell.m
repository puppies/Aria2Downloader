//
//  TaskTableViewCell.m
//  Aria2Downloader
//
//  Created by happy on 16/1/15.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "Task.h"
#import "File.h"
#import "Uri.h"
#import "UIView+extension.h"
#import "UpDownButton.h"

#define PADDING 10

@interface TaskTableViewCell ()

@property (nonatomic)UIImageView *iconView;
@property (nonatomic)UILabel *nameLabel;
@property (nonatomic)UpDownButton *controlButton;
@property (nonatomic)UIButton *progressbutton;
@property (nonatomic)UIButton *speedButton;

@end

@implementation TaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* file icon */
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        
        /* file name label */
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:self.nameLabel];
//        self.nameLabel.backgroundColor = [UIColor blueColor];
        
        /* start pause button */
        self.controlButton = [[UpDownButton alloc] init];
        [self.controlButton setImage:[UIImage imageNamed:@"restart"] forState:UIControlStateNormal];
        [self.controlButton setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateDisabled];
        
//        self.controlButton.imageView.backgroundColor = [UIColor blueColor];
//        self.controlButton.titleLabel.backgroundColor = [UIColor greenColor];
        
        [self.controlButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.controlButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.controlButton addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:self.controlButton];
//        self.controlButton.backgroundColor = [UIColor redColor];
        
        /* download progress */
        self.progressbutton = [[UIButton alloc] init];
        self.progressbutton.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.progressbutton setImage:[UIImage imageNamed:@"pie"] forState:UIControlStateNormal];
        [self.progressbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.progressbutton];
//        self.progressbutton.backgroundColor = [UIColor greenColor];
        
        /* download speed */
        self.speedButton = [[UIButton alloc] init];
        self.speedButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.speedButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [self.speedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.speedButton];
//        self.speedButton.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconView.size = CGSizeMake(64, 64);
    self.iconView.x = 0;
    self.iconView.centerY = self.height / 2;
    
    self.nameLabel.x = CGRectGetMaxX(self.iconView.frame);
    self.nameLabel.y = PADDING;
    self.nameLabel.width = self.width - 128;
    [self.nameLabel sizeToFit];
    
    self.controlButton.size = CGSizeMake(64, 64);
    self.controlButton.x = self.width - self.controlButton.width;
    self.controlButton.centerY = self.height / 2;
//    [self.controlButton sizeToFit];
    
//    self.controlButton.titleEdgeInsets = UIEdgeInsetsMake(40, -self.controlButton.currentImage.size.width, 0, 0);
//    self.controlButton.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, self.controlButton.titleLabel.size.width);
    
    self.progressbutton.x = self.nameLabel.x;
    self.progressbutton.y = CGRectGetMaxY(self.nameLabel.frame) + PADDING;
    self.progressbutton.width = (self.width - 128) * 2 / 3;
    self.progressbutton.height = 72 - PADDING * 3 - self.nameLabel.height;
    [self.progressbutton sizeToFit];
    
//    self.speedButton.x = CGRectGetMaxX(self.progressLabel.frame);
    self.speedButton.x = self.width * 4 / 7;
    self.speedButton.y = self.progressbutton.y;
    self.speedButton.width = self.width - 128 - self.progressbutton.width;
    self.speedButton.height = self.progressbutton.height;
    [self.speedButton sizeToFit];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTask:(Task *)task {
    _task = task;
    
    File *file = task.files[0];
    NSMutableString *fileName = [file.path mutableCopy];
//    [fileName replaceOccurrencesOfString:task.dir withString:@"" options:NSLiteralSearch range:NSMakeRange(0, fileName.length)];
//    NSLog(@"%@ , %lu", task.dir, (unsigned long)task.dir.length);
//
//    NSLog(@"%@ , %@", fileName, NSStringFromRange(NSMakeRange(0, task.dir.length + 1)));
    if ([fileName hasPrefix:task.dir]) {
        [fileName deleteCharactersInRange:NSMakeRange(0, task.dir.length + 1)];
    }
    
    if ([fileName isEqualToString:@""]) {
        Uri *uri0 = file.uris[0];
        fileName = [uri0.uri copy];
    }
    
    NSString *fileType = [self fileTypeOf:fileName];

    self.nameLabel.text = [fileName stringByRemovingPercentEncoding];
    
    self.iconView.image = [UIImage imageNamed:fileType];
    
//    NSString *progress = [NSString stringWithFormat:@"%@/%@ (%.1f%%)", \
//                               [self stringWithFileSize:task.completedLength], [self stringWithFileSize:task.totalLength], (CGFloat)task.completedLength * 100 / task.totalLength];
    
    NSString *progress = [NSString stringWithFormat:@"%@/%@", \
                          [self stringWithFileSize:task.completedLength], [self stringWithFileSize:task.totalLength]];
    
    [self.progressbutton setTitle:progress forState:UIControlStateNormal];
    
    NSString *speed = [NSString stringWithFormat:@"%.2f KB/s", (CGFloat)task.downloadSpeed / 1024];
    [self.speedButton setTitle:speed forState:UIControlStateNormal];
    
    if ([task.status isEqualToString:@"complete"]) {
        self.controlButton.enabled = NO;
    } else {
        NSString *imageName, *highlightImageName, *text;
        UIColor *color;
        self.controlButton.enabled = YES;
        if ([task.status isEqualToString:@"waiting"]) {
            imageName = @"pauseoutline";
            highlightImageName = @"pause";
            text = @"等待";
            color = [UIColor grayColor];
        } else if ([task.status isEqualToString:@"paused"]) {
            imageName = @"restartoutline";
            highlightImageName = @"restart";
            text = @"暂停";
            color = [UIColor grayColor];
        } else if ([task.status isEqualToString:@"error"]) {
            imageName = @"restartoutline";
            highlightImageName = @"restart";
            text = @"失败";
            color = [UIColor redColor];
        } else if ([task.status isEqualToString:@"removed"]) {
            imageName = @"restartoutline";
            highlightImageName = @"restart";
            text = @"已移除";
            color = [UIColor redColor];
        } else if ([task.status isEqualToString:@"active"]) {
            imageName = @"pauseoutline";
            highlightImageName = @"pause";
            text = speed;
            color = [UIColor grayColor];
        }
        [self.controlButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.controlButton setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
        [self.controlButton setTitle:text forState:UIControlStateNormal];
        [self.controlButton setTitleColor:color forState:UIControlStateNormal];
    }
}

- (NSString *)stringWithFileSize:(NSUInteger)size {
    if (size > (1 << 30)) {
        return [NSString stringWithFormat:@"%.2fGB", (CGFloat)size / 1024 /1024 /1024];
    } else if (size > (1 << 20)) {
        return [NSString stringWithFormat:@"%.2fMB", (CGFloat)size / 1024 /1024];
    } else if (size > (1 << 10)) {
        return [NSString stringWithFormat:@"%.2fKB", (CGFloat)size / 1024];
    } else {
        return [NSString stringWithFormat:@"%luB", size];
    }
}

- (NSString *)fileTypeOf:(NSString *)file {
    NSArray *movieArray = @[@".mkv", @".MKV",@".mp4",@".MP4",@".avi",@".AVI",@".rmvb", @".RMVB"];
    for (NSString *suf in movieArray) {
        if ([file hasSuffix:suf]) {
            return @"movie";
        }
    }
    
    NSArray *tarArray = @[@".tar", @".zip", @".", @".rar", @".7z", @".gz"];
    for (NSString *suf in tarArray) {
        if ([file hasSuffix:suf]) {
            return @"tar";
        }
    }
    
    NSArray *pictureArray = @[@".jpeg", @".jpg",@".png",@".bmp",@".gif"];
    for (NSString *suf in pictureArray) {
        if ([file hasSuffix:suf]) {
            return @"picture";
        }
    }
    
    NSArray *musicArray = @[@".mp3", @".aac",@".m4a",@".flac"];
    for (NSString *suf in musicArray) {
        if ([file hasSuffix:suf]) {
            return @"music";
        }
    }
    return @"blankfile";
}

- (void)restart {
    self.restartBlock(self);
}

@end
