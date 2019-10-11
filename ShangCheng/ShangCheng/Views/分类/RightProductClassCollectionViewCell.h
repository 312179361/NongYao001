//
//  RightProductClassCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightProductClassCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightCellLabel;

- (void)updateRightCellWithTitle:(NSString *)titleStr;
@end
