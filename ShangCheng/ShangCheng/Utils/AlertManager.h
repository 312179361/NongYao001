//
//  AlertManager.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/17.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^ActionBlockNumber)(NSInteger actionBlockNumber);

@interface AlertManager : NSObject
+ (AlertManager *)shareIntance;


- (void)showAlertViewWithTitle:(NSString *)alertTitle withMessage:(NSString *)message actionTitleArr:(NSArray *)actionTitleArr withViewController:(UIViewController *)viewController withReturnCodeBlock:(ActionBlockNumber)actionBlockNumber ;

@end
