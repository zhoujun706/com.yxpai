//
//  H5App.h
//  h5Demo
//
//  Created by 邹俊 on 15/4/7.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

const NSString *cAppId;
const NSString *cEnglishName;
const NSString *cChineseName;
const NSString *cPinyinName;
const NSString *cShortName;
const NSString *cSiteUrl;
const NSString *cIconUrl;
const NSString *cCategory;
const NSString *cPosition;

@interface H5App : NSObject

@property (nonatomic, strong) NSString *appid;                 //h5应用id
@property (nonatomic, strong) NSString *english_name;    //英文名称
@property (nonatomic, strong) NSString *chinese_name;   //中文名称
@property (nonatomic, strong) NSString *pinyin_name;     //拼音名称
@property (nonatomic, strong) NSString *short_name;      //简称
@property (nonatomic, strong) NSString *site_url;             //跳转地址
@property (nonatomic, strong) NSData   *icon_data;            //图标数据
@property (nonatomic, strong) NSString *icon_url;               //图标地址
@property (nonatomic, strong) NSString *category;           //分类
@property (nonatomic, assign) int            position;           //下标


@property (nonatomic, strong) NSString *app_description;     //描述


- (instancetype)initWithDataBase:(FMResultSet *) resultSet;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
