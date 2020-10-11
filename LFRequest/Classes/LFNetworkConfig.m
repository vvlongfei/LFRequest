//
//  LFNetworkConfig.m
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import "LFNetworkConfig.h"

@implementation LFNetworkConfig

- (NSString *)obtainDomainWithRequest:(LFRequest *)request {
    if (self.domainBlock) {
        return self.domainBlock(request)?:@"";
    }
    return @"";
}

- (NSDictionary *)obtainHeaderWithRequest:(LFRequest *)request {
    if (self.commonHeaderBlock) {
        return self.commonHeaderBlock(request) ?: @{};
    }
    return @{};
}

@end
