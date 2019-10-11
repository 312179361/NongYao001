//
//  PayTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/13.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *payCellTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectMarkImageView;

- (void)updatePayCellWithJsonDic:(NSDictionary *)jsonDic withShowSelectPayKind:(BOOL)isShow;


@end
