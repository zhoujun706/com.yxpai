//
//  AppDelegate.h
//  h5Demo
//
//  Created by 邹俊 on 15/4/2.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

NSString *const kKeyUserId;
NSString *const kKeyKeychainName;

#import "H5App.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;

@property (readonly, strong, nonatomic) NSString *userId; //服务器返回的用户ID
@property (readonly, strong, nonatomic) FMDatabase *db; //


@property (nonatomic, strong) NSMutableArray *apps; //当前设备的所有h5应用集合


- (NSString *)applicationDocumentsDirectory;


- (BOOL)installApp:(H5App *)currentApp;
- (BOOL)unInstallApp:(H5App *)currentApp;



- (NSArray *)selectDataFromSearch;
- (void)insertDataToSearch:(NSString *)searchText;
- (void)deleteDataFromSearch:(NSString *)searchText;


@end

