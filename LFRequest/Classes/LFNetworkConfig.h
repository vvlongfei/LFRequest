//
//  LFNetworkConfig.h
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import "LFRequestCommonType.h"

NS_ASSUME_NONNULL_BEGIN

@class LFRequest;

@interface LFNetworkConfig : NSObject

@property (nonatomic, copy) NSString *(^domainBlock)(LFRequest *request);           ///< 默认域名block
@property (nonatomic, copy) NSDictionary *(^commonHeaderBlock)(LFRequest *request); ///< 公共请求头block

@property (nonatomic, copy) LFRequestInterceptorBlock interceptor;         ///< 拦截器
@property (nonatomic, copy) LFRequestParseBlock dataParse;                  ///< 数据解析
@property (nonatomic, copy) LFRequestErrorInterceptBlock errorInterceptor;  ///< 错误拦截

/// 从domainBlock获取默认域名
- (NSString *)obtainDomainWithRequest:(LFRequest *)request;

/// 从commonHeaderBlock获取公共请求头
- (NSDictionary *)obtainHeaderWithRequest:(LFRequest *)request;

@end

NS_ASSUME_NONNULL_END
