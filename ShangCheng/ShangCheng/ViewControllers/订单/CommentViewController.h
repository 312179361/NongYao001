//
//  CommentViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonOrderModel.h"

typedef void(^RefreshCommentAfterBlock)();
@interface CommentViewController : UIViewController

@property (nonatomic,strong)SonOrderModel *tempSonOrderModel;
@property (nonatomic,copy)RefreshCommentAfterBlock RefreshCommentAfterBlock;
@end
