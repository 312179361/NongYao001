//
//  PestsTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PestsTableViewCell.h"
#import "CALayer+LayerColor.h"
@implementation PestsTableViewCell
- (void)updateLeftCellWithTitle:(NSString *)titleStr withIsSelectItem:(BOOL)isSelect {
    self.leftCellLabel.text = titleStr;
    
    if (isSelect == YES) {
        //选中样式
        self.leftCellLabel.textColor = kMainColor;
        self.leftCellLabel.layer.borderColorFromUIColor = kMainColor;
        
    }else {
        //非选中样式
        self.leftCellLabel.textColor = k333333Color;
        self.leftCellLabel.layer.borderColorFromUIColor = [UIColor whiteColor];
        
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
