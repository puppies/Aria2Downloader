//
//  NewTaskViewController.m
//  Aria2Downloader
//
//  Created by happy on 16/3/6.
//  Copyright © 2016年 happy. All rights reserved.
//

#import "NewTaskViewController.h"
#import "Aria2.h"
#import "Task.h"
#import "DFile.h"
#import "Uri.h"

@interface NewTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;

@end

@implementation NewTaskViewController

- (void)awakeFromNib {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.urlTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.urlTextView.layer.borderWidth = 0.6;
    self.urlTextView.layer.cornerRadius = 6.0;
    
    
    self.title = @"新建任务";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTask)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:self.urlTextView];
    
    DFile *file = self.task.files[0];
    if (file.uris.count) {
        Uri *uri0 = file.uris[0];
        self.urlTextView.text = uri0.uri;
    } else {
        
    }
    
    self.navigationItem.rightBarButtonItem.enabled = self.urlTextView.hasText;
    
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

- (void)addNewTask {
    NSString *urlString = self.urlTextView.text;
    [Aria2 addUri:urlString success:nil failure:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textChanged {
    if ([self.urlTextView hasText]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled= NO;
    }
}

@end
