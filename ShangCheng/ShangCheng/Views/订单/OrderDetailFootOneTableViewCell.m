//
//  OrderDetailFootOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderDetailFootOneTableViewCell.h"

@implementation OrderDetailFootOneTableViewCell
- (void)updateOrderDetailFootOneCell:(SonOrderModel *)tempSonOrderModel {
    //总价
    self.orderTotalPriceLabel.text = [NSString stringWithFormat:@"￥%@",tempSonOrderModel.o_price_total];
    /*待收货和已完成 有两个按钮
     待收货，1物流2确认收货
     已完成，1立即评价2再次购买（有特例，就只有再次购买，特例就是isreply）
     isreply 0 不允许评价的订单 1 允许评价还未评价的订单 2 已经评价的订单
     
     其余的都是一个按钮
     */
    
    NSMutableArray *buttonTitleArr = [NSMutableArray array];
    //待支付和带确认  是一个取消按钮
    if ([tempSonOrderModel.o_status isEqualToString:@"0"] || [tempSonOrderModel.o_status isEqualToString:@"1B"]) {
        
        [buttonTitleArr addObject:@"取消订单"];
    }
    if ([tempSonOrderModel.o_status isEqualToString:@"5A"] || [tempSonOrderModel.o_status isEqualToString:@"5B"]) {
        [buttonTitleArr addObject:@"物流信息"];
    }
    
    //待收货 是两个按钮 物流和确认收货
    if ([tempSonOrderModel.o_status isEqualToString:@"5"]) {
        
        [buttonTitleArr addObject:@"物流信息"];
        [buttonTitleArr addObject:@"确认收货"];

    }
    //已完成并且isreply等于1是两个按钮 立即评价和详情。isreply为其他的就是只有详情
    if ([tempSonOrderModel.o_status isEqualToString:@"9"]) {
        if ([tempSonOrderModel.isreply isEqualToString:@"1"]) {
            [buttonTitleArr addObject:@"再次购买"];
            [buttonTitleArr addObject:@"立即评价"];

        }else{
            [buttonTitleArr addObject:@"再次购买"];
        }
    }
    
    //待发货 就是一个按钮，详情（物流）
    if ([tempSonOrderModel.o_status isEqualToString:@"1"] || [tempSonOrderModel.o_status isEqualToString:@"2"] || [tempSonOrderModel.o_status isEqualToString:@"3A"] ||[tempSonOrderModel.o_status isEqualToString:@"3B"] ||[tempSonOrderModel.o_status isEqualToString:@"3"] ||[tempSonOrderModel.o_status isEqualToString:@"4A"] ||[tempSonOrderModel.o_status isEqualToString:@"4"]) {
        
        [buttonTitleArr addObject:@"订单详情"];
    }

    //加载按钮个数
    [self updateFoorButtonWithButtonTitleArr:buttonTitleArr];
    
}

- (void)updateFoorButtonWithButtonTitleArr:(NSMutableArray *)buttonTitleArr {
    
    self.buttonOne.hidden = YES;
    self.buttonTwo.hidden = YES;
    switch (buttonTitleArr.count) {
        case 1:
            self.buttonOne.hidden = NO;
            self.buttonTwo.hidden = YES;
            [self.buttonOne setTitle:buttonTitleArr[0] forState:UIControlStateNormal];
            break;
        case 2:
            self.buttonOne.hidden = NO;
            self.buttonTwo.hidden = NO;
            [self.buttonOne setTitle:buttonTitleArr[0] forState:UIControlStateNormal];
            [self.buttonTwo setTitle:buttonTitleArr[1] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

/*
- (IBAction)oneButtonAction:(IndexButton *)sender {
    
    //待支付 带确认 都是取消订单
    if ([self.tempSonOrder.o_status isEqualToString:@"0"] || [self.tempSonOrder.o_status isEqualToString:@"1A"] || [self.tempSonOrder.o_status isEqualToString:@"1B"]) {
        //
        self.buttonActionTypeBlock(sender,1);
        
    }else if ([self.tempSonOrder.o_status isEqualToString:@"5A"] || [self.tempSonOrder.o_status isEqualToString:@"5"]) {
        //待收货 是物流
        self.buttonActionTypeBlock(sender,2);
        
    }else if ([self.tempSonOrder.o_status isEqualToString:@"9"]) {
        //已完成  再次购买
        self.buttonActionTypeBlock(sender,5);
    }else {
        //待发货 详情（物流）
        self.buttonActionTypeBlock(sender,2);
        
    }
    
}

- (IBAction)twoButtonAction:(IndexButton *)sender {

    //待收货 确认收货
    if ([self.tempSonOrder.o_status isEqualToString:@"5A"] || [self.tempSonOrder.o_status isEqualToString:@"5"]) {
        self.buttonActionTypeBlock(sender,3);//确认收货
    }
    
    //已完成 立即评价
    if ([self.tempSonOrder.o_status isEqualToString:@"9"]) {
        self.buttonActionTypeBlock(sender,4);
    }
    
}

*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
