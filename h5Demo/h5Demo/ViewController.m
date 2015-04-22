//
//  ViewController.m
//  h5Demo
//
//  Created by 邹俊 on 15/4/2.
//  Copyright (c) 2015年 尚娱网络. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "MQHorizontalFlowLayout.h"
#import "H5AppCollectionViewCell.h"
#import "WebAppViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>{
    
    int _rowCount;
    int _columnCount;
    
    BOOL _editStatus;    //是否是编辑状态
    BOOL _scrollPage;    //是否滚动到旁边页
    

    NSIndexPath *_longPressIndexPath;   //长按的cell  indexPath
    
    CGFloat _pageWidth;
    
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *bodyImageView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) UIView *snapshot;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _rowCount = 5;
    _columnCount = 4;
    
    _pageWidth = _collectionView.frame.size.width;
    
    _editStatus = NO;
    _scrollPage = NO;
    
    [self setCollectionviewAttribution];
    
    
    
}


- (void)setCollectionviewAttribution {
    
    MQHorizontalFlowLayout *layout = [[MQHorizontalFlowLayout alloc] init];
    layout.rowCount = _rowCount;
    layout.columnCount = _columnCount;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"H5AppCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"H5AppCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"H5AppCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HiddenCell"];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.collectionViewLayout = layout;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_collectionView addGestureRecognizer:gesture];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownToSearch:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [_collectionView addGestureRecognizer:swipe];
    
}


#pragma mark - UICollectionView 代理方法

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    H5AppCollectionViewCell *cell;
    if ([indexPath isEqual:_longPressIndexPath]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HiddenCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"H5AppCollectionViewCell" forIndexPath:indexPath];
    }
    cell.deleteButton.tag = 1000+indexPath.item;
    [cell.deleteButton addTarget:self action:@selector(deleteAppAction:) forControlEvents:UIControlEventTouchUpInside];

    H5App *app = [AppDelegateInstance.apps objectAtIndex:indexPath.item];
    [cell setAppDataWithApp:app];
    

    if (_editStatus) {
        [self rotateAnimationWithCell:cell];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //设置分页数据
    _pageControl.numberOfPages = (int)AppDelegateInstance.apps.count%(_rowCount*_columnCount) == 0?
    (int)AppDelegateInstance.apps.count/(_rowCount*_columnCount):(int)AppDelegateInstance.apps.count/(_rowCount*_columnCount)+1;
    
    return AppDelegateInstance.apps.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    H5App *currentApp = [AppDelegateInstance.apps objectAtIndex:indexPath.item];
    WebAppViewController *vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"WebAppViewController"];
    [vc setCurrentApp:currentApp];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_editStatus) {
        return NO;
    }else{
        return YES;
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPage = scrollView.contentOffset.x/_pageWidth;
    _pageControl.currentPage = currentPage;
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateCanScroll) userInfo:nil repeats:NO];

    
    int currentPage = scrollView.contentOffset.x/_pageWidth;
    _pageControl.currentPage = currentPage;
    
}


- (void)updateCanScroll {
    _scrollPage = NO;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x-(_pageControl.currentPage)*_pageWidth;
    CGPoint center = _snapshot.center;
    center.x = center.x+x;
    _snapshot.center = center;
    
}

- (void)deleteAppAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1000;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    H5App *app = [AppDelegateInstance.apps objectAtIndex:index];
    if([AppDelegateInstance.db executeUpdate:@"DELETE FROM app WHERE appid=?", app.appid]) {
        
        for (int i=(int)index+1; i<AppDelegateInstance.apps.count; i++) {
            H5AppCollectionViewCell *cell = (H5AppCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.deleteButton.tag = cell.deleteButton.tag-1;
        }
        
        [AppDelegateInstance.apps removeObjectAtIndex:indexPath.item];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    }
    
}


#pragma mark - 长按移动删除
/**
 *  长按触发方法
 *
 *  @param sender 长按手势
 */
