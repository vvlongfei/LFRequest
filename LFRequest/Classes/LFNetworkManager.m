//
//  LFNetworkManager.m
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import "LFNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <YYCache/YYCache.h>
#import <YYModel/YYModel.h>

#define weakify(VAR) \
rac_keywordify \
__weak __typeof__(VAR) VAR ## _weak_ = (VAR);

#define strongify(VAR) \
rac_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(VAR) VAR = VAR ## _weak_; \
_Pragma("clang diagnostic pop")

#if DEBUG
#define rac_keywordify autoreleasepool {}
#else
#define rac_keywordify try {} @catch (...) {}
#endif

static dispatch_queue_t url_session_completion_queue() {
    static dispatch_queue_t af_url_session_completion_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_url_session_completion_queue = dispatch_queue_create("com.longfei.completion.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return af_url_session_completion_queue;
}

@interface LFNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation LFNetworkManager


+ (instancetype)manager {
    static id _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark lazy

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
         NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        _sessionManager.completionQueue = url_session_completion_queue();
        _sessionManager.operationQueue.maxConcurrentOperationCount = 4;
        _sessionManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer],[AFHTTPResponseSerializer serializer],[AFImageResponseSerializer serializer]]];
    }
    return _sessionManager;
}

- (NSURLSessionDataTask *)sendRequest:(LFRequest *)request succ:(LFNetSuccBlock)succ fail:(LFNetFailBlock)fail {
    @weakify(self);
    // 创建请求url，如果域名为空，则debug下崩溃
    NSString *urlString = request.urlString;
    // 重新生成请求序列，保证公共请求头部分为最新，并设置超时时间
    [self buildRequestSerializerWithRequest:request];
    
    // 缓存处理
    if (request.needCache && succ) {
        [self backCacheForRequest:request succ:succ];
    }
    
    id successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSError *parseError = nil;
            id result = [self parseData:responseObject request:request error:&parseError];
            if (!parseError && succ) {
                [self backSuccForRequest:request result:result jsonDict:responseObject succ:succ];
            }
            if (parseError) {
                [self backFailForRequest:request error:parseError fail:fail];
            }
        } else {
            [self backFailForRequest:request error:[NSError errorWithDomain:@"数据格式有问题" code:-1 userInfo:@{
                @"response:" : (responseObject ?: @"responseObject为nil")
            }] fail:fail];
        }
    };
    
    id failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        NSError *dataError = [self errorParse:error];
        [self backFailForRequest:request error:dataError fail:fail];
    };
    
    NSURLSessionDataTask *task = nil;
    
    if (request.method == LFRequestMethodGet) {
        task = [self.sessionManager GET:urlString
                             parameters:request.params
                                headers:request.header
                               progress:nil
                                success:successBlock
                                failure:failureBlock];
    } else if (request.method == LFRequestMethodPost) {
        task = [self.sessionManager POST:urlString
                              parameters:request.params
                                 headers:request.header
                                progress:nil
                                 success:successBlock
                                 failure:failureBlock];
    }
    
    return task;
}

- (void)backSuccForRequest:(LFRequest *)request
                    result:(id)result
                  jsonDict:(NSDictionary *)jsonDict
                      succ:(LFNetSuccBlock)succ {
    
    if (!succ) { return; }
    
    if (request.asynBack) {
        succ(result, jsonDict);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            succ(result, jsonDict);
        });
    }
    if (request.needCache) {
        [self saveCache:jsonDict ForRequest:request];
    }
}

- (void)backFailForRequest:(LFRequest *)request error:(NSError *)error fail:(LFNetFailBlock)fail {
    
    if (self.config.errorIntercept && self.config.errorIntercept(request, error)) {
        // 错误信息被拦截
        return;
    }
    
    if (!fail) { return; }
    
    if (request.asynBack) {
        fail(error);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(error);
        });
    }
}

