//
//  LFNetworkManager.h
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import <Foundation/Foundation.h>
#import "LFNetworkConfig.h"
#import "LFRequestCommonType.h"
#import "LFRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFNetworkManager : NSObject

@property (nonatomic, strong) LFNetworkConfig *config;

// 请使用 +sharedIntance 方法
+ (instancetype)new __attribute__((unavailable("Use +manager instead")));
- (instancetype)init __attribute__((unavailable("Use +manager instead")));

+ (instancetype)manager;

- (NSURLSessionDataTask *)sendRequest:(LFRequest *)request
                                 succ:(LFNetSuccBlock)succ
                                 fail:(LFNetFailBlock)fail;

@end

NS_ASSUME_NONNULL_END
