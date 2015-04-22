//
//  AppTableViewCell.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/9.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "AppTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation AppTableViewCell {
    BOOL _installed;
    H5App *_currentApp;
    NSData *_iconData;
}

- (void)awakeFromNib {
    // Initialization code
    
    _appAddButton.layer.cornerRadius = 10;
    [_appAddButton addTarget:self action:@selector(installTheUninstallApp) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setAppDataWithApp:(H5App *)app {
    
    _currentApp = app;
    
    NSString *appIconUrl = _currentApp.icon_url;
    NSString *appName = _currentApp.chinese_name;
    NSString *appId = _currentApp.appid;
    
    
    
    [_appIcon sd_setImageWithURL:[NSURL URLWithString:appIconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if (UIImagePNGRepresentation(image) == nil) {
            
            _iconData = UIImageJPEGRepresentation(image, 1);
            _currentApp.icon_data = _iconData;
            
        } else {
            
            _iconData = UIImagePNGRepresentation(image);
            _currentApp.icon_data = _iconData;
            
        }
    }];
    _appName.text = appName;
    
    _installed = [self checkInstall:appId];
    
    if (!_installed) {
        _appAddButton.backgroundColor = [UIColor grayColor];
    }else {
        _appAddButton.backgroundColor = [UIColor greenColor];
    }
    
}

/**
 *  判断是否安装过此应用
 *
 *  @return 安装过返回yes， 未安装返回no
 */
- (BOOL)checkInstall:(NSString *)appId {
    
    int count = [AppDelegateInstance.db intForQuery:@"SELECT COUNT (*) FROM app WHERE appid=?", appId];
    
    if (count != 0) {
        return YES;
    }
    
    return NO;
}


- (void)installTheUninstallApp {
    
    if (_installed) {
        [self uninstallApp];
    } else {
        [self installApp];
    }
    
}

/**
 *  安装APP
 */
- (void)installApp {

    _installed = [AppDelegateInstance installApp:_currentApp];
    
    if (_installed) {
        _appAddButton.backgroundColor = [UIColor greenColor];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"\"%@\"安装成功", _currentApp.chinese_name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

/**
 *  卸载APP
 */
- (void)uninstallApp {
    
    _installed = ![AppDelegateInstance unInstallApp:_currentApp];
    
    if (!_installed) {
        _appAddButton.backgroundColor = [UIColor grayColor];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"\"%@\"卸载成功", _currentApp.chinese_name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}




@end
