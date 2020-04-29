//
//  LFRequestCommonType.h
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#ifndef LFRequestCommonType_h
#define LFRequestCommonType_h

/// 请求类型：get、post
typedef NS_ENUM(NSUInteger, LFRequestMethod) {
    LFRequestMethodGet,
    LFRequestMethodPost,
};

/// 序列化方式：http方式请求->get、post, json方式请求->post
typedef NS_ENUM(NSUInteger, LFRequestSerializerType) {
    LFRequestSerializerTypeHttp,
    LFRequestSerializerTypeJson,
};

/// 数据解析代理，分别可配置在通用配置、单独请求配置中
@protocol LFDataParseDeleate <NSObject>
- (id)parseDataFromJson:(NSDictionary *)jsonDict toClass:(Class)toClass error:(NSError **)error;
@end

/// 请求成功block
typedef void(^LFNetSuccBlock)(id rspModel, NSDictionary *rspJson);
/// 失败block
typedef void(^LFNetFailBlock)(NSError *error);

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

#endif /* LFRequestCommonType_h */
