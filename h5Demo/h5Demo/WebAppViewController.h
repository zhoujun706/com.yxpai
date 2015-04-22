//
//  WebAppViewController.h
//  h5Demo
//
//  Created by 邹俊 on 15/4/10.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface WebAppViewController : UIViewController



/**
 *  跳转到查看app站点的页面时，需要把当前App传到此页面
 *
 *  @param app 查看的app
 */
- (void)setCurrentApp:(H5App *)app;



@end
