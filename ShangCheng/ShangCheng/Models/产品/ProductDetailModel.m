//
//  ProductDetailModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductDetailModel.h"
#import "ProductFormatModel.h"
@implementation ProductDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"item"]) {
        self.productFarmatArr = [NSMutableArray array];
        for (NSDictionary *itemDic in value) {
            //当s_valid等于0 才是正常的产品
            if ([[itemDic objectForKey:@"s_valid"] isEqualToString:@"0"]) {
                ProductFormatModel *formatModel = [[ProductFormatModel alloc] init];
                [formatModel setValuesForKeysWithDictionary:itemDic];
                formatModel.seletctCount = [formatModel.s_min_quantity integerValue];
                
                [self.productFarmatArr addObject:formatModel];
            }
            
        }
    }
    
    
    //将使用说明封装成数组
    if ([key isEqualToString:@"p_scope_crop"]) {
        self.p_scope_crop_Arr = [value componentsSeparatedByString:@","];
    }
    
    if ([key isEqualToString:@"p_treatment"]) {
        self.p_treatment_str = value;
        self.p_treatment_Arr = [value componentsSeparatedByString:@","];
    }
    
    if ([key isEqualToString:@"p_dosage"]) {
        self.p_dosage_Arr = [value componentsSeparatedByString:@","];
    }
    
    if ([key isEqualToString:@"p_method"]) {
        self.p_method_Arr = [value componentsSeparatedByString:@","];
    }
    
    
    if ([key isEqualToString:@"p_registration"] && [value length]>0) {
        //PD证
        [self.p_cerArr addObject:@{@"PD证":value}];
    }
    if ([key isEqualToString:@"p_certificate"] && [value length]>0) {
        //产品标准证
        [self.p_cerArr addObject:@{@"产品标准证":value}];
    }
    if ([key isEqualToString:@"p_license"] && [value length]>0) {
        //生产许可证
        [self.p_cerArr addObject:@{@"生产许可证":value}];
    }
    
}

- (NSMutableArray *)p_cerArr {
    if (_p_cerArr == nil) {
        self.p_cerArr = [NSMutableArray array];
    }
    return _p_cerArr;
}


#pragma mark - NSCoding Methods -
//通过编码对象aCoder对Person类中的各个属性对应的实例对象或变量做编码操作。将类的成员变量通过一个键值编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.productModel forKey:@"productModel"];
    [aCoder encodeObject:self.p_typevalue1 forKey:@"p_typevalue1"];
    [aCoder encodeObject:self.p_pid forKey:@"p_pid"];
    [aCoder encodeObject:self.p_ingredient forKey:@"p_ingredient"];
    [aCoder encodeObject:self.p_standard_qty forKey:@"p_standard_qty"];
    [aCoder encodeObject:self.p_time_create forKey:@"p_time_create"];
    [aCoder encodeObject:self.p_treatment_str forKey:@"p_treatment_str"];
    [aCoder encodeObject:self.p_status forKey:@"p_status"];
    [aCoder encodeObject:self.statusvalue forKey:@"statusvalue"];
    [aCoder encodeObject:self.p_introduce forKey:@"p_introduce"];


}

//解码操作。将键值读出
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {

        self.productModel = [aDecoder decodeObjectForKey:@"productModel"];
        self.p_typevalue1 = [aDecoder decodeObjectForKey:@"p_typevalue1"];
        self.p_pid = [aDecoder decodeObjectForKey:@"p_pid"];
        self.p_ingredient = [aDecoder decodeObjectForKey:@"p_ingredient"];
        self.p_standard_qty = [aDecoder decodeObjectForKey:@"p_standard_qty"];
        self.p_time_create = [aDecoder decodeObjectForKey:@"p_time_create"];
        self.p_treatment_str = [aDecoder decodeObjectForKey:@"p_treatment_str"];
        self.p_status = [aDecoder decodeObjectForKey:@"p_status"];
        self.statusvalue = [aDecoder decodeObjectForKey:@"statusvalue"];
        self.p_introduce = [aDecoder decodeObjectForKey:@"p_introduce"];
        
    }
    return self;
}

@end
