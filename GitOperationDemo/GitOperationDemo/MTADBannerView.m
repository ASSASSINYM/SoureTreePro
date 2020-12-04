//
//  MTADBannerView.m
//  GitOperationDemo
//
//  Created by ASSASSIN on 2020/12/4.
//

#import "MTADBannerView.h"
#import "MTADBannerCell.h"

#define MT_CELL_IDENTIFIER @"mTADBannerCell"


@interface MTADBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)NSTimer *timer;

@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation MTADBannerView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        UINib *nibCell = [UINib nibWithNibName:@"MTADBannerCell" bundle:nil];
        [self.collectionView registerNib:nibCell forCellWithReuseIdentifier:MT_CELL_IDENTIFIER];
        
        
    }
    return self;
}

#pragma mark - getter

-(UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = self.bounds.size;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    
    }
    return _collectionView;
}

-(NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            CGFloat offsetX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width;
            self.collectionView.contentOffset = CGPointMake(offsetX, self.bounds.size.height);
        }];
    }
    return _timer;
}

#pragma mark - reload data

-(void)reloadData {
    [self.collectionView reloadData];
    [self.timer fire];
}

#pragma mark - collectionview datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.delegate) {
        return [self.delegate numberOfItemInBannerView];
    }else {
        return 0;
    }
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MTADBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MT_CELL_IDENTIFIER forIndexPath:indexPath];
    UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];

    cell.backgroundColor = randomColor;
    if (self.delegate) {
        id model = [self.delegate itemModelAtIndex:indexPath.row];
        [cell setModel:model];
    }
    
    return cell;
}

#pragma mark - collectionview delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        id model = [self.delegate itemModelAtIndex:indexPath.row];
        [self.delegate didSelectedItem:model atIndex:indexPath.row];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger totoalItemNum = [self.delegate numberOfItemInBannerView];
    CGFloat itemWith = self.bounds.size.width;
    //CGFloat itemHeight = self.bounds.size.height;
    if (scrollView.contentOffset.x == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:totoalItemNum];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    if (scrollView.contentOffset.x == totoalItemNum * itemWith) {
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}


@end
