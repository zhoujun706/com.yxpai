//
//  HttpManager.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/7.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

NSString *const kServiceUrl = @"http://121.199.39.161:8080/service";
NSString *const kMethod = @"method";
NSString *const kCode = @"code";
NSString *const kMsg = @"msg";

NSString *const kMethodGetUid = @"A1001";
NSString *const kMethodSearchApp = @"A2001";
NSString *const kMethodFeedBack = @"A1002";


#import "HttpManager.h"

@implementation HttpManager


+(void)requestServiceWithParam:(NSDictionary *)param success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSString *paramJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"data":paramJson};
    [manager POST:kServiceUrl parameters:parameters success:success failure:failure];
    
}


@end
