//
//  ProductListViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举判断是搜索或者分类
typedef NS_ENUM(NSInteger , ProductSearchOrType) {
    SearchProduct,
    TypeProduct,
};

@interface ProductListViewController : UIViewController
@property (nonatomic,assign)ProductSearchOrType productSearchOrType;
@property (nonatomic,strong)NSString *tempKeyword;
@property (nonatomic,strong)NSString *tempCode;


@end
