//
//  MineHeaderCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"

@interface MineHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *headerCellLabel;
@property (weak, nonatomic) IBOutlet IndexButton *headerCellButton;


- (void)updateHeaderCellWithTitleStr:(NSString *)titleStr withButtonTitle:(NSString *)buttonTitle;

@end
