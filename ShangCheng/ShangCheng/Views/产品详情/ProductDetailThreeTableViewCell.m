//
//  ProductDetailThreeTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductDetailThreeTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation ProductDetailThreeTableViewCell
- (void)updateProductDetailThreeCellWithModel:(ProductCommentModel *)tempModel {

    [self.headerImageView setWebImageURLWithImageUrlStr:tempModel.u_icon withErrorImage:[UIImage imageNamed:@"w_icon_mrtx"] withIsCenter:NO];
    self.nameLabel.text = tempModel.mobile;
    //星级
    [self showStarWithLevel:[tempModel.r_star_level integerValue]];
    //内容
    self.contentLabel.text = tempModel.r_content;
    self.timeLabel.text = tempModel.r_time_create;
    
    if (tempModel.r_content_reply.length > 0) {
        self.replyContentLabel.text = [NSString stringWithFormat:@"回复 %@：%@",tempModel.mobile, tempModel.r_content_reply ];
    }else {
        self.replyContentLabel.text = @"";
    }
}

- (void)showStarWithLevel:(NSInteger )level {
    self.ontStarImageView.hidden = YES;
    self.twoStarImageView.hidden = YES;
    self.threeStarImageView.hidden = YES;
    self.fourStarImageView.hidden = YES;
    self.fiveStarImageView.hidden = YES;
    
    switch (level) {
        case 1:
            self.ontStarImageView.hidden = NO;
            break;
        case 2:
            self.ontStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            break;
        case 3:
            self.ontStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            break;
        case 4:
            self.ontStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = NO;
            break;
        case 5:
            self.ontStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = NO;
            self.fiveStarImageView.hidden = NO;
            break;
        default:
            break;
    }
    
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
