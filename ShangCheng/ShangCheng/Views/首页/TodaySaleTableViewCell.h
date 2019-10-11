//
//  TodaySaleTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodaySaleModel.h"
@interface TodaySaleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todayTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *todayImageView;

- (void)updateTodaySaleCellWithModel:(TodaySaleModel *)tempModel;
@end
