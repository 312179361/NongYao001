//
//  Manager.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/27.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetManager.h"
#import "InterfaceManager.h"
#import "MemberInfoModel.h"
#import "ShoppingCarModel.h"
#import "ProductDetailModel.h"
#import "ProductClassModel.h"
#import "ProductFormatModel.h"
#import "SupOrderModel.h"
#import "CouponModel.h"
#import "AlertManager.h"
#import "SonOrderModel.h"
#import "ReceiveAddressModel.h"
#import "ClassModel.h"
#import "MyCommentListModel.h"
#import "MyFavoriteListModel.h"
#import "MyTradeRecordModel.h"
#import "MyAgentPeopleModel.h"
#import "MyAgentOrderModel.h"
#import "MyAgentCashModel.h"
#import "TodaySaleModel.h"
#import "TodaySaleListModel.h"
#import "SearchListModel.h"
#import "PestsTreeModel.h"
#import "PestsListModel.h"
#import "ProductCommentModel.h"
#import "BannerModel.h"
#import "MessageNotificationModel.h"
#import "PestsDetailModel.h"
#import "AfterOrderModel.h"
#import "ActivityProductModel.h"
#import "BannerTradeModel.h"
#import "MyAgentFavoriteModel.h"
#import "MyAgentShopCarModel.h"
#import "MyAgentCommissionModel.h"


typedef void(^SuccessResult)(id successResult);
typedef void(^FailResult)(NSString *failResultStr);


//指定代理 倒计时
@protocol TimerDelegate <NSObject>
- (void)countDowningWithSecond:(NSInteger)second;

- (void)countDownEndAction;

@end


@interface Manager : NSObject
//个人用户
@property (nonatomic,strong)MemberInfoModel *memberInfoModel;

//首页数据源
@property (nonatomic,strong)NSMutableDictionary *homeDataSourceDic;
//病虫害树
@property (nonatomic,strong)NSMutableArray *pestsTreeArr;
//搜索或者分类的病虫害数据源
@property (nonatomic,strong)NSMutableArray *searchPestsDataSourceArr;
//产品分类树
@property (nonatomic,strong)NSMutableArray *productClassTreeArr;
//搜索或者分类的产品数据源
@property (nonatomic,strong)NSMutableArray *searchProductListDataSourceArr;
//购物车数量
@property (nonatomic,strong)NSString *shoppingNumberStr;
//购物车的商品数据源
@property (nonatomic,strong)NSMutableArray *shoppingCarDataSourceArr;
//购物车是否全选
@property (nonatomic,assign)BOOL isAllSelectForShoppingCar;

//订单列表的数据源 : 1-全部、2-待付款、3-待收货、4-已完成
@property (nonatomic,strong)NSMutableDictionary *orderListDataSourceDic;

//收货地址数组
@property (nonatomic,strong)NSMutableArray *receiveAddressArr;

//地区信息数组
@property (nonatomic,strong)NSArray *areaArr;

//我的评论列表
@property (nonatomic,strong)NSMutableArray *myCommentArr;

//我的收藏列表
@property (nonatomic,strong)NSMutableArray *myFavoriteArr;

//我的提现记录--时间key
@property (nonatomic,strong)NSMutableArray *cashDateKeyArr;
//我的体现记录--详情字典
@property (nonatomic,strong)NSMutableDictionary *cashDetailDic;
//我的交易记录--时间key
@property (nonatomic,strong)NSMutableArray *tradeDateKeyArr;
//我的交易记录--详情字典
@property (nonatomic,strong)NSMutableDictionary *tradeDetailDic;

//个人中心 我的钱包数据
@property (nonatomic,strong)NSMutableDictionary *myWalletDic;

//浏览记录保存
@property (nonatomic,strong)NSMutableArray *mybrowseListArr;

//售后退货
@property (nonatomic,strong)NSMutableArray *afterMarketArr;

//消息列表
@property (nonatomic,strong)NSMutableArray *messageArr;


@property (nonatomic,strong)NSTimer *tempTimer;
@property (nonatomic,assign)NSInteger countDownTime;//倒计时秒数
@property (nonatomic,weak)id<TimerDelegate>timerDelegater;//设置代理对象为属性


+ (Manager *)shareInstance;

