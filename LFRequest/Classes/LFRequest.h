//
//  LFRequest.h
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import <Foundation/Foundation.h>
#import "LFRequestCommonType.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFRequest : NSObject

@property (readonly, nonatomic, assign) LFRequestMethod method; ///< get、post

@property (readonly, nonatomic, copy  ) NSString *domain;       ///< 域名
@property (readonly, nonatomic, copy  ) NSString *uri;          ///< path (也可以是全路径）
@property (readonly, nonatomic, assign) Class rspClass;         ///< 数据model
@property (readonly, nonatomic, assign) BOOL needCache;         ///< 是否缓存

@property (readonly, nonatomic, copy  ) NSString *urlString;    ///< 完整url

@property (readonly, nonatomic, assign) BOOL asynBack;          ///< 是否异步返回

@property (readonly, nonatomic, strong) NSMutableDictionary *params;    ///< 请求参数
@property (readonly, nonatomic, strong) NSMutableDictionary *header;    ///< 请求头

/// 可以配置：请求拦截（也可以在请求前做配置工作）、数据解析
@property (nonatomic, weak) id<LFRequestDelegate> delegate;

/// 请求序列格式，默认LFRequestSerializerTypeHttp。post情况下如果要求以body传递参数，则该属性需要设置为LFRequestSerializerTypeJson
@property (nonatomic, assign) LFRequestSerializerType serializerType;

/// 超时时间，默认10秒
@property (nonatomic, assign) NSTimeInterval requestTimeout;

#pragma mark - 辅助变量
/// 辅助对象，具体功能由业务方定，可以 传递数据 给 拦截器（interceptor） 或者 数据解析（dataParse），也可以传递给错误码拦截中
@property (nonatomic, strong) id object;
/// 辅助标识位，默认值为0，功能与object相似
@property (nonatomic, assign) NSInteger tag;

+ (instancetype)GetWithDomain:(nullable NSString *)domain
                          uri:(NSString *)uri
                     rspClass:(nullable Class)rspClass
                    needCache:(BOOL)needCache;

+ (instancetype)GetWithUri:(NSString *)uri
                  rspClass:(nullable Class)rspClass
                 needCache:(BOOL)needCache;

+ (instancetype)GetWithUri:(NSString *)uri
                  rspClass:(nullable Class)rspClass;

+ (instancetype)PostWithDomain:(nullable NSString *)domain
                           uri:(NSString *)uri
                      rspClass:(nullable Class)rspClass
                     needCache:(BOOL)needCache;

+ (instancetype)PostWithUri:(NSString *)uri
                   rspClass:(nullable Class)rspClass
                  needCache:(BOOL)needCache;

+ (instancetype)PostWithUri:(NSString *)uri
                   rspClass:(nullable Class)rspClass;

#pragma mark < 主线程返回数据 >
- (void)requestSuccess:(nullable LFNetSuccBlock)success
               failure:(nullable LFNetFailBlock)failure;

- (void)requestParams:(nullable NSDictionary *)params
              success:(nullable LFNetSuccBlock)success
              failure:(nullable LFNetFailBlock)failure;

- (void)requestParams:(nullable NSDictionary *)params
               header:(nullable NSDictionary *)header
              success:(nullable LFNetSuccBlock)success
              failure:(nullable LFNetFailBlock)failure;

#pragma mark < 异步返回数据 >
- (void)requestAsynBackSuccess:(nullable LFNetSuccBlock)success
                       failure:(nullable LFNetFailBlock)failure;

- (void)requestAsynBackParams:(nullable NSDictionary *)params
                      success:(nullable LFNetSuccBlock)success
                      failure:(nullable LFNetFailBlock)failure;

- (void)requestAsynBackParams:(nullable NSDictionary *)params
                       header:(nullable NSDictionary *)header
                      success:(nullable LFNetSuccBlock)success
                      failure:(nullable LFNetFailBlock)failure;

/// 取消请求
- (void)cancelRequest;

/// 请求缓存key
- (NSString *)cacheKey;

@end

NS_ASSUME_NONNULL_END
