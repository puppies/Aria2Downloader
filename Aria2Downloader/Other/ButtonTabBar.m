//
//  ButtonTabBar.m
//  Aria2Downloader
//
//  Created by happy on 16/3/4.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "ButtonTabBar.h"
#import "UIView+extension.h"

@interface ButtonTabBar ()

@property (nonatomic)UIButton *addButton;

@end

@implementation ButtonTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:116.0/255 green:57.0/255 blue:81.0/255 alpha:1.0];
        
        UITabBarItem *appearance = [UITabBarItem appearance];
        [appearance setTitleTextAttributes:attrs forState:UIControlStateSelected];
        
        UIButton *addBtn = [[UIButton alloc] init];
        [addBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
//        [addBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateHighlighted];
        
        addBtn.size = addBtn.currentImage.size;
        [addBtn addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:addBtn];
        self.addButton = addBtn;
        
        self.itemPositioning = UITabBarItemPositioningCentered;
        


    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.addButton.center = CGPointMake(self.width * 0.5, self.height *0.5);
 
    CGFloat tabBarButtonW = self.width / 3;
    [self setItemWidth:tabBarButtonW];

    int index = 0;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            view.x = tabBarButtonW * index;
//            view.width = tabBarButtonW;
//            view.backgroundColor = [UIColor redColor];
            
            if (index == 0) {
                index += 2;
            } else {
                index++;
            }
        }
    }
}

- (void)addTask {
    self.addNewTaskBlock();
}

@end