- (void)longPressAction:(id)sender {
    
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = gesture.state;
    
    CGPoint location = [gesture locationInView:_collectionView];
    CGPoint center;
    
    
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:location];
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            if (indexPath) {
                
                [self appearDoneButton];
                
                [self initToEditStatusAtIndexPath:indexPath];
                
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            
            center = location;
            _snapshot.center = center;
            
             [self scrollPageWithLocation:location];
            
          if (indexPath && _longPressIndexPath  && ![indexPath isEqual:_longPressIndexPath]) {
              
                [self changeDataSourceFromIndexPth:_longPressIndexPath toIndexPath:indexPath];
              
            }
            
            
            break;
            
        default:
            [self scaleDefaultAnimation:_longPressIndexPath];
            
            
            break;
    }
}


- (void)scrollPageWithLocation:(CGPoint) location {
    
    int currentPage = (int)_pageControl.currentPage;
    int pages = (int)_pageControl.numberOfPages;
    
    if (!_scrollPage && pages>1) {
        
        if (currentPage<pages-1&&location.x>=(currentPage+1)*SCREEN_WIDTH-40) {
            
            _scrollPage = YES;
            [_collectionView scrollRectToVisible:CGRectMake((currentPage+1)*SCREEN_WIDTH, _collectionView.frame.origin.y, _collectionView.frame.size.width, _collectionView.frame.size.height) animated:YES];

        }
        
        if (currentPage>0 && location.x<=currentPage*SCREEN_WIDTH+40) {

            _scrollPage = YES;
            [_collectionView scrollRectToVisible:CGRectMake((currentPage-1)*SCREEN_WIDTH, _collectionView.frame.origin.y, _collectionView.frame.size.width, _collectionView.frame.size.height) animated:YES];
        }
        
    }
    
    
}


/**
 *  编辑状态出现完成按钮
 */
- (void)appearDoneButton {
    
    UIButton *doneButton = (UIButton *)[_footView viewWithTag:100];
    if (!doneButton) {
        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, _footView.frame.size.height, SCREEN_WIDTH, 40);
        doneButton.tag = 100;
        doneButton.backgroundColor = [UIColor redColor];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:doneButton];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        doneButton.frame = CGRectMake(0, _footView.frame.size.height-40, SCREEN_WIDTH, 40);
    }];
}


/**
 *  完成按钮点击动作
 */
- (void)doneButtonAction {
    
    _editStatus = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *doneButton = (UIButton *)[_footView viewWithTag:100];
        doneButton.frame = CGRectMake(0, _footView.frame.size.height, SCREEN_WIDTH, 40);
    }];
    
    [_collectionView reloadData];
    
}


/**
 *  移动后更新数据源中的数据排列
 *
 *  @param fromIndexPath 移动的cell下标
 *  @param toIndexPath   移动到的cell下标
 */
