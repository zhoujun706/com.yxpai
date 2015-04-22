//
//  FeedBackViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/3.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"feedback" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:filePath]];
    
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsById('title').value;"];
//    NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsById('content').value;"];
//    
//    NSLog(@"=====title %@    content  %@  ", title, content);
//}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('title').value;"];
        NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').value;"];
        
        
        [self submitFormWithTitle:title Content:content];
    } else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return YES;
}


- (void)submitFormWithTitle:(NSString *)title Content:(NSString *)content {
    
    NSDictionary *params = @{kMethod:kMethodFeedBack, @"uid":AppDelegateInstance.userId, @"title":title, @"content":content};
    [HttpManager requestServiceWithParam:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:kCode] intValue] == 0) {
            
        
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"feedback_success" ofType:@"html"];
            NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
            [_webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:filePath]];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
