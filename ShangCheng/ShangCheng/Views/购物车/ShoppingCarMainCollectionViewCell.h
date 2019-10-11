//
//  ShoppingCarMainCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"

typedef void(^DeleteSuccessBlock)(NSIndexPath *);
typedef void(^TotalPriceBlock)();

@interface ShoppingCarMainCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIButton *selectButton;
//活动图标
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *formatLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCountButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *lessCountButton;

//删除成功block
@property (nonatomic,copy)DeleteSuccessBlock deleteSuccessBlock;
//计算总价
@property (nonatomic,copy)TotalPriceBlock totalPriceBlock;

- (void)updateCellWithCellIndex:(NSIndexPath *)cellIndex;



@end