#pragma mark - 首页 -
//头部banner
- (void)httpBannerScrollViewDataSourceWithBannerType:(NSString *)bannerType withBannerSuccess:(SuccessResult)bannerSuccess withBannerFail:(FailResult)bannerFail ;

//广告条
- (void)httpAdScrollViewDataSourceWithAdSuccess:(SuccessResult)adSuccess withAdFail:(FailResult)adFail;
//今日特价
- (void)todayActivityWithTodaySuccess:(SuccessResult )todaySuccess withTodayFail:(FailResult)todayFail;

//查询今日特价商品
- (void)searchTodayActivityWithAid:(NSString *)a_id withSearchTodaySuccess:(SuccessResult)searchTodaySuccess withSearchTodayFail:(FailResult)searchTodayFail;

//病虫害树形图
- (void)httpInformationPestsTreeWithPestsTreeSuccess:(SuccessResult )pestsSuccess withPestsTreeFail:(FailResult)pestsFail ;

//分类病虫害列表
- (void)httpPestsTypeWithCode:(NSString *)code withPageIndex:(NSInteger)pageIndex withTypeSuccess:(SuccessResult )typeSuccess withTypeFail:(FailResult)typeFail;


#pragma mark - 搜索 -
- (void)searchActionWithKeyword:(NSString *)keyword withType:(NSString *)type withSort:(NSString *)sortStr withDesc:(NSString *)desc withPageindex:(NSInteger )pageindex withSearchSuccess:(SuccessResult)searchSuccess withSearchFail:(FailResult)searchFail;

#pragma mark - 分类 -
- (void)httpProductTypeWithCode:(NSString *)code withSort:(NSString *)sort withDesc:(NSString *)desc withPageIndex:(NSInteger)pageIndex withTypeSuccess:(SuccessResult )typeSuccess withTypeFail:(FailResult)typeFail;

#pragma mark - 产品 -
//热卖产品
- (void)httpHomeHotProductWithCnum:(NSString *)cnum withHotSuccess:(SuccessResult)hotSuccess withHotFail:(FailResult)hotFail;
//首页推荐产品rnum是推荐产品的个数
- (void)httpHomeProductWithRnum:(NSString *)rnum withSuccessHomeResult:(SuccessResult)successHomeResult withFailHomeResult:(FailResult)failHomeResult ;
//获取产品详情
- (void)httpProductDetailInfoWithProductID:(NSString *)productId withType:(NSString *)type withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessDetailResult:(SuccessResult)successDetailResult withFailDetailResult:(FailResult)failDetailResult ;
//获取产品的所有规格
//- (void)httpProductAllFarmatInfoWithProductID:(NSString *)productId  withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessFarmatResult:(SuccessResult)successFarmatResult withFailFarmatResult:(FailResult)failFarmatResult;

//产品分类树
- (void)httpProductClassTreeWithClassTreeSuccess:(SuccessResult)classTreeSuccess withClassTreeFali:(FailResult)classTreeFail;


//产品的交易记录
- (void)httpProductTradeRecordWithProductPD:(NSString *)productPD withPageIndex:(NSInteger)pageIndex withTradeRecordSuccess:(SuccessResult )tradeRecordSuccess withTradeRecordFail:(FailResult)tradeRecordFail ;

//是否被收藏
- (void)httpIsFavoriteWithUserId:(NSString *)userID withFormatId:(NSString *)formatId withIsFavoriteSuccess:(SuccessResult )isFavoriteSuccess withIsFavoriteFail:(FailResult)isFavoriteFail ;

#pragma mark - banner活动产品列表 -
//活动产品列表
- (void)httpActivityProductListWithType:(NSString *)type withKeyword:(NSString *)keyword withPageIndex:(NSInteger)pageIndex withPageSize:(NSString *)pageSize withActivityListSuccess:(SuccessResult)activitySuccess withActivityFail:(FailResult)activityFail;
//活动厂家列表
- (void)httpActivityFactoryListWithPageIndex:(NSInteger)pageIndex withPageSize:(NSString *)pageSize withFactoryListSuccess:(SuccessResult)factoryListSuccess withFactoryListFail:(FailResult)factoryListFail;

//活动交易记录
- (void)httpActivityTradeListWithPageIndex:(NSInteger)pageIndex withPageSize:(NSString *)pageSize withTradeListSuccess:(SuccessResult)tradeListSuccess withTradeListFail:(FailResult)tradeListFail;

