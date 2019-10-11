//
//  ShoppingCarTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/19.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ShoppingCarTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation ShoppingCarTableViewCell

- (void)updateCellWithCellIndex:(NSIndexPath *)cellIndex {

    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];
    //是否被选择状态
    if (tempShoppingCarModel.isSelectedShoppingCar == YES) {
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
    }else {
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
    }
    
    [self.headerImageView setWebImageURLWithImageUrlStr:tempShoppingCarModel.shoppingCarProduct.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.titleLabel.text = tempShoppingCarModel.shoppingCarProduct.productTitle;
    
    self.companyLabel.text = tempShoppingCarModel.shoppingCarProduct.productCompany;
    self.formatLabel.text = tempShoppingCarModel.shoppingCarProduct.productFormatStr;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@", tempShoppingCarModel.shoppingCarProduct.productPrice];
    
    self.countLabel.text = [NSString stringWithFormat:@"%@", tempShoppingCarModel.c_number];
    
}

//增加商品个数
- (IBAction)addCountAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UITableView *)self.superview.superview) indexPathForCell:self];
    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];
    
    //增加数量
    Manager *manager = [Manager shareInstance];
    [manager addOrLessShoppingCarProductCountWithShoppingModel:tempShoppingCarModel withIsAddOrLess:YES withAddOrLessSuccessResult:^(id successResult) {
        //刷新数量
        self.countLabel.text = tempShoppingCarModel.c_number;
        //返回控制器计算总价格
        self.totalPriceBlock();

    } withaddOrLessFailResult:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
    }];
    
    
}
//减少商品个数
- (IBAction)lessCountAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UITableView *)self.superview.superview) indexPathForCell:self];
    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];

    
    //减少数量
    Manager *manager = [Manager shareInstance];
    [manager addOrLessShoppingCarProductCountWithShoppingModel:tempShoppingCarModel withIsAddOrLess:NO withAddOrLessSuccessResult:^(id successResult) {
        //刷新数量
        self.countLabel.text = tempShoppingCarModel.c_number;
        //返回控制器计算总价格
        self.totalPriceBlock();

    } withaddOrLessFailResult:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
    }];
    
  
}

//删除按钮
- (IBAction)deleteButtonAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UITableView *)self.superview.superview) indexPathForCell:self];
//    NSLog(@"%ld---%ld",cellIndex.section,cellIndex.row);
    [[Manager shareInstance] deleteShoppingCarWithProductIndexSet:[NSMutableIndexSet indexSetWithIndex:cellIndex.section] WithSuccessResult:^(id successResult) {
        
        //删除成功，block返回到控制器刷新
        self.deleteSuccessBlock(cellIndex);
    } withFailResult:^(NSString *failResultStr) {
        //删除失败
        NSLog(@"删除失败");
    }];
    
}
//选择某个产品
- (IBAction)selectButtonAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UITableView *)self.superview.superview) indexPathForCell:self];
    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];
    //改变状态
    tempShoppingCarModel.isSelectedShoppingCar = !tempShoppingCarModel.isSelectedShoppingCar;
    if (tempShoppingCarModel.isSelectedShoppingCar == YES) {
        //如果选择了
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
        
    }else {
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        
    }
    
    [[Manager shareInstance] isAllSelectForShoppingCarAction];
    
    //block,主要用户刷新全选UI
    self.totalPriceBlock();
    
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
