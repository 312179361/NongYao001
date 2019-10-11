//
//  MyFavoriteListViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , IsFavoriteOrBrowse) {
    IsFavorite,
    IsBrowse
};

@interface MyFavoriteListViewController : UIViewController

@property (nonatomic,assign)IsFavoriteOrBrowse isFavoriteOrBrowse;

@end
