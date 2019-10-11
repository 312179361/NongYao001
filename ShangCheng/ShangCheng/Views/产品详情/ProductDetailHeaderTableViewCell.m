//
//  ProductDetailHeaderTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductDetailHeaderTableViewCell.h"

@implementation ProductDetailHeaderTableViewCell
- (void)updateButtonUIWithType:(SelectType)selectType withCommentCount:(NSInteger)commentCount withTradeCount:(NSInteger)tradeCount {

    [self.buttonOne setTitleColor:k333333Color forState:UIControlStateNormal];
    [self.buttonOne setLineColor:[UIColor whiteColor]];
    [self.buttonTwo setTitleColor:k333333Color forState:UIControlStateNormal];
    [self.buttonTwo setLineColor:[UIColor whiteColor]];
    [self.buttonThree setTitleColor:k333333Color forState:UIControlStateNormal];
    [self.buttonThree setLineColor:[UIColor whiteColor]];
    [self.buttonFour setTitleColor:k333333Color forState:UIControlStateNormal];
    [self.buttonFour setLineColor:[UIColor whiteColor]];

    if (commentCount > 0) {
        self.buttonThree.titleLabel.text = [NSString stringWithFormat:@"用户评价(%ld)",commentCount];
        [self.buttonThree setTitle:[NSString stringWithFormat:@"用户评价(%ld)",commentCount] forState:UIControlStateNormal];
    }
    if (tradeCount > 0) {
        self.buttonFour.titleLabel.text = [NSString stringWithFormat:@"交易记录(%ld)",tradeCount];
        [self.buttonFour setTitle:[NSString stringWithFormat:@"交易记录(%ld)",tradeCount] forState:UIControlStateNormal];

    }
    
    
    
    switch (selectType) {
        case SelectTypeProductDetail:
            [self.buttonOne setTitleColor:kMainColor forState:UIControlStateNormal];
            [self.buttonOne setLineColor:kMainColor];
            break;
        case SelectTypeUseInfo:
            [self.buttonTwo setTitleColor:kMainColor forState:UIControlStateNormal];
            [self.buttonTwo setLineColor:kMainColor];
            break;
        case SelectTypeUserComment:
            [self.buttonThree setTitleColor:kMainColor forState:UIControlStateNormal];
            [self.buttonThree setLineColor:kMainColor];
            break;
        case SelectTypeTradeList:
            [self.buttonFour setTitleColor:kMainColor forState:UIControlStateNormal];
            [self.buttonFour setLineColor:kMainColor];
            break;
            
        default:
            break;
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
