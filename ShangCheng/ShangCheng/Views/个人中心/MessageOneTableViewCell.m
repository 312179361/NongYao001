//
//  MessageOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/4/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MessageOneTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation MessageOneTableViewCell
- (void)updateMessageCellWithModel:(MessageNotificationModel *)tempModel {
    
    [self.headerImageView setWebImageURLWithImageUrlStr:tempModel.i_icon_path withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.messageTitleLabel.text = tempModel.i_title;
    self.messageContentLabel.text = tempModel.i_introduce;

    self.messageTimeLabel.text = tempModel.i_time_create;

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
