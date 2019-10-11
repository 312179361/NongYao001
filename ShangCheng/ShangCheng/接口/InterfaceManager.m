//
//  InterfaceManager.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/31.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "InterfaceManager.h"

@interface InterfaceManager ()
@property (nonatomic,strong)NSString *mainUrl;
@property (nonatomic,strong)NSString *mainUrlNew;

@property (nonatomic,strong)NSString *baseUrl;
@property (nonatomic,strong)NSString *baseUrlNew;


@end

@implementation InterfaceManager

+ (InterfaceManager *)shareInstance {
    static InterfaceManager *interfaceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        interfaceManager = [[InterfaceManager alloc] init];
    });
    return interfaceManager;
    
}

- (NSString *)mainUrl {
    //线上
    return @"https://api.nongyao001.com:7001/";
    //99
//    return @"http://192.168.0.99:5260/";

    //本地
//    return @"http://192.168.0.211:5260/";
//    return @"http://f1756470o8.iok.la/";

}

- (NSString *)mainUrlNew {
    return @"https://apishop.nongyao001.com:7443/";
}


- (NSString *)baseUrl {
    return [NSString stringWithFormat:@"%@api",self.mainUrl];
}


- (NSString *)baseUrlNew {
    return [NSString stringWithFormat:@"%@api",self.mainUrlNew];
}

#pragma mark - 首页 -
//banner图
- (NSString *)linkManageBase {
    return [NSString stringWithFormat:@"%@/LinkManage",self.baseUrl];
}

//今日特价
- (NSString *)todayActivityBase {
    return [NSString stringWithFormat:@"%@/TodayActivity",self.baseUrl];
}

//病虫害知识
- (NSString *)informationPestsBase {
    return  [NSString stringWithFormat:@"%@/PestsType",self.baseUrl];
}

//资讯
- (NSString *)informationIndexBase {
    return [NSString stringWithFormat:@"%@/InformationIndex",self.baseUrl];
}

#pragma mark - 搜索 -
- (NSString *)siteSearchBase {
    return [NSString stringWithFormat:@"%@/SiteSearch",self.baseUrl];
}
#pragma mark - 分类 -
- (NSString *)productsBySortTypeBase {
    return [NSString stringWithFormat:@"%@/ProductsBySortType",self.baseUrl];
}


#pragma mark - 产品 -
//首页产品 cnum是热销产品的个数，
- (NSString *)homeHotProductWithCnum:(NSString *)cnum {
    return [NSString stringWithFormat:@"%@/SellingProducts?pageindex=1&pagesize=%@",self.baseUrl,cnum];
}

//首页产品
- (NSString *)homeProductURLWithRnum:(NSString *)rnum {
    return [NSString stringWithFormat:@"%@/ProductHomePage?rnum=%@",self.baseUrl,rnum];
}

//产品详情
- (NSString *)productDetailURLWithProductID:(NSString *)productID withType:(NSString *)type withIsst:(NSString *)isst {
    return [NSString stringWithFormat:@"%@/Product?id=%@&type=%@&isst=%@&isfo=1",self.baseUrl,productID,type,isst];
    
}

//产品所有规格
- (NSString *)productAllFarmatWithProductID:(NSString *)productID {
    return [NSString stringWithFormat:@"%@/ProductStandard?id=%@",self.baseUrl,productID];
}

//产品分类树
- (NSString *)productClassTree {
    return [NSString stringWithFormat:@"%@/ProductCategory?col=p_type",self.baseUrl];
}

//产品的交易记录
- (NSString *)productTradeRecordBase {
    return [NSString stringWithFormat:@"%@/TransactionRecordPD",self.baseUrl];
}

#pragma mark - banner活动产品 -
//活动产品列表
- (NSString *)activityProductListBase {
    return [NSString stringWithFormat:@"%@/ActivityDo",self.baseUrl];
}

//参与厂家
- (NSString *)activityFactoryListBase {
    return [NSString stringWithFormat:@"%@/ActivityDoFactory",self.baseUrl];
}
//交易记录
- (NSString *)activityTradeListBase {
    return [NSString stringWithFormat:@"%@/AllDynamic",self.baseUrl];
}

