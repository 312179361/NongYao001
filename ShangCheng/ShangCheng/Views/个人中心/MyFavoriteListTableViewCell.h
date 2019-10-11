//
//  MyFavoriteListTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
#import "MyFavoriteListModel.h"
#import "ProductModel.h"
@interface MyFavoriteListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCompanyLabel;

@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

@property (weak, nonatomic) IBOutlet IndexButton *deleteButton;
@property (weak, nonatomic) IBOutlet IndexButton *joinShoppingCarButton;

- (void)updateMyFavoriteListCell:(MyFavoriteListModel *)myFavotiteProductModel;
- (void)updateMyBrowerListCell:(ProductModel *)myBrowerProductModel;


@end
