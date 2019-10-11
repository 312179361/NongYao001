//
//  MineCollectionViewCellOne.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCollectionViewCellOne : UICollectionViewCell
//用户头像
@property (weak, nonatomic) IBOutlet UIButton *userHeadButton;

//我的用户名
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
//地区和手机号
@property (weak, nonatomic) IBOutlet UILabel *myAreaAndPhoneLabel;
//账号类型
@property (weak, nonatomic) IBOutlet UIImageView *myTypeImageView;
//账号管理按钮
@property (weak, nonatomic) IBOutlet UIButton *memberManagerButton;

- (void)updateMineCollectionViewCellOne;

@end