#pragma mark - 购物车 -
- (NSString *)shoppingCarBaseURL {
    return [NSString stringWithFormat:@"%@/ShoppingCart",self.baseUrl];
}

- (NSString *)shoppingAdd:(NSString *)productID {
    return [NSString stringWithFormat:@"%@/ShoppingCart?id=%@",self.baseUrl,productID];
}
//获得购物车的产品
- (NSString *)getShoppingCarProductUrlWithUserId:(NSString *)userId {
    return [NSString stringWithFormat:@"%@/ShoppingCart?id=%@",self.baseUrl,userId];
}

//删除购物车中的某些产品
- (NSString *)deleteShoppingCarProductUrlWithShoppingCarID:(NSString *)shoppingCarID withSecret:(NSString *)secret {
//    return [NSString stringWithFormat:@"%@/ShoppingCart",self.baseUrl];
    return [NSString stringWithFormat:@"%@/ShoppingCart?id=%@&m=%@",self.baseUrl,shoppingCarID,secret];
}

//预订单
- (NSString *)orderPreviewUrl {
    return [NSString stringWithFormat:@"%@/OrderPreview",self.baseUrl];
}

#pragma mark - 订单 -
//优惠券Base
- (NSString *)couponBase {
    return  [NSString stringWithFormat:@"%@/coupon",self.baseUrl];
}
//优惠券
- (NSString *)getCouponListWithUserId:(NSString *)userID {
    return [NSString stringWithFormat:@"%@/coupon?id=%@",self.baseUrl,userID];
}

//计算优惠卷的金额
- (NSString *)computeCouponMoneyPOST {
    return [NSString stringWithFormat:@"%@/couponcalc",self.baseUrl];
}


//订单列表 -1全部、0,1B,1A待付款、1,待收货、9已完成
- (NSString *)orderListWithUserID:(NSString *)userID withType:(NSString *)type withCode:(NSString *)code withOrderStatus:(NSString *)orderStatus withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger )pageSize {

    return [NSString stringWithFormat:@"%@/OrderGenerated?id=%@&type=%@&code=%@&status=%@&pageindex=%ld&pagesize=%ld",self.baseUrl,userID,type,code,orderStatus,pageIndex,pageSize];
}

//用户退货订单查询
- (NSString *)orderReturnListUserId:(NSString *)userId withCode:(NSString *)code withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize {
    
    return [NSString stringWithFormat:@"%@/OrderGenerated?id=%@&code=%@&pageindex=%ld&pagesize=%ld",self.baseUrl,userId,code,pageIndex,pageSize];
}

//生成订单
- (NSString *)creatOrderPOSTUrl {
    return [NSString stringWithFormat:@"%@/OrderGenerated",self.baseUrl];
}

//取消订单
- (NSString *)cancelOrderWithOrderID:(NSString *)orderId {
    return [NSString stringWithFormat:@"%@/CancelOrder?id=%@",self.baseUrl,orderId];
}
//取消子订单
- (NSString *)cancelSonOrderPOST {
    return [NSString stringWithFormat:@"%@/CancelOrder",self.baseUrl];
}

//物流信息
- (NSString *)logisticsWithOrderId:(NSString *)orderId withType:(NSString *)type {
    return [NSString stringWithFormat:@"%@/OrderTracking?id=%@&type=%@",self.baseUrl,orderId,type];
}

//子订单确认收货
- (NSString *)UserReceiptBase{
    return [NSString stringWithFormat:@"%@/UserReceipt",self.baseUrl];
}

//代付款和待收货个数，
- (NSString *)waitPayAndWaitReceiveCountBase {
    return [NSString stringWithFormat:@"%@/userdata",self.baseUrl];
}


#pragma mark - 支付 -
//支付前验证
- (NSString *)paybeforeVerifyPOST {
    return [NSString stringWithFormat:@"%@/OrderPaymentVerify",self.baseUrl];
}
//支付宝获取签名
- (NSString *)AliPaySignPOST {
    return [NSString stringWithFormat:@"%@/Alipay",self.baseUrl];
}

