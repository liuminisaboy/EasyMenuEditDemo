//
//  ViewController.m
//  EasyMenuEditDemo
//
//  Created by Sen on 2019/6/12.
//  Copyright © 2019年 easyhud. All rights reserved.
//

#import "ViewController.h"
#import "MenuCollectionViewCell.h"

@interface ViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView* myCollectionView;

@property (nonatomic, strong) MenuCollectionViewCell* dragingCell;

@property (nonatomic, strong) NSMutableArray* listInfo;

@end

@implementation ViewController
{
    NSIndexPath* fromIndexPath;
    NSIndexPath* toIndexPath;
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.myCollectionView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UILongPressGestureRecognizer* longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longP.minimumPressDuration = 0.3f;
    [self.myCollectionView addGestureRecognizer:longP];

    /*
     CGRectContainsPoint(frame, point) 判断一个点是否被一个cgrect所包含
     indexPathsForVisibleItems collectionView的当前视图可见items数组
     
     exchangeObjectAtIndex 数组中元素交换位置
     
     */
    
    _listInfo = [NSMutableArray arrayWithArray:@[@"临",@"兵",@"斗",@"者",@"皆",@"阵",@"列",@"在",@"前"]];
    [self.myCollectionView reloadData];
}

#pragma mark - long press
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    
    CGPoint point = [gesture locationInView:_myCollectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            
            
            //得到 from 的cell的indexPath
            fromIndexPath = [self getDragingIndexPathWithPoint:point];
            
            if (!fromIndexPath) {
                NSLog(@"并没有拖动。。。");
                return;
            }
            
            //得到 from cell
            MenuCollectionViewCell* cell = (MenuCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:fromIndexPath];
            
            //将 from cell 的信息和位置给到 to cell
            self.dragingCell.frame = cell.frame;
            self.dragingCell.titleLabel.text = cell.titleLabel.text;
            
            [UIView animateWithDuration:0.35 animations:^{
                [self.dragingCell setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
            }];
            
            //将 from cell隐藏
            cell.hidden = YES;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            //
            
            if (!fromIndexPath) {
                NSLog(@"并没有拖动。。。");
                return;
            }
            
            _dragingCell.center = point;
            
            //得到 to cell的indexPath
            toIndexPath = [self getTargetIndexPathWithPoint:point];
            
            //from -> to
            if (fromIndexPath && toIndexPath) {
                
                //元数据替换
                [_listInfo exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
                
                //动画移动cell
                [_myCollectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                
                //
                fromIndexPath = toIndexPath;
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //
            if (!fromIndexPath) {
                NSLog(@"并没有拖动。。。");
                return;
            }
            
            //恢复
            [_dragingCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            
            
            MenuCollectionViewCell* cell = (MenuCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:fromIndexPath];
            [UIView animateWithDuration:0.35 animations:^{
                self.dragingCell.frame = cell.frame;
            } completion:^(BOOL finished) {
                [self.dragingCell removeFromSuperview];
                self.dragingCell = nil;
                
                cell.hidden = NO;
                
            }];
            
            break;
        }
        default:
            break;
    }
    
}


- (NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    
    NSIndexPath* tmp = nil;
    
    //遍历当前屏幕中的cell
    for (NSIndexPath* indexPath in _myCollectionView.indexPathsForVisibleItems) {
        
        MenuCollectionViewCell* cell = (MenuCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:indexPath];
        
        //判断当前这个point是属于哪个cell的
        if (CGRectContainsPoint(cell.frame, point)) {
            tmp = indexPath;
            break;
        }
    }
    return tmp;
}
- (NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    
    NSIndexPath* tmp = nil;
    
    //遍历当前屏幕中的cell
    for (NSIndexPath* indexPath in _myCollectionView.indexPathsForVisibleItems) {
        
        if ([indexPath isEqual:fromIndexPath]) {
            continue;
        }
        
        MenuCollectionViewCell* cell = (MenuCollectionViewCell*)[_myCollectionView cellForItemAtIndexPath:indexPath];
        
        //判断当前这个point是属于哪个cell的
        if (CGRectContainsPoint(cell.frame, point)) {
            tmp = indexPath;
            break;
        }
    }
    return tmp;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _listInfo.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MenuCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCollectionViewCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = _listInfo[indexPath.row];
    
    return cell;
}

#pragma mark - lazy

- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        
        CGFloat w = (self.view.bounds.size.width-2)/3;
        CGFloat h = w;
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.itemSize = CGSizeMake(w, h);
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor lightGrayColor];
        _myCollectionView.alwaysBounceVertical = YES;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        [_myCollectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:@"MenuCollectionViewCell"];
    }
    return _myCollectionView;
}

- (MenuCollectionViewCell *)dragingCell{
    if (!_dragingCell) {
        _dragingCell = [[MenuCollectionViewCell alloc] initWithFrame:CGRectZero];
        [self.myCollectionView addSubview:_dragingCell];
        
        _dragingCell.layer.shadowColor = [UIColor blackColor].CGColor;
        _dragingCell.layer.shadowOffset = CGSizeMake(0,0);
        _dragingCell.layer.shadowOpacity = 0.5;
        _dragingCell.layer.shadowRadius = 5;
        
    }
    return _dragingCell;
}


@end
