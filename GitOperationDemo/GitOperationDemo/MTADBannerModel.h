//
//  MTADBannerModel.h
//  GitOperationDemo
//
//  Created by ASSASSIN on 2020/12/4.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ADBannerCellType) {
    ADBannerLiCaiProductType = 0,//理财产品
    ADBannerRemindType = 1,//提醒
    ADBannerQuestionType = 2,//问答
    ADBannerWishDepositType = 3//心愿储蓄
};

NS_ASSUME_NONNULL_BEGIN

@interface MTADBannerModel : NSObject
///标题
@property(nonatomic,copy)NSString *title;
///cell类型
@property(nonatomic,assign)ADBannerCellType cellType;

@end

NS_ASSUME_NONNULL_END
