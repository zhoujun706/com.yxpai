//
//  HttpManager.h
//  h5Demo
//
//  Created by 邹俊 on 15/4/7.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

NSString *const kServiceUrl;
NSString *const kMethod;
NSString *const kCode;
NSString *const kMsg;

/*
 接口、参数名
 */

//绑定用户设备
NSString *const kMethodGetUid;

//搜索
NSString *const kMethodSearchApp;

//反馈
NSString *const kMethodFeedBack;


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpManager : NSObject


+ (void)requestServiceWithParam:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
