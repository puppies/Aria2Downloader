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

@interface TaskTableViewCell ()

@property (nonatomic)UILabel *nameLabel;
@property (nonatomic)UIProgressView *progressView;
@property (nonatomic)UILabel *speedLabel;

@end

@implementation TaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /* file name label */
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        
        /* download progress */
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.contentView addSubview:self.progressView];
        
        /* download speed */
        self.speedLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.speedLabel];
    }
    return self;
}

- (void)layoutSubviews {
    CGRect nameFrame = CGRectMake(0, 0, self.frame.size.width, 20);
    self.nameLabel.frame = nameFrame;
    
    CGRect progressFrame = CGRectMake(0, CGRectGetMaxY(nameFrame) + 5, self.frame.size.width - 180, 20);
    self.progressView.frame = progressFrame;
    
    CGRect speedFrame = CGRectMake(CGRectGetMaxX(progressFrame) + 5, progressFrame.origin.y, self.frame.size.width - progressFrame.size.width - 5, 20);
    self.speedLabel.frame = speedFrame;
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
    [fileName replaceOccurrencesOfString:task.dir withString:@"" options:NSLiteralSearch range:NSMakeRange(0, fileName.length)];
    [fileName deleteCharactersInRange:NSMakeRange(0, 1)];
    self.nameLabel.text = fileName;
    
    self.progressView.progress = (CGFloat)task.completedLength / task.totalLength;
    
    self.speedLabel.text = [NSString stringWithFormat:@"(%.2f%%)%.2f KB/s", self.progressView.progress *100, (CGFloat)task.downloadSpeed / 1024];
}

@end
