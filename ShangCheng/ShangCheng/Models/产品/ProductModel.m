//
//  ProductModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/10.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    //首页
    if ([key isEqualToString:@"p_id"]) {
        self.productID = value;
    }
    if ([key isEqualToString:@"p_icon"]) {
        self.productImageUrlstr = value;
    }
    if ([key isEqualToString:@"p_name"]) {
        self.productTitle = value;
    }
    if ([key isEqualToString:@"f_name"]) {
        self.productCompany = value;
    }
    if ([key isEqualToString:@"p_standard"]) {
        self.productFormatStr = value;
    }
    if ([key isEqualToString:@"p_price"]) {
        self.productPrice = value;
    }
    if ([key isEqualToString:@"p_activity_show_id"]) {
        if ([value isEqualToString:@"0"]) {
            self.isSaleProduct = NO;
        }else {
            self.isSaleProduct = YES;
        }
    }
    if ([key isEqualToString:@"salesvol"]) {
        self.productVolume = value;
    }

    //---------------------------------------------------
    //产品详情
    if ([key isEqualToString:@"p_id"]) {
        self.productID = value;
    }
    
    if ([key isEqualToString:@"p_title"]) {
        self.productTitle = value;
    }
    if ([key isEqualToString:@"suppliername"]) {
        self.productCompany = value;
    }
    
    if ([key isEqualToString:@"p_icon"] ) {
        self.productImageUrlstr = value;
    }
    if ([key isEqualToString:@"p_s_id"] ) {
        self.productFormatID = value;
    }
    if ([key isEqualToString:@"p_standard"] ) {
        self.productFormatStr = value;
    }
    if ([key isEqualToString:@"p_price"] ) {
        self.productPrice = value;
    }
//    if ([key isEqualToString:@"p_pid"]) {
//        self.productCode = value;
//    }
    
    
    //-----------------------------------------------
    //购物车
    if ([key isEqualToString:@"c_p_id"]) {
        self.productID = value;
    }
    if ([key isEqualToString:@"c_title"]) {
        self.productTitle = value;
    }
    if ([key isEqualToString:@"c_manufacturer"]) {
        self.productCompany = value;
    }
    if ([key isEqualToString:@"c_s_id"]) {
        self.productFormatID = value;
    }
    if ([key isEqualToString:@"p_st"]) {
        self.productFormatStr = value;
    }
    if ([key isEqualToString:@"unitprice"]) {
        self.productPrice = value;
    }
    if ([key isEqualToString:@"p_icon"]) {
        self.productImageUrlstr = value;
    }
//    if ([key isEqualToString:@"p_code"]) {
//        self.productCode = value;
//    }
    
    //----------------------------------------------
  
}


//更改默认规格
- (void)setFormatInfoWithSImg:(NSString *)sImg withSId:(NSString *)sId withSStr:(NSString *)sStr withSFrice:(NSString *)sPrice {
    
    self.productImageUrlstr = sImg;
    
    self.productFormatID = sId;
    
    self.productFormatStr = sStr;
    
    self.productPrice = sPrice;
}


#pragma mark - NSCoding Methods -
//通过编码对象aCoder对Person类中的各个属性对应的实例对象或变量做编码操作。将类的成员变量通过一个键值编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.productID forKey:@"p_id"];
    [aCoder encodeObject:self.productImageUrlstr forKey:@"p_icon"];
    [aCoder encodeObject:self.productTitle forKey:@"p_title"];
    [aCoder encodeObject:self.productCompany forKey:@"p_company"];
    [aCoder encodeObject:self.productFormatID forKey:@"p_formatId"];
    [aCoder encodeObject:self.productFormatStr forKey:@"p_formatStr"];
    [aCoder encodeObject:self.productPrice forKey:@"p_price"];
}

//解码操作。将键值读出
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        //        self.u_login_id = [aDecoder decodeObjectForKey:@"u_login_id"];
        self.productID = [aDecoder decodeObjectForKey:@"p_id"];
        self.productImageUrlstr = [aDecoder decodeObjectForKey:@"p_icon"];
        self.productTitle = [aDecoder decodeObjectForKey:@"p_title"];
        self.productCompany = [aDecoder decodeObjectForKey:@"p_company"];
        self.productFormatID = [aDecoder decodeObjectForKey:@"p_formatId"];
        self.productFormatStr = [aDecoder decodeObjectForKey:@"p_formatStr"];
        self.productPrice = [aDecoder decodeObjectForKey:@"p_price"];

    }
    return self;
}




@end
