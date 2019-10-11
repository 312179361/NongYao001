//
//  NetManager.h
//  AFNet
//
//  Created by TongLi on 15/12/6.
//  Copyright © 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef  void(^SuccessResultBlock)(AFHTTPRequestOperation *operation, id successResult);
typedef  void(^FailResultBlock)(AFHTTPRequestOperation *operation,NSError *errorResult);

@interface NetManager : NSObject


+ (NetManager *)shareInstance;
//get请求
- (void)getRequestWithURL:(NSString *)requestURL withParameters:(NSDictionary *)parametersDic withContentTypes:(NSString *)contentType withHeaderArr:(NSArray *)headerArr withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult ;
//post请求
- (void)postRequestWithURL:(NSString *)requestURL withParameters:(id )parametersDic withContentTypes:(NSString *)contentType withHeaderArr:(NSArray *)headerArr withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult ;

//delete请求
- (void)deleteRequestWithURL:(NSString *)requestURL withParameters:(NSDictionary *)parametersDic withContentTypes:(NSString *)contentType withHeaderArr:(NSArray *)headerArr withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult ;

//put请求
- (void)putRequestWithURL:(NSString *)requestURL withParameters:(id)parametersDic withContentTypes:(NSString *)contentType withHeaderArr:(NSArray *)headerArr withSuccessResult:(SuccessResultBlock)successResult withError:(FailResultBlock)failResult ;




@end
