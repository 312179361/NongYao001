//
//  ProductDetailModel.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"
@interface ProductDetailModel : NSObject<NSCoding>
//产品基本信息
@property (nonatomic,strong)ProductModel *productModel;
//产品分类
@property (nonatomic,strong)NSString *p_typevalue1;
//产品编码
@property (nonatomic,strong)NSString *p_pid;
//有效成分
@property (nonatomic,strong)NSString *p_ingredient;
//起订数量
@property (nonatomic,strong)NSString *p_standard_qty;

//产品证书数组 有PD证 产品标准证 生产许可证
@property (nonatomic,strong)NSMutableArray *p_cerArr;

////PD证
//@property (nonatomic,strong)NSString *p_registration;
////产品标准证
//@property (nonatomic,strong)NSString *p_certificate;
////生产许可证
//@property (nonatomic,strong)NSString *p_license;
//时间
@property (nonatomic,strong)NSString *p_time_create;
//防治对象字符串
@property (nonatomic,strong)NSString *p_treatment_str;

//产品状态码
@property (nonatomic,strong)NSString *p_status;
//产品状态说明
@property (nonatomic,strong)NSString *statusvalue;
//产品介绍
@property (nonatomic,strong)NSString *p_introduce;

//使用说明--作物或范围
@property (nonatomic,strong)NSArray *p_scope_crop_Arr;
//防治对象数组
@property (nonatomic,strong)NSArray *p_treatment_Arr;
//使用说明--制剂用药量
@property (nonatomic,strong)NSArray *p_dosage_Arr;
//使用说明--使用方法
@property (nonatomic,strong)NSArray *p_method_Arr;

//产品所有的规格数组
@property (nonatomic,strong)NSMutableArray *productFarmatArr;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;






@end
