//
//  MyAgentCommissionTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/12/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAgentCommissionModel.h"
@interface MyAgentCommissionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)updateMyAgentCommissionCellWithCommissionModel:(MyAgentCommissionModel *)tempModel withIsNew:(BOOL)isNew;


@end
