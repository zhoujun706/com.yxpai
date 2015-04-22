//
//  AddAppViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/3.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "AddAppViewController.h"
#import "SearchViewController.h"
#import "AddAppMenuTableViewCell.h"
#import "AppTableViewCell.h"
#import "WebAppViewController.h"

@interface AddAppViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *_menuNames;              //左侧菜单名称集合
    NSMutableArray *_appArray;       //右侧相应的app集合
    
    int _selectIndex;                           //选择的菜单下标
    
}

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;


@end

@implementation AddAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    
}

- (void)initData {
    
    _menuNames = @[@"大家都在用", @"购物", @"资讯", @"生活", @"社交", @"美图", @"小说", @"游戏", @"漫画", @"工具", @"娱乐", @"影音"];
    _appArray = [NSMutableArray array];
    
    //一进页面默认选中第一个
    _selectIndex = 0;
    [self searchApp];
    
}


#pragma mark - delegate \  datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _menuTableView) {
        //菜单列
        static NSString *identify = @"MenuCell";
        AddAppMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddAppMenuTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backImage.backgroundColor = [UIColor grayColor];
        cell.menuName.text = _menuNames[indexPath.row];
        
        if (_selectIndex == indexPath.row) {
            cell.backImage.backgroundColor = [UIColor blackColor];
        }
        
        return cell;
        
    } else if (tableView == _contentTableView) {
        //内容列
        
        static NSString *identify = @"AppCell";
        AppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AppTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        H5App *app = _appArray[indexPath.row];
        
        [cell setAppDataWithApp:app];
        
        return cell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _menuTableView) {
        //菜单列
        [self setMenuSelectedWithIndexPath:indexPath];
        
    } else if (tableView == _contentTableView) {
        //内容列
        H5App *currentApp = [_appArray objectAtIndex:indexPath.row];
        WebAppViewController *vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"WebAppViewController"];
        [vc setCurrentApp:currentApp];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


- (void)setMenuSelectedWithIndexPath:(NSIndexPath *) indexPath {
    
    if (indexPath.row != _selectIndex) {
        
        AddAppMenuTableViewCell *lastCell = (AddAppMenuTableViewCell *)[_menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        lastCell.backImage.backgroundColor = [UIColor grayColor];
        
        AddAppMenuTableViewCell *cell = (AddAppMenuTableViewCell *)[_menuTableView cellForRowAtIndexPath:indexPath];
        cell.backImage.backgroundColor = [UIColor blackColor];
        _selectIndex = (int)indexPath.row;
        
        [self searchApp];
        
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _menuTableView) {
        //菜单列
        return _menuNames.count;
        
    } else if (tableView == _contentTableView) {
        //内容列
        return _appArray.count;
        
    }
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _menuTableView) {
        //菜单列
        
        return 60;
        
    } else if (tableView == _contentTableView) {
        //内容列
        
        return 70;
        
    }
    
    return 0;
}


/**
 *  点击菜单列选项后搜索具体返回内容
 *
 *  @param index 菜单列选中下标
 */
- (void)searchApp {
    
    NSDictionary *param = @{kMethod:kMethodSearchApp, @"uid":AppDelegateInstance.userId, @"query":_menuNames[_selectIndex], @"size":@50};
    
    
    [HttpManager requestServiceWithParam:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:kCode] intValue] == 0) {
            
            [_appArray removeAllObjects];
            
            NSArray *responseData = [responseObject objectForKey:@"sites"];
            
            for (NSDictionary *appDic in responseData) {
                
                H5App *app = [[H5App alloc] initWithDictionary:appDic];
                
                [_appArray addObject:app];
            }
            
            
        }
        
        [_contentTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}



- (IBAction)searchAction {
    
    SearchViewController *vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:vc animated:NO];
    
}





- (IBAction)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
