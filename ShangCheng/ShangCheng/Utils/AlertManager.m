//
//  AlertManager.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/17.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager
+ (AlertManager *)shareIntance {
    static AlertManager *alertManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertManager = [[AlertManager alloc]init];
    });
    return alertManager;
}


- (void)showAlertViewWithTitle:(NSString *)alertTitle withMessage:(NSString *)message actionTitleArr:(NSArray *)actionTitleArr withViewController:(UIViewController *)viewController withReturnCodeBlock:(ActionBlockNumber)actionBlockNumber {

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (actionTitleArr.count > 0) {
        for (int i = 0 ; i < actionTitleArr.count; i++) {
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:actionTitleArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (actionBlockNumber != nil) {
                    actionBlockNumber(i);
                }
            }];
            [alertC addAction:action1];
        }
        
        
        [viewController presentViewController:alertC animated:YES completion:nil];

    }else {
        [viewController presentViewController:alertC animated:YES completion:^{
            if (actionBlockNumber!= nil) {
                actionBlockNumber(0);

            }

            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
}

@end
