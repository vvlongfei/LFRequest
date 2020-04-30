//
//  LFNetworkConfig.h
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LFRequest;
@protocol LFDataParseDelegate;

@interface LFNetworkConfig : NSObject

/// 默认域名block
@property (nonatomic, copy) NSString *(^domainBlock)(void);
/// 公共请求头block
@property (nonatomic, copy) NSDictionary *(^commonHeaderBlock)(void);
/// 请求失败码拦截
@property (nonatomic, copy) BOOL (^errorIntercept)(LFRequest *request, NSError *error);

/// response通用解析，默认为YYModel对response进行解析。注意，强引用
@property (nonatomic, strong) id<LFDataParseDelegate> commonDataParse;

/// 从domainBlock获取默认域名
- (NSString *)obtainDomain;

/// 从commonHeaderBlock获取公共请求头
- (NSDictionary *)obtainHeader;

@end

NS_ASSUME_NONNULL_END
