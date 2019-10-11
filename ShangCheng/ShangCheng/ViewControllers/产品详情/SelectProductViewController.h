//
//  SelectProductViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

typedef void(^RefreshFormatBlock)();

@interface SelectProductViewController : UIViewController
@property (nonatomic,strong)UIImage *backImage;
@property (nonatomic,strong)ProductDetailModel *productDetailModel;
@property (nonatomic,copy)RefreshFormatBlock refreshFormatBlock;
@end
