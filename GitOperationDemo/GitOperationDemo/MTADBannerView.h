//
//  MTADBannerView.h
//  GitOperationDemo
//
//  Created by ASSASSIN on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MTADBannerViewDelegate <NSObject>

-(NSInteger)numberOfItemInBannerView;
-(void)didSelectedItem:(id)model atIndex:(NSInteger)index;
-(id)itemModelAtIndex:(NSInteger)index;
-(UICollectionView *)cellForItemAtIndex:(NSInteger)index;

@end

@interface MTADBannerView : UIView

@property(nonatomic,weak)id<MTADBannerViewDelegate> delegate;

-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
