//
//  MTBannerViewController.m
//  GitOperationDemo
//
//  Created by ASSASSIN on 2020/12/4.
//

#import "MTBannerViewController.h"
#import "MTADBannerView.h"
#import "MTADBannerModel.h"

@interface MTBannerViewController ()<MTADBannerViewDelegate>

@property(nonatomic,strong)MTADBannerView *banner;
@property(nonatomic,strong)NSMutableArray<MTADBannerModel *> *datasource;

@end

@implementation MTBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    self.datasource = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        MTADBannerModel *model = [MTADBannerModel new];
        model.title = [NSString stringWithFormat:@"item Index = %d",i];
        [self.datasource addObject:model];
    }
    
    [self.view addSubview:self.banner];
    [self.banner reloadData];
}

-(MTADBannerView *)banner {
    if (!_banner) {
        _banner = [[MTADBannerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 120)];
        _banner.delegate = self;
    }
    return _banner;
}

#pragma mark - MTADBannerViewDelegate

-(NSInteger)numberOfItemInBannerView {
    return self.datasource.count;
}

-(void)didSelectedItem:(id)model atIndex:(NSInteger)index {
    MTADBannerModel *ss = model;
    NSLog(@"index = %ld title = %@",index,ss.title);
}

-(id)itemModelAtIndex:(NSInteger)index {
    return self.datasource[index];
}

@end
