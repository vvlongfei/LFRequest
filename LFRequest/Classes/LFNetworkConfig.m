//
//  LFNetworkConfig.m
//  LFRequest
//
//  Created by feiyu on 2020/4/29.
//

#import "LFNetworkConfig.h"

@implementation LFNetworkConfig

- (NSString *)obtainDomain {
    if (self.domainBlock) {
        return self.domainBlock()?:@"";
    }
    return @"";
}

- (NSDictionary *)obtainHeader {
    if (self.commonHeaderBlock) {
        return self.commonHeaderBlock() ?: @{};
    }
    return @{};
}

@end
