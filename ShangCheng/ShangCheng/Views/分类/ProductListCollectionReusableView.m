//
//  ProductListCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductListCollectionReusableView.h"

@implementation ProductListCollectionReusableView

- (void)updateProductListCollectionHeaderViewWithSortType:(SortType )sortType {
    //所有显示归位
    [self.buttonOne setImage:[UIImage imageNamed:@"s_btn_nor"] forState:UIControlStateNormal];
    [self.buttonTwo setImage:[UIImage imageNamed:@"s_btn_nor"] forState:UIControlStateNormal];
    [self.buttonThree setImage:[UIImage imageNamed:@"s_btn_nor"] forState:UIControlStateNormal];
    [self.buttonFour setImage:[UIImage imageNamed:@"s_btn_nor"] forState:UIControlStateNormal];

    switch (sortType) {
        case HitsDown:
            [self.buttonOne setImage:[UIImage imageNamed:@"s_btn_downl"] forState:UIControlStateNormal];
            break;
        case HitsUp:
            [self.buttonOne setImage:[UIImage imageNamed:@"s_btn_up"] forState:UIControlStateNormal];
            break;
        case SalesDown:
            [self.buttonTwo setImage:[UIImage imageNamed:@"s_btn_downl"] forState:UIControlStateNormal];
            break;
        case SalesUp:
            [self.buttonTwo setImage:[UIImage imageNamed:@"s_btn_up"] forState:UIControlStateNormal];
            break;
        case PriceUp:
            [self.buttonThree setImage:[UIImage imageNamed:@"s_btn_up"] forState:UIControlStateNormal];
            break;
        case PriceDown:
            [self.buttonThree setImage:[UIImage imageNamed:@"s_btn_downl"] forState:UIControlStateNormal];
            break;
        case DateDown:
            [self.buttonFour setImage:[UIImage imageNamed:@"s_btn_downl"] forState:UIControlStateNormal];
            break;
        case DateUp:
            [self.buttonFour setImage:[UIImage imageNamed:@"s_btn_up"] forState:UIControlStateNormal];
            break;
        case DefaultType:
            
            break;
        default:
            break;
    }
    
    
    
}

@end
