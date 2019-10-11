//
//  ProductDetailThreeTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCommentModel.h"
@interface ProductDetailThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ontStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fiveStarImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;

- (void)updateProductDetailThreeCellWithModel:(ProductCommentModel *)tempModel;

@end
