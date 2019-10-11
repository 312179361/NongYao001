//
//  PestsListTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PestsListModel.h"
@interface PestsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pestsImageView;
@property (weak, nonatomic) IBOutlet UILabel *pestsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pestsDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pestsAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pestsTimeLabel;

- (void)updatePestsListCellWithModel:(PestsListModel *)tempModel;

@end
