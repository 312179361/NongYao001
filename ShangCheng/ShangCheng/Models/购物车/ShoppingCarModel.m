//
//  ShoppingCarModel.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/21.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"c_activity_id"]) {
        if ([value isEqualToString:@"0"]) {
            self.isActivity = NO;
        }else {
            self.isActivity = YES;
        }
    }
}


#pragma mark - NSCoding Methods -
//通过编码对象aCoder对Person类中的各个属性对应的实例对象或变量做编码操作。将类的成员变量通过一个键值编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.c_id forKey:@"c_id"];
    [aCoder encodeObject:self.shoppingCarProduct forKey:@"shoppingCarProduct"];
    [aCoder encodeObject:self.c_number forKey:@"c_number"];
    [aCoder encodeObject:self.c_type forKey:@"c_type"];
    [aCoder encodeObject:self.totalprice forKey:@"totalprice"];
//    [aCoder encodeObject:self.isSelectedShoppingCar forKey:@"isSelectedShoppingCar"];
    [aCoder encodeObject:self.s_min_quantity forKey:@"s_min_quantity"];
    
}

//解码操作。将键值读出
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.c_id = [aDecoder decodeObjectForKey:@"c_id"];
        self.shoppingCarProduct = [aDecoder decodeObjectForKey:@"shoppingCarProduct"];
        self.c_number = [aDecoder decodeObjectForKey:@"c_number"];
        self.c_type = [aDecoder decodeObjectForKey:@"c_type"];
        self.totalprice = [aDecoder decodeObjectForKey:@"totalprice"];
        self.s_min_quantity = [aDecoder decodeObjectForKey:@"s_min_quantity"];
       
        
    }
    return self;
}

@end
