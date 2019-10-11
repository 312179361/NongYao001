//
//  SearchViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举判断是产品还是病虫害
typedef NS_ENUM(NSInteger , ProductOrPests) {
    Product,
    Pests
};

@interface SearchViewController : UIViewController
@property (nonatomic,assign)ProductOrPests productOrPests;
@end
