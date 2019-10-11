//
//  SaleProductListViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleProductListViewController : UIViewController
@property(nonatomic,strong)NSString *showType;//more更多 search搜索

//search为关键字。more是分类即 4 杀虫剂  7杀螨剂  5杀菌剂  6除草剂  9调节剂  8叶面肥  13其他
@property(nonatomic,strong)NSString *tempKeyword;

@end