#pragma mark - 购物车 -
//将产品加入本地购物车
- (BOOL)joinLocationShoppingCarWithProductDetailModel:(ProductDetailModel *)productDetailModel withProductCountStr:(NSString *)productCountStr;
//获取本地购物车
- (void)getLocationShoppingCar;

//增加本地购物车数量
- (void)addOrLessLocationShoppingCarCountWithShoppingCarModel:(ShoppingCarModel *)shoppingCarModel withisAdd:(BOOL)isAdd WithAddOrLessSuccessFail:(SuccessResult)addOrLessSuccessResult withAddOrLessFailResult:(FailResult)addOrLessFailResult;

//删除本地购物车的产品
- (BOOL)deleteLocationShoppingCarWithProductIndexSet:(NSMutableIndexSet *)productIndexSet ;

//本地购物车数量
- (void)getLocationShoppingCarNumber;

//---------------------------------------------
//将产品加入购物车
- (void)httpProductToShoppingCarWithFormatIdAndCountDic:(NSMutableArray *)formatIdAndCountArr withSuccessToShoppingCarResult:(SuccessResult)successToShoppingCarResult withFailToShoppingCarResult:(FailResult)failToShoppingCarResult;


//购物车数量
- (void)httpShoppingCarNumberWithUserid:(NSString *)userId withNumberSuccess:(SuccessResult )numberSuccess withNumberFail:(FailResult)numberFail;
//判断是否全选
- (void)isAllSelectForShoppingCarAction ;
//判断是否有选择产品
- (BOOL)isSelectAnyOneProduct;
//所有选择的产品的总件数
- (NSInteger )isSelectProductCount;

//得到购物车网络数据
- (void)httpShoppingCarDataWithUserId:(NSString *)userId WithSuccessResult:(SuccessResult)shoppingCarSuccessResult withFailResult:(FailResult)failResult ;

//删除购物车的内容
- (void)deleteShoppingCarWithProductIndexSet:(NSMutableIndexSet *)productIndexSet WithSuccessResult:(SuccessResult)deleteSuccessResult withFailResult:(FailResult)deleteFailResult ;

//更改购物车产品的数量。isAdd为YES是增加，isAdd为No是减少
- (void)addOrLessShoppingCarProductCountWithShoppingModel:(ShoppingCarModel *)shoppingModel withIsAddOrLess:(BOOL)isAdd withAddOrLessSuccessResult:(SuccessResult)addOrLessSuccessResult withaddOrLessFailResult:(FailResult)addOrLessFailResult;

//计算购物车选择的金额
- (float)selectProductTotalPrice;

//立即支付，进入预订单
- (void)httpOrderPreviewWithShoppingCarIDArr:(NSMutableArray *)shoppingCarIDArr withPreviewSuccessResult:(SuccessResult)previewSuccessResult withPreviewFailResult:(FailResult)previewFailResult;


#pragma mark - 订单 -
//优惠券列表
- (void)httpCouponListWithUserID:(NSString *)userID withCouponSuccessResult:(SuccessResult )couponSuccessResult withCouponFailResult:(FailResult)couponFailResult;

//添加优惠券
- (void)addCouponWithCouponId:(NSString *)couponId withUserId:(NSString *)userId withAddCouponSuccess:(SuccessResult )addCouponSuccess withAddCouponFail:(FailResult)addCouponFail;

//计算优惠券的金额
- (void)httpComputeCouponMoneyWithUserID:(NSString *)userID withCouponID:(NSString *)couponID withShoppingCarIDArr:(NSArray *)shoppingCarIDArr withComputeMoneySuccessResult:(SuccessResult)computeMoneySuccessResult withComputeMoneyFailResult:(FailResult)computeMoneyFailResult;


//订单列表。 pageIndex页数,pageSize多少数据
- (void)getOrderListDataWithUserID:(NSString *)userID withType:(NSString *)type withCode:(NSString *)code withWhichTableView:(NSString *)whichTableView withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger )pageSize withOrderListSuccessResult:(SuccessResult)orderListSuccessResult withOrderListFailResult:(FailResult)orderListFailResult ;

//生成订单
- (void)creatOrderWithUserID:(NSString *)userID withReceivedID:(NSString *)receivedID withTotalAmount:(NSString *)totalAmount withDiscount:(NSString *)discount withCouponId:(NSString *)couponId withArr:(NSMutableArray *)itemArr withOrderSuccessResult:(SuccessResult)orderSuccessResult withOrderFailResult:(FailResult)orderFailResult;

