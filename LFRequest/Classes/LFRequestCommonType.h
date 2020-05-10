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

@protocol LFRequestDelegate <NSObject>
@optional
/// 数据解析
- (id)request:(LFRequest *)request parseData:(NSDictionary *)jsonDict error:(NSError **)error;
/// 请求拦截，发送请求前进行拦截，也可用于请求前的处理工作，比如添加固有参数或请求头
- (BOOL)request:(LFRequest *)request interceptor:(NSError **)error;

/// 错误码拦截
- (BOOL)request:(LFRequest *)request errorIntercept:(NSError *)error;
@end

/// 请求成功block
typedef void(^LFNetSuccBlock)(id rspModel, NSDictionary *rspJson);
/// 失败block
typedef void(^LFNetFailBlock)(NSError *error);

#endif /* LFRequestCommonType_h */
