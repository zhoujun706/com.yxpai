//
//  WebAppViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/10.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "WebAppViewController.h"


@interface WebAppViewController () <UIWebViewDelegate, UIAlertViewDelegate> {
    
    H5App *_currentApp;
    
    
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAppSite];
    
}


/**
 *  加载app站点
 */
- (void)loadAppSite {
    
    NSURL *siteUrl = [NSURL URLWithString:_currentApp.site_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:siteUrl];
    
    [_webView loadRequest:request];
    
}


- (IBAction)goBackAction {
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"是否退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    
}


- (IBAction)goForwardAction {
    
    if (_webView.canGoForward) {
        [_webView goForward];
    }
    
}


- (IBAction)goHomeAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self goHomeAction];
            break;
        default:
            break;
    }
    
}

-(void)setCurrentApp:(H5App *)app {
    
    _currentApp = app;
    
    
}


@end