- (void)backCacheForRequest:(LFRequest *)request succ:(LFNetSuccBlock)succ {
    if (!succ) { return; }
    @weakify(self);
    dispatch_async(url_session_completion_queue(), ^{
        @strongify(self);
        
        id cacheData = [self cacheForRequest:request];
        // 为nil或非字典，返回
        if (!cacheData || ![cacheData isKindOfClass:NSDictionary.class]) { return; }
        
        NSError *parseError = nil;
        id result = [self parseData:cacheData request:request error:&parseError];
        // 解析失败
        if (parseError) {
            [self saveCache:nil ForRequest:request]; // 清除错误数据
            return;
        }
        
        // 获取cache成功
        [self backSuccForRequest:request result:result jsonDict:cacheData succ:succ];
    });
}

/// 每次都重新生成请求序列，保证都能获取最新的公共请求头、并设置超时时间
- (void)buildRequestSerializerWithRequest:(LFRequest *)request {
    
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.method == LFRequestMethodPost && request.serializerType == LFRequestSerializerTypeJson) {
        requestSerializer = [AFJSONRequestSerializer new];
    } else {
        requestSerializer = [AFHTTPRequestSerializer new];
    }
    
    requestSerializer.timeoutInterval = request.requestTimeout;
    
    NSDictionary *header = self.config.obtainHeader; // // 公共header部分
    
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:NSString.class] && [obj isKindOfClass:NSString.class]) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }
    }];
    
    self.sessionManager.requestSerializer = requestSerializer;
}

- (id)parseData:(NSDictionary *)jsonData request:(LFRequest *)request error:(NSError **)error {
    if (!request.rspClass) {
        return jsonData;
    }
    id<LFDataParseDelegate> dataParse = request.dataParse ?: self.config.commonDataParse;
    if ([dataParse respondsToSelector:@selector(parseDataFromJson:toClass:error:)]) {
        return [dataParse parseDataFromJson:jsonData toClass:request.rspClass error:error];
    } else {
        return [request.rspClass yy_modelWithJSON:jsonData];
    }
}

- (void)saveCache:(id)responseData ForRequest:(LFRequest *)request {
    YYCache *cache = [YYCache cacheWithName:@"com.longfei.response.cache"];
    [cache setObject:responseData forKey:request.cacheKey];
}

- (id)cacheForRequest:(LFRequest *)request {
    YYCache *cache = [YYCache cacheWithName:@"com.longfei.response.cache"];
    return [cache objectForKey:request.cacheKey];
}

/// 网络错误error解析
- (NSError *)errorParse:(NSError *)error {
    NSInteger errorCode = 0;
    NSString *errorMsg = @"";
    NSDictionary *errorBody = error.userInfo;
    if (error.code == NSURLErrorNetworkConnectionLost ||
        error.code == NSURLErrorCannotConnectToHost ||
        error.code == NSURLErrorNotConnectedToInternet) {
        errorMsg = @"网络开小差了";
        errorCode = error.code;
    } else {
        // code 与 message 为 与后端协定字段
        // 后端返回4xx时，协商返回数据格式
        errorBody = [self errorJSON:error];
        NSNumber *errorNum = errorBody[@"code"];
        errorCode = errorNum ? errorNum.integerValue : [self statusCode:error];
        errorMsg = errorBody[@"message"];
        if (!errorMsg || [errorMsg isKindOfClass:NSNull.class]) {
            errorMsg = error.userInfo[NSLocalizedDescriptionKey];
        }
    }
    return [NSError errorWithDomain:errorMsg code:errorCode userInfo:errorBody];
}

/// HTTPCode返回非200时，的body
- (NSDictionary *)errorJSON:(NSError *)error {
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData) {
        id data = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        if([data isKindOfClass:[NSDictionary class]]) {
            return data;
        }
    }
    return @{};
}

/// http.statusCode
- (NSInteger)statusCode:(NSError *)error {
    NSHTTPURLResponse *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    return errorResponse.statusCode;
}


@end
