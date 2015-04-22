//
//  SearchViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/3.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "SearchViewController.h"
#import "AppTableViewCell.h"
#import "WebAppViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    
    BOOL _searchStatus;         // 搜索状态：yes为点击了搜索得出了结果后，no为还未点击搜索
    
    
    NSMutableArray *_responseSearchArray;      // 搜索后返回的应用集合
    NSMutableArray *_latestSearchArray;  //最近搜索
    NSArray *_hotSearchArray;                 //热门搜索
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewsAttribution];
    
    [self initData];
    
    
    
}

/**
 *  初始化View的属性
 */
- (void)initViewsAttribution {
    
    [_searchTextField becomeFirstResponder];
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.layer.borderColor = [[UIColor grayColor] CGColor];
    _searchTextField.layer.borderWidth = 1;
    
    
    
    
}

/**
 *  初始化数据
 */
- (void)initData {
    
    _searchStatus = NO;
    
    _responseSearchArray = [NSMutableArray array];
    _latestSearchArray = [NSMutableArray array];
    [self getLatestSeachData];
    _hotSearchArray = @[@"1. 唯品会", @"2. 京东商城", @"3. 亚马逊", @"4. 当当网", @"5. 一号店", @"6. 淘宝网", @"7. 银泰网", @"8. 乐峰网"];
    
}


/**
 *  获取最近搜索数据
 */
- (void)getLatestSeachData {
    
    [_latestSearchArray addObjectsFromArray:[AppDelegateInstance selectDataFromSearch]];
    
    
}


#pragma mark - delegate、datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_searchStatus) {
        //还没有进行搜索时的cell
        static NSString *identify = @"NoSearchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(0, 0, 30, 30);
            [deleteBtn setBackgroundImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteLatestSearchAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = deleteBtn;
            
        }
        if (_latestSearchArray.count == 0) {
            cell.accessoryView.hidden = YES;
            cell.textLabel.text = _hotSearchArray[indexPath.row];
        }else {
            if (indexPath.section == 0) {
                cell.accessoryView.hidden = NO;
                cell.accessoryView.tag = 100+indexPath.row;
                cell.textLabel.text = _latestSearchArray[indexPath.row];
            }else if (indexPath.section == 1) {
                cell.accessoryView.hidden = YES;
                cell.textLabel.text = _hotSearchArray[indexPath.row];
            }
        }
        return cell;
    } else {
        //点击了搜索后的cell
        static NSString *identify = @"SearchCell";
        AppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AppTableViewCell" owner:self options:nil] lastObject];
        }
        
        H5App *app = _responseSearchArray[indexPath.row];
        
        [cell setAppDataWithApp:app];
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_searchStatus) {
        
        NSString *searchText;
        
        if (_latestSearchArray.count == 0) {
            searchText = [_hotSearchArray[indexPath.row] substringFromIndex:3];
        } else {
            if (indexPath.section == 0) {
                searchText = _latestSearchArray[indexPath.row];
            } else {
                searchText = [_hotSearchArray[indexPath.row] substringFromIndex:3];
            }
        }
        
        _searchTextField.text = searchText;
        
        [self searchAction];
        
    } else {
        
        H5App *currentApp = [_responseSearchArray objectAtIndex:indexPath.row];
        WebAppViewController *vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"WebAppViewController"];
        [vc setCurrentApp:currentApp];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }

}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchTextField resignFirstResponder];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!_searchStatus) {
        
        if (_latestSearchArray.count == 0) {
            return _hotSearchArray.count;
        }else {
            if (section == 0) {
                return _latestSearchArray.count;
            }else {
                return _hotSearchArray.count;
            }
        }
        
    } else {
        return _responseSearchArray.count;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_searchStatus) {
        if (_latestSearchArray.count == 0) {
            return 1;
        }
        return 2;
    } else {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_searchStatus) {
        return 44;
    } else {
        return 70;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!_searchStatus) {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        head.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 20)];
        [head addSubview:label];
        
        if (_latestSearchArray.count == 0) {
            label.text = @"热门搜索";
        }else {
            if (section == 0) {
                label.text = @"最近搜索";
            }else if (section == 1) {
                label.text = @"热门搜索";
            }
        }
        return head;
    } else {
        UIView *head = [[UIView alloc] initWithFrame:CGRectZero];
        return head;
    }
}


#pragma mark - 输入框代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self searchAction];
    
    return YES;
}





/**
 *  删除最近搜索的条目
 */
- (void)deleteLatestSearchAction:(UIView *)sender {
    
    int index = (int)sender.tag - 100;
    
    NSString *searchText = _latestSearchArray[index];
    
    [_latestSearchArray removeObjectAtIndex:index];
    
    [AppDelegateInstance deleteDataFromSearch:searchText];
    
    [_tableView reloadData];
    
    
}


- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
    
}


/**
 * 搜索
 */
- (IBAction)searchAction {
    
    [_searchTextField resignFirstResponder];
    
    NSString *searchContent = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchContent.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"输入内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        
        //查询最近搜索数组中是否存在当前搜索的关键词
        if(![_latestSearchArray containsObject:searchContent]) {
            //如果不存在，把关键词插入最近搜索的数组以及数据库中
            
            [self insertLatestSearchText:searchContent];
        }
        
        [self requestSearch:searchContent];
        
    }
    
}

/**
 *  插入最近搜索数据到_latestSearchArray 以及 数据库的搜索表中
 *
 *  @param searchText 搜索关键字
 */
- (void)insertLatestSearchText:(NSString *)searchText {
    
    [_latestSearchArray insertObject:searchText atIndex:0];
    
    [AppDelegateInstance insertDataToSearch:searchText];
    
}


/**
 *  搜索请求
 */
- (void)requestSearch:(NSString *)searchText {
    
   
    
    NSDictionary *param = @{kMethod:kMethodSearchApp, @"uid":AppDelegateInstance.userId, @"query":searchText, @"size":@20};
    
    
    [HttpManager requestServiceWithParam:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if ([[responseObject objectForKey:kCode] intValue] == 0) {
            
            [_responseSearchArray removeAllObjects];
            
            _searchStatus = YES;
            
            NSArray *responseData = [responseObject objectForKey:@"sites"];
            
            for (NSDictionary *appDic in responseData) {
                
                H5App *app = [[H5App alloc] initWithDictionary:appDic];
                
                [_responseSearchArray addObject:app];
            }
            
            
        }

        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
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
