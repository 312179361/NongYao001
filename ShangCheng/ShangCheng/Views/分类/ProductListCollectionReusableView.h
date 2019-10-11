//
//  ProductListCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 枚举产品列表中有9个类型，
 0、关注度降序   1、关注度升序
 2、销量降序     3、销量升序
 4、价格升序     5、价格降序
 6、时间降序     7、时间升序
 8、默认
 */
typedef NS_ENUM(NSInteger , SortType) {
    HitsDown,
    HitsUp,
    SalesDown,
    SalesUp,
    PriceUp,
    PriceDown,
    DateDown,
    DateUp,
    DefaultType
};

@interface ProductListCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;

- (void)updateProductListCollectionHeaderViewWithSortType:(SortType )sortType;

@end