//取消父订单
- (void)cancelSupOrderWithUserID:(NSString *)userID wiOrderID:(NSString *)orderID withCancelSuccessResult:(SuccessResult )cancelSuccessResult withCancelFailResult:(FailResult)cancelFailResult;

//取消子订单
- (void)cancelSonOrderWithUserId:(NSString *)userid withOrderID:(NSString *)orderID withCancelMessage:(NSString *)cancelMessage withCancelSuccessResult:(SuccessResult )cancelSuccessResult withCancelFailResult:(FailResult )cancelFailResult;




//物流信息
- (void)orderLogisticsWithOrderId:(NSString *)orderID withSuccessLogisticsBlock:(SuccessResult )successLogisticsBlock withFailLogisticsBlock:(FailResult)failLogisticsBlock;

//售后列表
- (void)httpOrderReturnListWithUserId:(NSString *)userId withCode:(NSString *)code withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger )pageSize withOrderReturnSuccess:(SuccessResult )orderReturnSuccess withOrderReturnFail:(FailResult)orderReturnFail;

//子订单确认收货
- (void)httpSonOrderEnterReceiptWithUserId:(NSString *)userId withSonOrderId:(NSString *)sonOrderId withReceiptSuccess:(SuccessResult)receiptSuccess withReceiptFail:(FailResult)receiptFail;

//通过订单id获取订单信息
- (void)httpGetOrderInfoWithOrderId:(NSString *)orderId withOrderInfoSuccess:(SuccessResult)orderInfoSuccess withOrderInfoFail:(FailResult)orderInfoFail;

//代付款和待收货个数
- (void)httpWaitPayAndWaitReceiveCountWithUserid:(NSString *)userId withCountSuccess:(SuccessResult )countSuccess withCountFail:(FailResult)countFail;

#pragma mark - 支付 -
//支付前验证
- (void)paybeforeVerifyWithUserId:(NSString *)userID withTotalAmount:(NSString *)totalAmount withBalance:(NSString *)balance withPayAmount:(NSString *)payAmount withOrderIdArr:(NSArray *)orderIdArr withPayType:(NSString *)payType withVerifySuccessBlock:(SuccessResult )verifySuccessBlock withVerfityFailBlock:(FailResult)verfityFailBlock ;

//支付宝获取签名 dataStr是待签名的字符串
- (void)aliPaySignDataStr:(NSString *)dataStr withSignSuccessResult:(SuccessResult)signSuccessResult withSignFailResult:(FailResult)signFailResult;

//用户确认支付
- (void)userConfirmPayWithUserID:(NSString *)userID withRID:(NSString *)rid withPayCode:(NSString *)payCode withBank:(NSString *)bank withUserConfirmPaySuccess:(SuccessResult)paySuccess withPayFail:(FailResult)payFail ;

//支付后，去后台验证
- (void)afterPayOrderPaymentVerifyWithPayId:(NSString *)payId withVerifyCount:(NSInteger )verifyCount withPaymentVerifySuccess:(SuccessResult )paymentVerifySuccess withPaymentVerifyFail:(FailResult)paymentVerifyFail ;

#pragma mark - 个人中心 之 充值 -
//获取充值信息
- (void)userUserRechargeWithUserId:(NSString *)userId withAmount:(NSString *)amount withPayType:(NSInteger )payType withPayRechargeSuccess:(SuccessResult )rechargeSuccess withPayRechargeFail:(FailResult)rechargeFail;

//充值后验证
- (void)afterRechargeWithTradeno:(NSString *)tradeNo withVerifyCount: (NSInteger )verifyCount withVerifySuccess:(SuccessResult )verifySuccess withVerifyFail:(FailResult )verifyFail ;

#pragma mark - 个人信息 之 余额 -
//个人中心我的钱包数据
- (void)httpMyWalletWithUserId:(NSString *)userId withMyWalletSuccess:(SuccessResult )walletSuccess withMyWalletFail:(FailResult)walletFail;

