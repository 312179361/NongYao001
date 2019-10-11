//
//  ShoppingCarTwoCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFavoriteListModel.h"
#import "IndexButton.h"
@interface ShoppingCarTwoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myFavoriteImageView;
@property (weak, nonatomic) IBOutlet UILabel *myFavoriteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myFavoriteFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *myFavoritePriceLabel;
@property (weak, nonatomic) IBOutlet IndexButton *joinShoppingCarButton;

- (void)updateShoppingCarTwoCellWithModel:(MyFavoriteListModel *)tempModel;


@end
