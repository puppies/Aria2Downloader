//
//  UpDownButton.m
//  Aria2Downloader
//
//  Created by happy on 16/3/12.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "UpDownButton.h"
#import "UIView+extension.h"

@implementation UpDownButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.centerX = self.width / 2;
    self.imageView.centerY = self.height / 3;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 5;
    
    self.titleLabel.width = self.width;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
