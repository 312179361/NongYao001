//
//  ProductDetailHeaderTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineButton.h"
typedef NS_ENUM(NSInteger , SelectType) {
    SelectTypeProductDetail,
    SelectTypeUseInfo,
    SelectTypeUserComment,
    SelectTypeTradeList
};

@interface ProductDetailHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet LineButton *buttonOne;
@property (weak, nonatomic) IBOutlet LineButton *buttonTwo;
@property (weak, nonatomic) IBOutlet LineButton *buttonThree;
@property (weak, nonatomic) IBOutlet LineButton *buttonFour;

- (void)updateButtonUIWithType:(SelectType)selectType withCommentCount:(NSInteger)commentCount withTradeCount:(NSInteger)tradeCount;


@end
