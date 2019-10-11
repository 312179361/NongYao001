//
//  ShoppingCarMainCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ShoppingCarMainCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation ShoppingCarMainCollectionViewCell
- (void)updateCellWithCellIndex:(NSIndexPath *)cellIndex {
    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];
    //是否被选择状态
    if (tempShoppingCarModel.isSelectedShoppingCar == YES) {
        [self.selectButton setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
    }else {
        [self.selectButton setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
    }
    
    [self.headerImageView setWebImageURLWithImageUrlStr:tempShoppingCarModel.shoppingCarProduct.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.titleLabel.text = tempShoppingCarModel.shoppingCarProduct.productTitle;
    
    self.companyLabel.text = tempShoppingCarModel.shoppingCarProduct.productCompany;
    self.formatLabel.text = tempShoppingCarModel.shoppingCarProduct.productFormatStr;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@", tempShoppingCarModel.shoppingCarProduct.productPrice];
    
    self.countLabel.text = [NSString stringWithFormat:@"%@", tempShoppingCarModel.c_number];
    
    
    if (tempShoppingCarModel.isActivity == YES) {
        self.activityImageView.hidden = NO;
    }else {
        self.activityImageView.hidden = YES;
    }
}

//增加商品个数
- (IBAction)addCountAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UICollectionView *)self.superview) indexPathForCell:self];
    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];
    
    //增加数量
    Manager *manager = [Manager shareInstance];
    
    if ([manager isLoggedInStatus] == YES) {
        //如果登录了，那就利用接口增加
        [manager addOrLessShoppingCarProductCountWithShoppingModel:tempShoppingCarModel withIsAddOrLess:YES withAddOrLessSuccessResult:^(id successResult) {
            //刷新数量
            self.countLabel.text = tempShoppingCarModel.c_number;
            //返回控制器计算总价格
            self.totalPriceBlock();
            
        } withaddOrLessFailResult:^(NSString *failResultStr) {
            NSLog(@"%@",failResultStr);
        }];

    }else {
        //如果没有登录，那就直接增加减少本地购物车数据
        [manager addOrLessLocationShoppingCarCountWithShoppingCarModel:tempShoppingCarModel withisAdd:YES WithAddOrLessSuccessFail:^(id successResult) {
            //刷新数量
            self.countLabel.text = tempShoppingCarModel.c_number;
            //返回控制器计算总价格
            self.totalPriceBlock();
            
        } withAddOrLessFailResult:^(NSString *failResultStr) {
            NSLog(@"%@",failResultStr);

        }];
    }
    
    
}
//减少商品个数
- (IBAction)lessCountAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UICollectionView *)self.superview) indexPathForCell:self];
    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];
    Manager *manager = [Manager shareInstance];

    if ([manager isLoggedInStatus] == YES) {
        //如果是登录状态，通过接口进行减少产品
        //如果数量大于起订数量可以进行减少
        if (tempShoppingCarModel.c_number > tempShoppingCarModel.s_min_quantity) {
            //减少数量
            [manager addOrLessShoppingCarProductCountWithShoppingModel:tempShoppingCarModel withIsAddOrLess:NO withAddOrLessSuccessResult:^(id successResult) {
                //刷新数量
                self.countLabel.text = tempShoppingCarModel.c_number;
                //返回控制器计算总价格
                self.totalPriceBlock();
                
            } withaddOrLessFailResult:^(NSString *failResultStr) {
                NSLog(@"%@",failResultStr);
            }];
            
        }else {
            AlertManager *alertM = [AlertManager shareIntance];
            
            [alertM showAlertViewWithTitle:nil withMessage:@"不得小与起订数量" actionTitleArr:nil withViewController:[UIApplication sharedApplication].keyWindow.rootViewController withReturnCodeBlock:nil];
            
        }

    }else {
        //没有登录就本地减少数量
        if (tempShoppingCarModel.c_number > tempShoppingCarModel.s_min_quantity) {
            //如果没有登录，那就直接减少本地购物车数据
            [manager addOrLessLocationShoppingCarCountWithShoppingCarModel:tempShoppingCarModel withisAdd:NO WithAddOrLessSuccessFail:^(id successResult) {
                //刷新数量
                self.countLabel.text = tempShoppingCarModel.c_number;
                //返回控制器计算总价格
                self.totalPriceBlock();
                
            } withAddOrLessFailResult:^(NSString *failResultStr) {
                NSLog(@"%@",failResultStr);
                
            }];

            
        }else {
            AlertManager *alertM = [AlertManager shareIntance];
            
            [alertM showAlertViewWithTitle:nil withMessage:@"不得小与起订数量" actionTitleArr:nil withViewController:[UIApplication sharedApplication].keyWindow.rootViewController withReturnCodeBlock:nil];
            
        }
    }
}

//删除按钮
- (IBAction)deleteButtonAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UICollectionView *)self.superview) indexPathForCell:self];
    //    NSLog(@"%ld---%ld",cellIndex.section,cellIndex.row);
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        [manager deleteShoppingCarWithProductIndexSet:[NSMutableIndexSet indexSetWithIndex:cellIndex.section] WithSuccessResult:^(id successResult) {
            
            //删除成功，block返回到控制器刷新
            self.deleteSuccessBlock(cellIndex);
        } withFailResult:^(NSString *failResultStr) {
            //删除失败
            NSLog(@"删除失败");
        }];
        
    }else {
        //本地删除
        BOOL saveResult =  [manager deleteLocationShoppingCarWithProductIndexSet:[NSMutableIndexSet indexSetWithIndex:cellIndex.section]];
        if (saveResult == YES) {
            self.deleteSuccessBlock(cellIndex);

        }else {
            NSLog(@"删除失败");
        }
        
    }
    
    
    
    
}
//选择某个产品
- (IBAction)selectButtonAction:(UIButton *)sender {
    //得到这个cell的index
    NSIndexPath *cellIndex = [((UICollectionView *)self.superview) indexPathForCell:self];
    //得到模型
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:cellIndex.section];
    //改变状态
    tempShoppingCarModel.isSelectedShoppingCar = !tempShoppingCarModel.isSelectedShoppingCar;
    if (tempShoppingCarModel.isSelectedShoppingCar == YES) {
        //如果选择了
        [self.selectButton setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
        
    }else {
        [self.selectButton setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        
    }
    
    [[Manager shareInstance] isAllSelectForShoppingCarAction];
    
    //block,主要用户刷新全选UI
    self.totalPriceBlock();
    
}

@end
