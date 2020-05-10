//
//  LFRequest.m
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import "LFRequest.h"
#import "LFNetworkManager.h"
#import <YYModel/YYModel.h>

@interface LFRequest ()

@property (readwrite, nonatomic, assign) LFRequestMethod method;

@property (readwrite, nonatomic, copy  ) NSString *domain;
@property (readwrite, nonatomic, copy  ) NSString *uri;
@property (readwrite, nonatomic, assign) Class rspClass;
@property (readwrite, nonatomic, assign) BOOL needCache;

@property (readwrite, nonatomic, strong) NSMutableDictionary *params;
@property (readwrite, nonatomic, strong) NSMutableDictionary *header;
@property (readwrite, nonatomic, assign) BOOL asynBack;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation LFRequest


+ (instancetype)GetWithDomain:(nullable NSString *)domain
                          uri:(NSString *)uri
                     rspClass:(nullable Class)rspClass
                    needCache:(BOOL)needCache {
    NSAssert(uri.length > 0, @"uri(path) is empty");
    LFRequest *newRequest = [LFRequest new];
    newRequest.method = LFRequestMethodGet;
    newRequest.domain = domain;
    newRequest.uri = uri;
    newRequest.rspClass = rspClass;
    newRequest.needCache = needCache;
    return newRequest;
}

+ (instancetype)GetWithUri:(NSString *)uri
                  rspClass:(nullable Class)rspClass
                 needCache:(BOOL)needCache {
    return [self GetWithDomain:nil uri:uri rspClass:rspClass needCache:needCache];
}

+ (instancetype)GetWithUri:(NSString *)uri
                  rspClass:(nullable Class)rspClass {
    return [self GetWithDomain:nil uri:uri rspClass:rspClass needCache:NO];
}

+ (instancetype)PostWithDomain:(NSString *)domain
                           uri:(NSString *)uri
                      rspClass:(Class)rspClass
                     needCache:(BOOL)needCache {
    NSAssert(uri.length > 0, @"uri(path) is empty");
    LFRequest *newRequest = [LFRequest new];
    newRequest.method = LFRequestMethodPost;
    newRequest.domain = domain;
    newRequest.uri = uri;
    newRequest.rspClass = rspClass;
    newRequest.needCache = needCache;
    return newRequest;
}

+ (instancetype)PostWithUri:(NSString *)uri
                   rspClass:(Class)rspClass
                  needCache:(BOOL)needCache {
    return [self PostWithDomain:nil uri:uri rspClass:rspClass needCache:NO];
}

+ (instancetype)PostWithUri:(NSString *)uri
                   rspClass:(nullable Class)rspClass {
    return [self PostWithDomain:nil uri:uri rspClass:rspClass needCache:NO];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serializerType = LFRequestSerializerTypeHttp;
        self.requestTimeout = 10;
        self.tag = 0;
    }
    return self;
}

- (void)requestSuccess:(LFNetSuccBlock)success
               failure:(LFNetFailBlock)failure {
    [self requestParams:self.params header:self.header success:success failure:failure];
}

- (void)requestParams:(NSDictionary *)params
              success:(LFNetSuccBlock)success
              failure:(LFNetFailBlock)failure {
    [self requestParams:params header:self.header success:success failure:failure];
}

- (void)requestParams:(NSDictionary *)params
               header:(NSDictionary *)header
              success:(LFNetSuccBlock)success
              failure:(LFNetFailBlock)failure {
    if (params && self.params != params) {
        self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    if (header && self.header != header) {
        self.header = [NSMutableDictionary dictionaryWithDictionary:header];
    }
    self.asynBack = NO;
    self.dataTask = [[LFNetworkManager manager] sendRequest:self succ:success fail:failure];
}


- (void)requestAsynBackSuccess:(LFNetSuccBlock)success
                       failure:(LFNetFailBlock)failure {
    [self requestAsynBackParams:self.params header:self.header success:success failure:failure];
}

- (void)requestAsynBackParams:(NSDictionary *)params
                      success:(LFNetSuccBlock)success
                      failure:(LFNetFailBlock)failure {
    [self requestAsynBackParams:params header:self.header success:success failure:failure];
}

- (void)requestAsynBackParams:(NSDictionary *)params
                       header:(NSDictionary *)header
                      success:(LFNetSuccBlock)success
                      failure:(LFNetFailBlock)failure {
    if (params && self.params != params) {
        self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    if (header && self.header != header) {
        self.header = [NSMutableDictionary dictionaryWithDictionary:header];
    }
    self.asynBack = YES;
    self.dataTask = [[LFNetworkManager manager] sendRequest:self succ:success fail:failure];
}

- (void)cancelRequest {
    if (self.dataTask.state == NSURLSessionTaskStateRunning ||
        self.dataTask.state == NSURLSessionTaskStateSuspended) {
        [self.dataTask cancel];
    }
}

- (NSString *)cacheKey {
    NSData *urlData = [self.urlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *urlBase64 = [urlData base64EncodedStringWithOptions:0];
    
    NSError *err = nil;
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:self.params
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&err];
    NSString *paramBase64 = @"";
    if (!err) {
        paramBase64 = [paramData base64EncodedStringWithOptions:0];
    }
    return [NSString stringWithFormat:@"%@<->%@", urlBase64, paramBase64];
}

#pragma mark - lazy

// 保证外部获取不为nil
- (NSMutableDictionary *)header {
    if (!_header) {
        _header = [NSMutableDictionary dictionary];
    }
    return _header;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (NSString *)urlString {
    if ([self.uri hasPrefix:@"http"]) {
        return self.uri;
    }
    NSString *domain = self.domain.length > 0 ? self.domain : LFNetworkManager.manager.config.obtainDomain;
    NSAssert(domain.length > 0, @"LFRequest: domain 为空");
    return [NSString stringWithFormat:@"%@%@", domain, self.uri ?: @""];
}

@end
