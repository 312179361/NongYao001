//
//  CompleteCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/27.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFavoriteListModel.h"
@interface CompleteCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

- (void)updateCompleteCellWithModel:(MyFavoriteListModel *)tempModel;

@end
