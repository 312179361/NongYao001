//
//  MyAgentCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/12/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAgentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconDetailLabel;

- (void)updateMyAgentCollectionCellWithDataDic:(NSMutableDictionary *)dataDic;

@end