//用户确认支付
- (NSString *)userConfirmPayPOST {
    return [NSString stringWithFormat:@"%@/UserConfirmPay",self.baseUrl];
}

//支付后，后台验证 
- (NSString *)orderPaymentVerifyWithPayid:(NSString *)payId {
    return [NSString stringWithFormat:@"%@/OrderPaymentVerify?pid=%@",self.baseUrl,payId];
}

#pragma mark - 个人中心  充值 -
- (NSString *)userRechargeBase {
    return [NSString stringWithFormat:@"%@/UserRecharge",self.baseUrl];
}
#pragma mark - 个人中心 意见反馈 -
- (NSString *)userFeedBackBase {
    return [NSString stringWithFormat:@"%@/GuestBook",self.baseUrl];
}


#pragma mark - 个人信息 -
//查询个人余额
- (NSString *)searchUserAmountWithUserID:(NSString *)userID {
    return [NSString stringWithFormat:@"%@/UserAmount?id=%@",self.baseUrl,userID];
}

//收货地址列表
- (NSString *)receiveAddressWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId {
    return [NSString stringWithFormat:@"%@/Receive?id=%@",self.baseUrl,userIdOrReceiveId];
}

//收货地址
- (NSString *)receiveAddressBase {
    return [NSString stringWithFormat:@"%@/Receive",self.baseUrl];

}

//评论
- (NSString *)userOrderReviewBase {
    return [NSString stringWithFormat:@"%@/UserOrderReview",self.baseUrl];
}


//收藏base
- (NSString *)favoriteBase {
    return [NSString stringWithFormat:@"%@/Favorite",self.baseUrl];
}
//获取收藏列表
- (NSString *)myFavoriteListWithUserId:(NSString *)userid {
    return [NSString stringWithFormat:@"%@?id=%@",[self favoriteBase],userid];
}

//流水账查询
- (NSString *)userAccountBase {
    return [NSString stringWithFormat:@"%@/UserAccount",self.baseUrl];
}

//用户余额提现和提现记录
- (NSString *)AgentCashBase {
    return [NSString stringWithFormat:@"%@/AgentCash",self.baseUrl];
}
//代理商收益提现
- (NSString *)AgentCashNewBase {
    return [NSString stringWithFormat:@"%@/AgentCashNew",self.baseUrl];

}


//修改密码
- (NSString *)motifyPasswordBase {
    return [NSString stringWithFormat:@"%@/UserModifyPWD",self.baseUrl];
}

//个人中心 我的钱包数据
- (NSString *)userDataBase {
    return [NSString stringWithFormat:@"%@/userdata",self.baseUrl];
}

//修改头像
- (NSString *)userIconBase {
    return [NSString stringWithFormat:@"%@/UserIcon",self.baseUrl];
}
#pragma mark - 我的代理 -
//基本代理数据
- (NSString *)myAgentDataBase {
    return [NSString stringWithFormat:@"%@/AgentData",self.baseUrl];
}

//人员列表数据
- (NSString *)myAgentPeopleListBase {
    return [NSString stringWithFormat:@"%@/AgentUser",self.baseUrl];
}

//订单列表数据
- (NSString *)myAgentOrderListBase {
    return [NSString stringWithFormat:@"%@/AgentOrder",self.baseUrl];
}

//代理客户收藏
- (NSString *)myAgentFavoriteBase {
    return [NSString stringWithFormat:@"%@/Agentfavorite",self.baseUrl];
}

//代理客户购物车
- (NSString *)myAgentShopCarBase {
    return [NSString stringWithFormat:@"%@/AgentShoppingCart",self.baseUrl];
}

//提成流水（新数据库）
- (NSString *)myAgentCommissionNewBase {
    return [NSString stringWithFormat:@"%@/AgentSalesCommission",self.baseUrl];
}
//提成流水（老数据库）
- (NSString *)myAgentCommissionOldBase {
    return [NSString stringWithFormat:@"%@/UserAccountOld",self.baseUrl];
}

#pragma mark - 发送通讯录信息 -
- (NSString *)userContactBase {
    return [NSString stringWithFormat:@"%@/UserContact",self.baseUrlNew];

}