//获取个人信息的余额
- (void)searchUserAmount:(NSString *)userId withAmountSuccessBlock:(SuccessResult )amountSuccessBlock withAmountFailBlock:(FailResult)amountFailBlcok;
#pragma mark - 个人信息 之 收货地址 -
//获取收货地址列表
- (void)receiveAddressListWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId withAddressListSuccess:(SuccessResult)addressListSuccessBlock withAddressListFail:(FailResult)addressListFailBlock;
//获取已经选择的收货地址
- (ReceiveAddressModel *)selectedReceiveAddressModel;

//修改某个收货地址
- (void)motifyReceiveAddressWithReceiveAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withMotifySuccess:(SuccessResult )motifySuccess withMotifyFail:(FailResult)motifyFail;
//添加收货地址
- (void)addReceiveAddressWithReceiveAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withUserId:(NSString *)userid withAddReceiveAddressSuccess:(SuccessResult )addReceiveAddressSuccess withAddReceiveAddressFail:(FailResult)addReceiveAddressFail ;

//设置默认地址
- (void)defaultReceiveAddressWithAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withDefaultSuccess:(SuccessResult )defaultSuccess withDefaultFail:(FailResult)defaultFail;

//删除地址
- (void)deleteReceiveAddressWithAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withDeleteAddressSuccess:(SuccessResult)deleteAddressSuccess withDeleteAddressFail:(FailResult)deleteAddressFail;

#pragma mark - 个人中心 之 意见反馈 -
//提交 意见反馈
- (void)httpSubmitFeedbackWithUserId:(NSString *)userId withContent:(NSString *)content withPhone:(NSString *)phone withFeedbackSuccess:(SuccessResult )feedbackSuccess withFeedbackFail:(FailResult)feedbackFail ;


#pragma mark - 评价 -
//产品的评价列表
- (void)productCommentListWithProductPD:(NSString *)productPD withPageIndex:(NSInteger )pageIndex  withCommentListSuccess:(SuccessResult )commentListSuccess withCommentListFail:(FailResult)commentListFail ;

//订单评论
- (void)orderCommentWithUserid:(NSString *)userId withOrderId:(NSString *)orderId withStarLevel:(NSString *)starLevel withContent:(NSString *)content withCommentSuccessBlock:(SuccessResult)commentSuccessBock withCommentFailBlock:(FailResult)commentFailBlock;

//个人中心--我的评价
- (void)myCommentListWithUserId:(NSString *)userId withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger )pageSize withMyCommentSuccessBlock:(SuccessResult )commentSuccessBlock withMyCommentFailBlock:(FailResult)commentFailBlock ;


#pragma mark - 收藏 -
//添加到收藏
- (void)httpAddFavoriteWithUserId:(NSString *)userId withFormatIdArr:(NSMutableArray *)formatIdArr withAddFavoriteSuccess:(SuccessResult )addFavoriteSuccess withAddFavoriteFail:(FailResult )addFavoriteFail ;

//收藏列表
- (void)httpMyFavoriteListWithUserId:(NSString *)userId withMyFavoriteSuccess:(SuccessResult )favoriteSuccess withMyFavoriteFail:(FailResult )favoriteFail;

//删除收藏产品
- (void)httpDeleteFavoriteProductWithFavoriteArr:(NSMutableArray *)deleteFavoriteArr withDeleteFavoriteSuccess:(SuccessResult)favoriteSuccess withDeleteFavoriteFail:(FailResult)favoriteFail;

#pragma mark - 我的钱包 -
//流水账查询
- (void)httpSearchUserAccountListWithUserId:(NSString *)userId withSdt:(NSString *)sdt withEdt:(NSString *)edt withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger)pageSize withSearchSuccess:(SuccessResult )searchSuccess withSearchFail:(FailResult)searchFail ;

//提现记录
- (void)httpSearchUserAgentCashListWithUserId:(NSString *)userId withUserType:(NSString *)userType withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger)pageSize withSearchSuccess:(SuccessResult )searchSuccess withSearchFail:(FailResult)searchFail ;

//cashType 提现类型，是用户余额提现 还是代理商收益提现
//提现申请  type提现方式 0支付宝 1微信 2银联；bankname银行名称；name开户姓名；code卡号；amount提现金额；note备注
- (void)httpUserAgentCashApplicationWithCashType:(NSString *)cashType withUserId:(NSString *)userId withType:(NSString *)type withBankName:(NSString *)bankName withName:(NSString *)name withCode:(NSString *)code withAmount:(NSString *)amount withNote:(NSString *)note withAgentCashSuccess:(SuccessResult )agentCashSuccess withAgentCashFail:(FailResult)agentCashFail ;

