//
//  CHKeychain.h
//  h5Demo
//
//  Created by 邹俊 on 15/4/8.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
