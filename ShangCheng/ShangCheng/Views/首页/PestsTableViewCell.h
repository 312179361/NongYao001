//
//  PestsTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PestsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftCellLabel;

- (void)updateLeftCellWithTitle:(NSString *)titleStr withIsSelectItem:(BOOL)isSelect ;

@end
