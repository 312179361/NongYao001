//
//  PestsCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PestsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightCellLabel;

- (void)updateRightCellWithTitle:(NSString *)titleStr;

@end
