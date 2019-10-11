//
//  OrderListHeadTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/5/24.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "OrderListHeadTableViewCell.h"

@implementation OrderListHeadTableViewCell
- (void)updateOrderListHeadCellWithModel:(SupOrderModel *)model withWhichTableView:(NSString *)whichTableView withCellIndex:(NSIndexPath *)cellIndex {
    self.selectOrderButton.indexForButton = cellIndex;
    //看看是那个TableView，只有第二个TableView，且状态为0 才会有选中button。否则就没有选中button
    if ([whichTableView isEqualToString:@"2"]) {
        if ([model.p_status isEqualToString:@"0"] ) {
            self.selectButtonWidthLayout.constant = 25;
        }else {
            self.selectButtonWidthLayout.constant = 0;
        }
    }else {
        self.selectButtonWidthLayout.constant = 0;
    }
    
    
    //这个产品是否被选
    if (model.isSelectOrder == YES) {
        
        [self.selectOrderButton setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
        
    }else {
        
        [self.selectOrderButton setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        
    }
    self.orderNumberLabel.text = model.p_code;
    
    self.orderStateLabel.text = model.statusvalue;
    
    
}

- (IBAction)selectButtonAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    self.selectButtonBlock(sender);
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
