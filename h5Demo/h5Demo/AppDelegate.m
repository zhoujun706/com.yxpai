//
//  AppDelegate.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/2.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

NSString *const kKeyUserId = @"com.yxpai.h5Demo.userid";
NSString *const kKeyKeychainName = @"com.yxpai.h5Demo.keychain";

#import "AppDelegate.h"
#import "CHKeychain.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self initData];
    
    [self checkAndSetUserId];
    [self readDatabase];
    
    return YES;
}

/**
 *  初始化数据
 */
- (void)initData {
    _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _apps = [NSMutableArray array];
    [self setDataDB];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.

}

/**
 *  获取应用下的Document目录
 *
 *  @return 返回document目录的路径
 */
- (NSString *)applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
}


#pragma mark - 设置用户id，先从钥匙串中访问，没有就从服务器取

- (void)checkAndSetUserId {
    
   // 查找钥匙串中是否有用户唯一id
    NSMutableDictionary *userIdKV = (NSMutableDictionary *)[CHKeychain load:kKeyKeychainName];
    id userId = [userIdKV objectForKey:kKeyUserId];
    
    if(!userId){
        
        //从服务器上取uid
        [self requestUserId];
        
    }else{
        
        _userId = [NSString stringWithFormat:@"%@", userId];
        
    }
    
    
}

/**
 *  向服务器请求用户id
 *
 *  @return 服务器返回的用户id
 */
- (void)requestUserId {
    
    NSDictionary *params = @{kMethod:kMethodGetUid};
    [HttpManager requestServiceWithParam:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if ([[responseObject objectForKey:kCode] intValue] == 0) {
            _userId = [responseObject objectForKey:@"uid"];
            
            [self saveUserIdToKeychain];
            
        }else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        
    }];

}

/**
 *  将用户id保存到钥匙串中
 */
-(void)saveUserIdToKeychain {
    
    NSMutableDictionary *userIdKV = [NSMutableDictionary dictionary];
    [userIdKV setObject:_userId forKey:kKeyUserId];
    [CHKeychain save:kKeyKeychainName data:userIdKV];
    
}





/**
 *  创建数据库对象
 *
 */
- (void)setDataDB {
    
    NSString *dbPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"data.db"];
    _db = [FMDatabase databaseWithPath:dbPath] ;
    
}


#pragma mark - 读取数据库文件
/**
 *  将初始数据库拷贝至document目录
 */
- (void)copyInitDatabaseToDocument {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *initDataBasePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"db"];
    
    NSString *dbPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"data.db"];
    
    NSError *error;
    
    [manager copyItemAtPath:initDataBasePath toPath:dbPath error:&error];
    
}


#pragma mark - 数据库操作

/**
 *  读取document下数据库文件
 */
- (void)readDatabase {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dbPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"data.db"];
    if(![manager fileExistsAtPath:dbPath]){
        [self copyInitDatabaseToDocument];
    }
    
    
    if ([_db open]) {
        
        FMResultSet *rs = [_db executeQuery:@"SELECT * FROM app"];
        
        while ([rs next]) {
            
            H5App *app = [[H5App alloc] initWithDataBase:rs];
            
            [_apps addObject:app];
            
        }
        [rs close];
        
    }

    
}


-(NSArray *)selectDataFromSearch {
    
    NSMutableArray *resultData = [NSMutableArray array];
    
    if ([_db open]) {
        
        FMResultSet *rs = [_db executeQuery:@"SELECT * FROM search"];
        
        while ([rs next]) {
            
            NSString *name = [rs stringForColumn:@"name"];
            
            [resultData insertObject:name atIndex:0];
            
        }
        [rs close];
        
    }
    
    return resultData;
}

- (void)insertDataToSearch:(NSString *)searchText {
    
    [_db executeUpdate:@"INSERT INTO search (name) VALUES (?)", searchText];
    
}

- (void)deleteDataFromSearch:(NSString *)searchText {
    
    [_db executeUpdate:@"DELETE FROM search WHERE name=?", searchText];
    
}


#pragma mark - 安装卸载 APP
-(BOOL)installApp:(H5App *)currentApp {

    if([_db executeUpdate:@"INSERT INTO app (appid,chinese_name,site_url,icon_url,position) VALUES (?,?,?,?,?)", currentApp.appid, currentApp.chinese_name, currentApp.site_url, currentApp.icon_data, [NSNumber numberWithInteger:_apps.count-1]]) {
        
        if (_apps.count == 0) {
            [_apps addObject:currentApp];
        } else {
            for (int i=0; i<_apps.count; i++) {
            
                H5App *app = [_apps objectAtIndex:i];
                if (i == _apps.count-1 && ![app.appid isEqualToString:currentApp.appid]) {
                    [_apps addObject:currentApp];
                }
            }
        }
        return YES;
    }
    return NO;
}

-(BOOL)unInstallApp:(H5App *)currentApp {

    if([_db executeUpdate:@"DELETE FROM app WHERE appid=?", currentApp.appid]) {
        
        //遍历数组并修改使用此方法不会crash
        [_apps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([((H5App *)obj).appid isEqualToString:currentApp.appid]) {
                
                *stop = YES;
                
                if (*stop == YES) {
                    
                    [_apps removeObject:obj];
                    
                }
                
            }
            
            if (*stop) {
                
            }
            
        }];

        return YES;
    }
    return NO;
}


@end
