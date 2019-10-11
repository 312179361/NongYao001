//
//  ProductFormatModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductFormatModel : NSObject
//规格id
@property (nonatomic,strong)NSString *s_id;
@property (nonatomic,strong)NSString *s_code;
//规格字符串
@property (nonatomic,strong)NSString *productst;
//价格
@property (nonatomic,strong)NSString *s_price;
//最小起订数量
@property (nonatomic,strong)NSString *s_min_quantity;
//单瓶子价格
@property (nonatomic,strong)NSString *s_price_per;
//单位，是瓶还是袋
@property (nonatomic,strong)NSString *s_unit_child;
//图片
@property (nonatomic,strong)NSMutableArray *imageArr;
//是否被选择
@property (nonatomic,assign)BOOL isSelect;
//实际选择的数量
@property (nonatomic,assign)NSInteger seletctCount;
@property (nonatomic,assign)BOOL isActivity;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
