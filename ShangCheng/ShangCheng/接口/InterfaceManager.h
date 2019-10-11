//
//  InterfaceManager.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/31.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceManager : NSObject

+ (InterfaceManager *)shareInstance;

#pragma mark - 首页 -
//banner图
- (NSString *)linkManageBase;
//今日特价
- (NSString *)todayActivityBase ;
//病虫害知识
- (NSString *)informationPestsBase;
//咨询
- (NSString *)informationIndexBase;

#pragma mark - 搜索 -
- (NSString *)siteSearchBase;
#pragma mark - 分类 -
- (NSString *)productsBySortTypeBase;

#pragma mark - 产品 -

//首页产品 cnum是热销产品的个数，
- (NSString *)homeHotProductWithCnum:(NSString *)cnum ;
//首页产品 rnum是推荐产品的个数
- (NSString *)homeProductURLWithRnum:(NSString *)rnum ;
//产品详情
- (NSString *)productDetailURLWithProductID:(NSString *)productID withType:(NSString *)type withIsst:(NSString *)isst ;
//产品所有规格
- (NSString *)productAllFarmatWithProductID:(NSString *)productID;

//产品分类树
- (NSString *)productClassTree;

//产品的交易记录
- (NSString *)productTradeRecordBase;

#pragma mark - banner活动产品 -
//活动产品列表
- (NSString *)activityProductListBase;
//参与厂家
- (NSString *)activityFactoryListBase;
//交易记录
- (NSString *)activityTradeListBase;



#pragma mark - 购物车 -
//购物车基本url
- (NSString *)shoppingCarBaseURL;
//增加或减少
- (NSString *)shoppingAdd:(NSString *)productID;

//获得购物车的产品
- (NSString *)getShoppingCarProductUrlWithUserId:(NSString *)userId;
//删除购物车中的某些产品
- (NSString *)deleteShoppingCarProductUrlWithShoppingCarID:(NSString *)shoppingCarID withSecret:(NSString *)secret;
- (NSString *)orderPreviewUrl;
#pragma mark - 订单 -

//优惠券Base
- (NSString *)couponBase;
//优惠卷
- (NSString *)getCouponListWithUserId:(NSString *)userID;
//计算优惠卷的金额
- (NSString *)computeCouponMoneyPOST;

//订单列表 -1全部、0,1B,1A待付款、1,待收货、9已完成
- (NSString *)orderListWithUserID:(NSString *)userID withType:(NSString *)type withCode:(NSString *)code withOrderStatus:(NSString *)orderStatus withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger )pageSize ;

//用户退货订单查询
- (NSString *)orderReturnListUserId:(NSString *)userId withCode:(NSString *)code withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize;

//生成订单
- (NSString *)creatOrderPOSTUrl;

//取消父订单
- (NSString *)cancelOrderWithOrderID:(NSString *)orderId;

//取消子订单
- (NSString *)cancelSonOrderPOST;

//物流信息
- (NSString *)logisticsWithOrderId:(NSString *)orderId withType:(NSString *)type;

//子订单确认收货
- (NSString *)UserReceiptBase;


//代付款和待收货个数，
- (NSString *)waitPayAndWaitReceiveCountBase;


#pragma mark - 支付 -
//支付前验证
- (NSString *)paybeforeVerifyPOST;

//支付宝获取签名
- (NSString *)AliPaySignPOST ;

//用户确认支付
- (NSString *)userConfirmPayPOST;

//支付后，后台验证
- (NSString *)orderPaymentVerifyWithPayid:(NSString *)payId;

#pragma mark - 个人中心  充值 -
- (NSString *)userRechargeBase;

#pragma mark - 个人中心 意见反馈 -
- (NSString *)userFeedBackBase;



#pragma mark - 个人信息 -
//查询个人余额
- (NSString *)searchUserAmountWithUserID:(NSString *)userID;
//收货地址列表
- (NSString *)receiveAddressWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId;
//收货地址
- (NSString *)receiveAddressBase;

//评论
- (NSString *)userOrderReviewBase;

//收藏base
- (NSString *)favoriteBase;

//获取收藏列表
- (NSString *)myFavoriteListWithUserId:(NSString *)userid;

//流水账查询
- (NSString *)userAccountBase;
//用户余额提现和提现记录
- (NSString *)AgentCashBase;
//代理商收益提现
- (NSString *)AgentCashNewBase;

//修改密码
- (NSString *)motifyPasswordBase;

//个人中心 我的钱包数据
- (NSString *)userDataBase;

//修改头像
- (NSString *)userIconBase;

#pragma mark - 我的代理 -
//基本代理数据
- (NSString *)myAgentDataBase;
//人员列表数据
- (NSString *)myAgentPeopleListBase;
//订单列表数据
- (NSString *)myAgentOrderListBase;
//代理客户收藏
- (NSString *)myAgentFavoriteBase;
//代理客户购物车
- (NSString *)myAgentShopCarBase;
//提成流水（新数据库）
- (NSString *)myAgentCommissionNewBase;
//提成流水（老数据库）
- (NSString *)myAgentCommissionOldBase;

#pragma mark - 发送通讯录信息 -
- (NSString *)userContactBase;

#pragma mark - 登录注册 -
//登录接口
- (NSString *)loginPOSTAndPUTUrl ;
//获取验证码
- (NSString *)mobileCodePOST ;
//检测验证码
- (NSString *)checkMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code;
//用户Base接口
- (NSString *)userBase;
//注册时检验是否已经注册了
- (NSString *)isUserRegisterBase;

//代理商注册
- (NSString *)AgentMerchantsBase;

//新用户注册后有20元红包
- (NSString *)registerCouponBase;

#pragma mark - 消息中心 -
//消息通知base
- (NSString *)messageNotificationBase;


#pragma mark - 真假查询 -
//农药--等级证号
- (NSString *)getTrueCheckWithCertificateNo:(NSString *)certificateNo;
//农药--有效成分
- (NSString *)getTrueCheckWithComposition:(NSString *)composition;
//农药--企业名称
- (NSString *)getTrueCheckWithCompany:(NSString *)company;
//肥料--等级证号
- (NSString *)getTrueCheckTwoWithCertificateNo:(NSString *)certificateNo;
//肥料--企业名称
- (NSString *)getTrueCheckTwoWithCompany:(NSString *)company;

//微生物--等级证号，即纯数字
- (NSString *)getTrueCheckThreeWithCertificateNo:(NSString *)certificateNo;
//微生物--企业名称，即不是纯数字
- (NSString *)getTrueCheckThreeWithCompany:(NSString *)company;

#pragma mark - 发送银行卡号 -
- (NSString *)sendBankCard;


#pragma mark - 其他 -
//地区信息
- (NSString *)getAreaTree;
//上传头像
- (NSString *)uploadImage;


@end
