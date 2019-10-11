//
//  KongImageView.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
//枚举判断是添加还是删除
typedef NS_ENUM(NSInteger , KongType) {
    KongTypeWithKongData,
    KongTypeWithNetError,
    KongTypeWithSearchKong,
    KongTypeWithKongFavorite,
    KongTypeWithNotLogin
};
@interface KongImageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *showMsgLabel;
@property (weak, nonatomic) IBOutlet  IndexButton *reloadAgainButton;
//显示
- (void)showKongViewWithKongMsg:(NSString *)msg withKongType:(KongType)kongType ;
//隐藏
- (void)hiddenKongView;

@end
