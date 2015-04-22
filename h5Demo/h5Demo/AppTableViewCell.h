//
//  AppTableViewCell.h
//  h5Demo
//
//  Created by 邹俊 on 15/4/9.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *appIcon;

@property (weak, nonatomic) IBOutlet UILabel *appName;

@property (weak, nonatomic) IBOutlet UIButton *appAddButton;



- (void)setAppDataWithApp:(H5App *)app;

@end
