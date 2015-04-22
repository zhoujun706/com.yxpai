//
//  H5AppCollectionViewCell.h
//  h5Demo
//
//  Created by 邹俊 on 15/4/7.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "H5App.h"

@interface H5AppCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *appIcon;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


- (void)setAppDataWithApp:(H5App *)app;


@end
