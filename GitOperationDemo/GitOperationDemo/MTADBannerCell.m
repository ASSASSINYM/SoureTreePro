//
//  MTADBannerCell.m
//  GitOperationDemo
//
//  Created by ASSASSIN on 2020/12/4.
//

#import "MTADBannerCell.h"
#import "MTADBannerModel.h"

@interface MTADBannerCell ()

@property(nonatomic,weak)IBOutlet UILabel *titleLabel;

@end

@implementation MTADBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setter

-(void)setModel:(id)model {
    _model = model;
    
    self.titleLabel.text = ((MTADBannerModel *)model).title;
}

@end
