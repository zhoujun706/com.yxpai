//
//  OperationGuideViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/3.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "OperationGuideViewController.h"

@interface OperationGuideViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation OperationGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"opt" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:filePath]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
