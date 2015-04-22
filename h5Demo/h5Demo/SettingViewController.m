//
//  SettingViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/3.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "SettingViewController.h"
#import "OperationGuideViewController.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSArray *_titles;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
}

- (void)initData {
    _titles = [NSArray arrayWithObjects:@"操作指南", @"反馈", @"关于", nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titles[indexPath.section+indexPath.row];
    
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            
        default:
            return 2;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc;
    switch (indexPath.section+indexPath.row) {
        case 0:
            //操作指南
            vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"OperationGuideViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        case 1:
            //反馈
            vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        case 2:
            vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        default:
            break;
    }
    
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
