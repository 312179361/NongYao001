//
//  MessageOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/4/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageNotificationModel.h"
@interface MessageOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;

- (void)updateMessageCellWithModel:(MessageNotificationModel *)tempModel;
@end
