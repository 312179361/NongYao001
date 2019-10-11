//
//  CategoryModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CategoryModel : NSObject
//八大分类的图片
@property (nonatomic,strong)UIImage *categoryImage;
//八大分类的标题
@property (nonatomic,strong)NSString *categoryTitleStr;

@end
