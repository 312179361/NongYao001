//
//  PestsListTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PestsListTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation PestsListTableViewCell

- (void)updatePestsListCellWithModel:(PestsListModel *)tempModel {
    
    
    [self.pestsImageView setWebImageURLWithImageUrlStr:tempModel.i_icon_path withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.pestsTitleLabel.text = tempModel.i_title;
    self.pestsDetailLabel.text = tempModel.i_introduce;
    self.pestsAuthorLabel.text = tempModel.i_author;
    self.pestsTimeLabel.text = tempModel.i_time_create;
    
    
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
