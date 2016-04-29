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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ip = [userDefaults stringForKey:@"routerIP"];
    NSInteger timeInterval = [userDefaults integerForKey:@"refreshInterval"];
    
    if (ip) {
        self.routerIPTextField.text = ip;
    }
    if (timeInterval) {
        self.refreshTimeTextField.text = [NSString stringWithFormat:@"%ld", (long)timeInterval];
    }
    
    [userDefaults setObject:self.routerIPTextField.text forKey:@"routerIP"];
    [userDefaults setInteger:self.refreshTimeTextField.text.integerValue forKey:@"refreshInterval"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ip = self.routerIPTextField.text;
    if ([self isValidIP:ip]) {
        [userDefaults setObject:ip forKey:@"routerIP"];
    }
    
    NSInteger timeInterval = self.refreshTimeTextField.text.integerValue;
    if ([self isValidPositiveInteger:timeInterval]) {
        [userDefaults setInteger:timeInterval forKey:@"refreshInterval"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isValidIP:(NSString *)ip{
    NSString *predicateString = @"((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))";
    NSPredicate *ipPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateString];
    
    return [ipPredicate evaluateWithObject:ip];
}

- (BOOL)isValidPositiveInteger:(NSInteger)value {
    NSString *predicateString = @"^[1-9]\\d*$";
    NSPredicate *valuePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateString];
    
    return [valuePredicate evaluateWithObject:[NSString stringWithFormat:@"%ld", (long)value]];
}

@end
