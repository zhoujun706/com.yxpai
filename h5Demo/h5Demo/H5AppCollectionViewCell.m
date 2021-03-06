//
//  H5AppCollectionViewCell.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/7.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "H5AppCollectionViewCell.h"

@implementation H5AppCollectionViewCell {
    
    H5App *_currentApp;
    
}

- (void)awakeFromNib {
    // Initialization code
    
    
}

-(void)drawRect:(CGRect)rect {
    _appIcon.layer.masksToBounds = YES;
    _appIcon.layer.cornerRadius = rect.size.width/3.;
}


-(void)setAppDataWithApp:(H5App *)app {
    
    _currentApp = app;
    
    
    
    NSString *name = _currentApp.chinese_name;
    
    
    dispatch_async(dispatch_queue_create("imageData", NULL), ^{
       
        NSData *iconData = _currentApp.icon_data;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _appIcon.image = [UIImage imageWithData:iconData];
            
        });
        
    });
   
    _appName.text = name;
    _deleteButton.hidden = YES;
}




@end
