//
//  PestsTreeModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PestsTreeModel : NSObject
@property (nonatomic,strong)NSString *c_catid;
@property (nonatomic,strong)NSString *c_name;
@property (nonatomic,strong)NSString *c_listorder;
@property (nonatomic,strong)NSString *c_linkurl;
@property (nonatomic,strong)NSString *c_moduleid;
@property (nonatomic,strong)NSString *c_parentid;
@property (nonatomic,strong)NSMutableArray *itemArr;
@property (nonatomic,assign)BOOL isMore;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
