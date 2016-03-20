//
//  ButtonTabBar.h
//  Aria2Downloader
//
//  Created by happy on 16/3/4.
//  Copyright © 2016年 happy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddNewTaskBlock)();

@interface ButtonTabBar : UITabBar

@property (nonatomic, strong) AddNewTaskBlock addNewTaskBlock;

@end