- (void)changeDataSourceFromIndexPth:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    if (!_scrollPage) {
     
        H5App *app = [AppDelegateInstance.apps objectAtIndex:fromIndexPath.item];
        
        BOOL moveAfter = toIndexPath.item>fromIndexPath.item?YES:NO;
        
        if (moveAfter) {
            
            H5AppCollectionViewCell *longPressCell = (H5AppCollectionViewCell *)[_collectionView cellForItemAtIndexPath:fromIndexPath];
            longPressCell.deleteButton.tag = 1000+toIndexPath.item;
            
            for (int i=(int)fromIndexPath.item+1; i<=toIndexPath.item; i++) {
                H5AppCollectionViewCell *cell = (H5AppCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                
                cell.deleteButton.tag = cell.deleteButton.tag-1;
                
            }
        } else {
            H5AppCollectionViewCell *longPressCell = (H5AppCollectionViewCell *)[_collectionView cellForItemAtIndexPath:fromIndexPath];
            longPressCell.deleteButton.tag = 1000+toIndexPath.item;
            
            for (int i=(int)toIndexPath.item; i<=fromIndexPath.item-1; i++) {
                H5AppCollectionViewCell *cell = (H5AppCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                
                cell.deleteButton.tag = cell.deleteButton.tag+1;
                
            }
        }
        
        
        [AppDelegateInstance.apps removeObjectAtIndex:fromIndexPath.item];
        
        [AppDelegateInstance.apps insertObject:app atIndex:toIndexPath.item];
        
        _longPressIndexPath = toIndexPath;
        
        [_collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        
        
        
    }
    
}


/**
 *  获取快照
 *
 *  @param inputView 快照相应的本体
 *
 *  @return 快照
 */
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:inputView.center];
    H5AppCollectionViewCell *snapshot = (H5AppCollectionViewCell *)_snapshot;
    if (!snapshot) {
        snapshot = [[[NSBundle mainBundle] loadNibNamed:@"H5AppCollectionViewCell" owner:nil options:nil] lastObject];
        H5App *app = [AppDelegateInstance.apps objectAtIndex:indexPath.item];
        [snapshot setAppDataWithApp:app];
        snapshot.deleteButton.hidden = NO;
        snapshot.layer.masksToBounds = NO;
        snapshot.layer.cornerRadius = 0.0;
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;
    }
    return snapshot;
}

/**
 *  进行编辑前的初始化
 *
 *  @param indexPath 长按的cell 下标
 */
- (void)initToEditStatusAtIndexPath:(NSIndexPath *) indexPath {
    
    _longPressIndexPath = indexPath;
    
    _editStatus = YES;
        
    [_collectionView reloadData];
    
    
}

/**
 *  编辑状态让每个cell进行抖动
 *
 *  @param cell 抖动的cell
 */
- (void)rotateAnimationWithCell:(H5AppCollectionViewCell *)cell {
    cell.deleteButton.hidden = NO;
    
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:cell.center];
    if (_longPressIndexPath && [indexPath isEqual:_longPressIndexPath]) {
        
        [self scaleAnimationWithLongPressCell:cell];
    }
    
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:-3*M_PI/180.];
        animation.toValue = [NSNumber numberWithFloat:3*M_PI/180.];
        animation.duration = 0.1; // 动画持续时间
        animation.repeatCount = HUGE_VALF; // 一直重复
        animation.autoreverses = YES; // 结束后执行逆动画
        
        [cell.layer addAnimation:animation forKey:@"rotate-layer"];
    
    
}

/**
 *  长按的cell 放大显示
 */
- (void)scaleAnimationWithLongPressCell:(H5AppCollectionViewCell *)cell {
    
    // Take a snapshot of the selected row using helper method.
    _snapshot = [self customSnapshotFromView:cell];
    
    // Add the snapshot as subview, centered at cell's center...
    __block CGPoint center = cell.center;
    _snapshot.center = center;
    _snapshot.alpha = 0.0;
    [_collectionView addSubview:_snapshot];
    [UIView animateWithDuration:0.25 animations:^{
        
        _snapshot.alpha = 1;
        _snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
        
        cell.alpha = 0.;
        cell.hidden = YES;
        
        
    } completion:nil];
    
}

/**
 *  放手之后缩放回到初始值
 *
 *  @param indexPath 长按的cell下标
 */
- (void)scaleDefaultAnimation:(NSIndexPath *)indexPath {
    
    
    // Clean up.
    H5AppCollectionViewCell *cell = (H5AppCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    _longPressIndexPath = nil;
    [UIView animateWithDuration:0.25 animations:^{
        
        _snapshot.center = cell.center;
        _snapshot.transform = CGAffineTransformIdentity;
        _snapshot.alpha = 0.0;
        
        
        cell.alpha = 1.;
        cell.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        
        
        [_snapshot removeFromSuperview];
        _snapshot = nil;
        
    }];

    
}



- (IBAction)dropDownToSearch:(id)sender {
    
    SearchViewController *vc = [AppDelegateInstance.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:vc animated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [_collectionView reloadData];
    
    
    
}

@end