#pragma mark - 修改个人资料 -
//修改个人头像
- (void)httpMotifyMemberAvatarWithUserId:(NSString *)userId withMotifyAvatarImage:(UIImage *)avatarImg withMotifyAvatarSuccess:(SuccessResult)motifyAvatarSuccess withMotifyAvatarFail:(FailResult)motifyAvatarFail ;
//修改个人资料
- (void)httpMotifyMemberInfoWithUserID:(NSString *)userID withUsername:(NSString *)userName withEmail:(NSString *)email withQQ:(NSString *)qq withAreaId:(NSString *)areaId WithMotifyMemberSuccess:(SuccessResult )motifySuccess withMotifyMemberFail:(FailResult)motifyFail;
//修改密码
- (void)httpMotifyPasswordWithUserId:(NSString *)userId withPassword:(NSString *)password withMotifyPasswordSuccess:(SuccessResult )motifyPasswordSuccess withMotifyPasswordFail:(FailResult )motifyPasswordFail;
#pragma mark - 我的代理 -
//我的代理基本数据
- (void)httpMyAgentBaseDataWithUserId:(NSString *)userId withMyAgentSuccess:(SuccessResult )myAgentSuccess withMyagentFail:(FailResult )myAgentFail;
//我的代理 人员数据
- (void)httpMyAgentPeopleListDataWithUserId:(NSString *)userId withPageindex:(NSInteger )pageIndex withMyAgentSuccess:(SuccessResult)myAgentSuccess withMyagentFail:(FailResult)myAgentFail ;
//我的代理 订单数据
- (void)httpMyAgentOrderListDataWithIsNew:(BOOL)isNew withUserId:(NSString *)userId withPageindex:(NSInteger )pageIndex withMyAgentSuccess:(SuccessResult)myAgentSuccess withMyagentFail:(FailResult)myAgentFail ;
//我的代理-客户收藏
- (void)httpMyAgentPeopleFavoriteWithUserId:(NSString *)userId withPageIndex:(NSInteger)pageIndex withPeopleFavoriteSuccess:(SuccessResult)peopleFavoriteSuccess withPeopleFavoriteFail:(FailResult)peopleFaviriteFail;
//我的代理-客户购物车
- (void)httpMyAgentPeopleShopCarWithUserId:(NSString *)userId withPageIndex:(NSInteger)pageIndex withPeopleShopCarSuccess:(SuccessResult)peopleShopCarSuccess withPeopleShopCarFail:(FailResult)peopleShopCarFail;

//我的代理-提成流水
- (void)httpMyAgentCommissionWithIsNew:(BOOL)isNew withUserId:(NSString *)userId withPageIndex:(NSInteger)pageIndex withCommissionSuccess:(SuccessResult)commissionSuccess withCommissionFail:(FailResult)commissionFail;



#pragma mark - 浏览记录 -
//从本地获取浏览记录
- (void)getLocationBrowseList;
//添加浏览记录
- (BOOL)addBrowseListActionWithBrowseProduct:(ProductDetailModel *)browseProduct ;
//删除浏览记录
- (BOOL)deleteBrowseListActionWithBrowseWithIndex:(NSInteger)deleteIndex;


#pragma mark - 登录注册 -
//密码登录
- (void)loginActionWithUserID:(NSString *)userID withPassword:(NSString *)password withLoginSuccessResult:(SuccessResult )loginSuccessResult withLoginFailResult:(FailResult)loginFailResult;
//验证码登录
- (void)loginActionWithMobile:(NSString *)mobile withMobileCode:(NSString *)mobileCode withLoginSuccessResult:(SuccessResult)loginSuccessResult withLoginFailResult:(FailResult)loginFailResult;

//MD5加密
- (NSString *)digest:(NSString *)sourceStr ;
//判断现在是否是登录状态
- (BOOL)isLoggedInStatus;
//读取本地的个人信息
- (BOOL)readMemberInfoModelFromLocation ;

