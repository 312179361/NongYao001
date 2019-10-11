//
//  ShoppingCarTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/19.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"

typedef void(^DeleteSuccessBlock)(NSIndexPath *);
typedef void(^TotalPriceBlock)();
@interface ShoppingCarTableViewCell : UITableViewCell
//@property (nonatomic,strong)NSIndexPath *tempIndex;
//通过index得到模型
//@property (nonatomic,strong)ShoppingCarModel *tempShoppingCarModel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
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
