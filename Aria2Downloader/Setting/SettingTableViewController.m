//
//  SettingTableViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/4/1.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *routerIPTextField;
@property (weak, nonatomic) IBOutlet UITextField *refreshTimeTextField;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowOpacity = 0.6;
    self.view.layer.shadowOffset = CGSizeMake(3, 0);
    self.view.layer.cornerRadius = 8;
    
    self.routerIPTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.refreshTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
