//
//  ProductDetailViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductDetailViewController : UIViewController
@property (nonatomic,strong)NSString *productID;
@property (nonatomic,strong)NSString *type;//pid产品id 和 sid规格id
@property (nonatomic,assign)BOOL isPopRootVC;
@end
