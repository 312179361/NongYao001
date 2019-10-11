//
//  WebPageViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController
@property (nonatomic,strong)NSString *webUrl;
@property (nonatomic,strong)NSString *tempTitleStr;

@property (nonatomic,assign)BOOL isUTF8Code;
@end
