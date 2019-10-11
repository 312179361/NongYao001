//
//  ProductModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/10.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject<NSCoding>
//农药id
@property (nonatomic,strong)NSString *productID;
//农药的图片链接
@property (nonatomic,strong)NSString *productImageUrlstr;
//农药的名字
@property (nonatomic,strong)NSString *productTitle;
//农药的生产公司
@property (nonatomic,strong)NSString *productCompany;
//农药的规格id
@property (nonatomic,strong)NSString *productFormatID;

//@property (nonatomic,strong)NSString *productCode;//scode

//农药的规格
@property (nonatomic,strong)NSString *productFormatStr;
//农药的价格
@property (nonatomic,strong)NSString *productPrice;
//是否是活动产品
@property (nonatomic,assign)BOOL isSaleProduct;

//单瓶子价格
@property (nonatomic,strong)NSString *s_price_per;
//单位，是瓶还是袋
@property (nonatomic,strong)NSString *s_unit_child;

//销量
@property(nonatomic,strong)NSString *productVolume;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;

//更改默认规格
- (void)setFormatInfoWithSImg:(NSString *)sImg withSId:(NSString *)sId withSStr:(NSString *)sStr withSFrice:(NSString *)sPrice ;

@end
