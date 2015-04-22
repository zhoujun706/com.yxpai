//
//  H5App.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/7.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "H5App.h"


NSString *cAppId = @"appid";
NSString *cEnglishName = @"english_name";
NSString *cChineseName = @"chinese_name";
NSString *cPinyinName = @"pinyin_name";
NSString *cShortName = @"short_name";
NSString *cSiteUrl = @"site_url";
NSString *cIconUrl = @"icon_url";
NSString *cCategory = @"category";
NSString *cPosition = @"position";


@implementation H5App




-(instancetype)initWithDataBase:(FMResultSet *)resultSet {
    
    self = [super init];
    if (self) {
        
        _appid = [resultSet stringForColumn:cAppId];
        _english_name = [resultSet stringForColumn:cEnglishName];
        _chinese_name = [resultSet stringForColumn:cChineseName];
        _pinyin_name = [resultSet stringForColumn:cPinyinName];
        _short_name = [resultSet stringForColumn:cShortName];
        _site_url = [resultSet stringForColumn:cSiteUrl];
        _icon_data = [resultSet dataForColumn:cIconUrl];
        _category = [resultSet stringForColumn:cCategory];
        _position = [resultSet intForColumn:cPosition];
        
    }
    
    return self;
}


-(instancetype)initWithDictionary:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {

        
        _appid = [dic objectForKey:@"id"];
        _app_description = [dic objectForKey:@"description"];
        _english_name = [dic objectForKey:cEnglishName];
        _chinese_name = [dic objectForKey:cChineseName];
        _pinyin_name = [dic objectForKey:cPinyinName];
        _short_name = [dic objectForKey:cShortName];
        _site_url = [dic objectForKey:cSiteUrl];
        _icon_url = [dic objectForKey:cIconUrl];


        
    }
    
    return self;
}

@end
