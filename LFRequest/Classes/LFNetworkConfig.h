//
//  LFNetworkConfig.h
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LFRequest;
@protocol LFRequestDelegate;

@interface LFNetworkConfig : NSObject

/// 默认域名block
@property (nonatomic, copy) NSString *(^domainBlock)(void);
/// 公共请求头block
@property (nonatomic, copy) NSDictionary *(^commonHeaderBlock)(void);
/// 包含有数据解析、请求拦截、错误码拦截
@property (nonatomic, strong) id<LFRequestDelegate> commonRequestDelegate;

/// 从domainBlock获取默认域名
- (NSString *)obtainDomain;

/// 从commonHeaderBlock获取公共请求头
- (NSDictionary *)obtainHeader;

@end

NS_ASSUME_NONNULL_END
