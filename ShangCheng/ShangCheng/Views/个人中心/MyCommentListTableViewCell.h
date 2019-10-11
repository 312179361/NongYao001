//
//  MyCommentListTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentListModel.h"
@interface MyCommentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *oneStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fiveStarImageView;

@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;
- (void)updateMyCommentCellWithCommentModel:(MyCommentListModel *)tempModel;



@end
