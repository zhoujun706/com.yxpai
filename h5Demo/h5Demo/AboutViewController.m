//
//  AboutViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/3.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:filePath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
