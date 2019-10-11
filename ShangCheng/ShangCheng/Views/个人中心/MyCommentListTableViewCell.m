//
//  MyCommentListTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyCommentListTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation MyCommentListTableViewCell
- (void)updateMyCommentCellWithCommentModel:(MyCommentListModel *)tempModel {
    
    [self.productImageView setWebImageURLWithImageUrlStr:tempModel.productImageUrl withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.productNameLabel.text = tempModel.productTitleStr;
    self.productFormatLabel.text = tempModel.productFormatStr;
    self.companyLabel.text = [NSString stringWithFormat:@"￥%@" ,tempModel.productPrice ];
    self.commentDetailLabel.text = tempModel.detailCommentStr;
    self.commentTimeLabel.text = tempModel.commentTimeStr;
    
    //星级
    switch (tempModel.starCount) {
        case 1:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = YES;
            self.threeStarImageView.hidden = YES;
            self.fourStarImageView.hidden = YES;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 2:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = YES;
            self.fourStarImageView.hidden = YES;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 3:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = YES;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 4:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = NO;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 5:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = NO;
            self.fiveStarImageView.hidden = NO;
        }
            break;
        default:
            break;
    }
    
    if (tempModel.r_content_reply.length > 0) {
        self.replyContentLabel.text = [NSString stringWithFormat:@"回复我：%@", tempModel.r_content_reply ];
    }else {
        self.replyContentLabel.text = @"";
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
