//
//  DownLineTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/18.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCarNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectMarkImageView;

- (void)updateBankUIWithBankDic:(NSMutableDictionary *)bankDic;

@end
