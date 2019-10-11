//
//  MyCommentListModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentListModel : NSObject
//产品基本信息
//@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *productImageUrl;
@property (nonatomic,strong)NSString *productTitleStr;
@property (nonatomic,strong)NSString *productFormatStr;
@property (nonatomic,strong)NSString *productCompanyStr;
@property (nonatomic,strong)NSString *productPrice;
//评论详情
@property (nonatomic,strong)NSString *detailCommentStr;
//时间
@property (nonatomic,strong)NSString *commentTimeStr;
//星级
@property (nonatomic,assign)NSInteger starCount;
//回复内容
@property (nonatomic,strong)NSString *r_content_reply;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
