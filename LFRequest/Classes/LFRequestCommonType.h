//
//  LFRequestCommonType.h
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#ifndef LFRequestCommonType_h
#define LFRequestCommonType_h

@class LFRequest;

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

/// 请求拦截
typedef BOOL(^LFRequestInterceptorBlock)(LFRequest *request, NSError *__autoreleasing *error);
/// 数据解析
typedef id(^LFRequestParseBlock)(LFRequest *request, NSDictionary *jsonDict, NSError *__autoreleasing *error);
/// 错误码拦截
typedef BOOL(^LFRequestErrorInterceptBlock)(LFRequest *request, NSError *error);

/// 请求成功block
typedef void(^LFNetSuccBlock)(id rspModel, NSDictionary *rspJson);
/// 失败block， rspModel可能是model，可能是dict
typedef void(^LFNetFailBlock)(NSError *error, id rspModel);

#endif /* LFRequestCommonType_h */
