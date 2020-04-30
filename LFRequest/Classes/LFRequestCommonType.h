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

#endif /* LFRequestCommonType_h */