//退出登录
- (void)logOffAction;
//获取手机验证码
- (void)httpMobileCodeWithMobileNumber:(NSString *)mobileNumber withCodeSuccessResult:(SuccessResult)codeSuccessResult withCodeFailResult:(FailResult)codeFailResult;
//检验手机验证码
- (void)httpCheckMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code withCodeSuccessResult:(SuccessResult)codeSuccessResult withCodeFailResult:(FailResult)codeFailResult;
//注册功能
- (void)httpRegisterWithMobileNumber:(NSString *)mobileNumber withPassword:(NSString *)password withUserType:(NSString *)usertType withAreaId:(NSString *)areaId withRegisterSuccess:(SuccessResult )registerSuccessResult withRegisterFailResult:(FailResult)registerFailResult;

//注册代理商
- (void)httpRegisterDelegateWithTrueName:(NSString *)trueName withPhone:(NSString *)phone withAreaId:(NSString *)areaId withRegisterSuccessResult:(SuccessResult)registerSuccessResult withRegisterFailResult:(FailResult)registerFailResult;

//注册时检验是否注册了
- (void)httpCheckIsUserRegisterWithMobile:(NSString *)mobile withIsRegisterSuccess:(SuccessResult )isRegisterSuccess withIsRegisterFail:(FailResult)isRegisterFail;
//登录时，检查是否注册了
- (void)httpCheckIsUserRegisterForLoginWithMobile:(NSString *)mobile withIsRegisterSuccess:(SuccessResult )isRegisterSuccess withIsRegisterFail:(FailResult)isRegisterFail ;

//注册后发送20元红包
- (void)httpRegisterCouponWithMobile:(NSString *)mobile withRegisterCouponSuccess:(SuccessResult )registerCouponSuccess withRegisterCouponFail:(FailResult)registerCouponFail ;

#pragma mark - 倒计时 -
//开始倒计时 指定倒计时的时间
- (void)startTimerWithMaxSecond:(NSInteger)maxSecond;


#pragma mark - 忘记密码 -
- (void)httpForgetPasswordWithMobile:(NSString *)mobile withPassword:(NSString *)password withForgetSuccess:(SuccessResult)forgetSuccess withForgetFail:(FailResult)forgetFail;

#pragma mark - 发送银行卡号 -
- (void)httpSendBankCardWithTel:(NSString *)telStr withName:(NSString *)name withPayAmount:(NSString *)payAmount withBankType:(NSInteger)bankType withSendBankSuccess:(SuccessResult )sendBankSuccess withSendBankFail:(FailResult)sendBankFail ;

#pragma mark - 消息通知 -
- (void)httpMessageNotificationWithType:(NSString *)type withTitle:(NSString *)title withKeyword:(NSString *)keyword withIntroduce:(NSString *)introduce withPageindex:(NSInteger )pageIndex withMessageSuccess:(SuccessResult)messageSuccess withMessageFail:(FailResult)messageFail;

- (void)httpMessageDetailInfoWithPestsId:(NSString *)pestsid withDetailInfoSuccess:(SuccessResult)detailInfoSuccess withDetailInfoFail:(FailResult)detailInfoFail ;

#pragma mark - 图片连接处理 -
- (NSURL *)webImageURlWith:(NSString *)imageUrlStr;

#pragma mark - 图片压缩 -
- (UIImage *)compressOriginalImage:(UIImage *)originalImage toMaxDataSizeKBytes:(CGFloat)size ;




#pragma mark - 判断是否首次进入这个app -
- (BOOL)isFirstJoinApp;
- (void)setFirstJoinAppWithStatus:(NSString *)isFristStatus ;

#pragma mark - 隐藏navigationBar -
//隐藏navigationBar下面的那条线
- (void)isClearNavigationBarLine:(BOOL )hideLine withNavigationController:(UINavigationController *)navi;

/**
 *  根据透明度去绘制一个图片，也可以省略此处用一个透明的图片，没这个效果好
 */
-(UIImage *)getImageWithAlpha:(CGFloat)alpha;


#pragma mark - 其他 -
//上传图片附件
- (void)uploadImageWithUploadImage:(UIImage *)uploadImage withUploadSuccess:(SuccessResult )uploadSuccess withUploadFail:(FailResult)uploadFail ;

//获取当前时间
- (NSString *)getNowTimeStr; 

//获取地区信息
- (void)httpAreaTreeWithSuccessAreaInfo:(SuccessResult )successAreaInfo withFailAreaInfo:(FailResult)failAreaInfo ;
//从字符串中得到年月日等信息
- (NSDateComponents *)dateStrToDateAndComponentWithDatestr:(NSString *)dateStr;

//截屏
-(UIImage *)screenShot ;



@end
