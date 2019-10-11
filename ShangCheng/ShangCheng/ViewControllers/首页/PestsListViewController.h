//
//  PestsListViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举判断是搜索或者分类
typedef NS_ENUM(NSInteger , PestsIsSearchOrType) {
    SearchPests,
    TypePests
};
@interface PestsListViewController : UIViewController

@property (nonatomic,assign)PestsIsSearchOrType pestsIsSearchOrType;
@property (nonatomic,strong)NSString *tempKeyword;
@property (nonatomic,strong)NSString *tempCode;
@property (nonatomic,strong)NSString *showTitleStr;
@end