#pragma mark - 登录注册 -
//登录接口
- (NSString *)loginPOSTAndPUTUrl {
    return [NSString stringWithFormat:@"%@/userlogin",self.baseUrl];
}

//获取验证码
- (NSString *)mobileCodePOST {
    return [NSString stringWithFormat:@"%@/Verification",self.baseUrl];
}

//检测验证码
- (NSString *)checkMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code {
    return [NSString stringWithFormat:@"%@/Verification?tel=%@&code=%@",self.baseUrl,mobileNumber,code];
}
//用户Base接口
- (NSString *)userBase {
    return [NSString stringWithFormat:@"%@/User",self.baseUrl];
}

//检验是否已经注册了
- (NSString *)isUserRegisterBase {
    return [NSString stringWithFormat:@"%@/IsUserRegistry",self.baseUrl];
}


//代理商注册
- (NSString *)AgentMerchantsBase {
    return [NSString stringWithFormat:@"%@/AgentMerchants",self.baseUrl];
}

//新用户注册后有20元红包
- (NSString *)registerCouponBase {

    return [NSString stringWithFormat:@"%@/coupon",self.baseUrlNew];

}

#pragma mark - 消息中心 -
//消息通知base
- (NSString *)messageNotificationBase {
    return [NSString stringWithFormat:@"%@/Information",self.baseUrl];
}



#pragma mark - 真假查询 -
- (NSString *)getTrueCheckWithCertificateNo:(NSString *)certificateNo {
    return [NSString stringWithFormat:@"http://nywy.nongyao001.com/API/api.php?footer=&header=&submitFlag=0&flag=0&pageNo=1&productName=&productType=&agentType=&crop=&preventionObject=&danHunJi=&isValid=&note=&certificateNo=%@",certificateNo];
}
- (NSString *)getTrueCheckWithComposition:(NSString *)composition {
    //汉字，需要解码
    return [[NSString stringWithFormat:@"http://nywy.nongyao001.com/API/api.php?footer=&header=&submitFlag=0&flag=0&pageNo=1&productName=&productType=&agentType=&crop=&preventionObject=&danHunJi=&isValid=&note=&composition=%@",composition] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
- (NSString *)getTrueCheckWithCompany:(NSString *)company {
    return [[NSString stringWithFormat:@"http://nywy.nongyao001.com/API/api.php?footer=&header=&submitFlag=0&flag=0&pageNo=1&productName=&productType=&agentType=&crop=&preventionObject=&danHunJi=&isValid=&note=&company=%@",company] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//肥料--等级证号
- (NSString *)getTrueCheckTwoWithCertificateNo:(NSString *)certificateNo {
    return [[NSString stringWithFormat:@"http://nywy.nongyao001.com/api/api7.php?txtzh=%@",certificateNo] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
}
//肥料--企业名称
- (NSString *)getTrueCheckTwoWithCompany:(NSString *)company {
    return [[NSString stringWithFormat:@"http://nywy.nongyao001.com/api/api7.php?enterprise_name=%@",company] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

//微生物--等级证号，即纯数字
- (NSString *)getTrueCheckThreeWithCertificateNo:(NSString *)certificateNo {
    return [[NSString stringWithFormat:@"http://nywy.nongyao001.com/api/api7.php?Sproduct=复合微生物肥料&txtzh=%@",certificateNo] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
}
//微生物--企业名称，即不是纯数字
- (NSString *)getTrueCheckThreeWithCompany:(NSString *)company {
    return [[NSString stringWithFormat:@"http://nywy.nongyao001.com/api/api7.php?Sproduct=复合微生物肥料&enterprise_name=%@",company] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
}

#pragma mark - 发送银行卡号 -
- (NSString *)sendBankCard {
    
    return @"http://118.178.224.54:8044/api/SendBankCard";
    return [NSString stringWithFormat:@"%@/SendBankCard",self.baseUrl];
}

#pragma mark - 其他 -
//地区信息
- (NSString *)getAreaTree {
    return [NSString stringWithFormat:@"%@/area?tree=",self.baseUrl];
}

//上传头像
- (NSString *)uploadImage {
    return [NSString stringWithFormat:@"%@/UploadFile",self.baseUrl];
}


@end
