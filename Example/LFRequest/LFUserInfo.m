//
//  LFUserInfo.m
//  LFRequest_Example
//
//  Created by feiyu on 2020/4/30.
//  Copyright © 2020 王龙飞. All rights reserved.
//

#import "LFUserInfo.h"

@implementation LFUserInfo
- (NSString *)description {
    return [NSString stringWithFormat:@"name:%@\navator:%@\naccount:%@\nemail:%@", _name, _avator, _account, _email];
}
@end

@implementation LFHomeInfo
- (NSString *)description {
    return [NSString stringWithFormat:@" newsTitle:%@ \n newsId:%@ \n newsContent:%@", _newsTitle, _newsId, _newsContent];
}
@end

@implementation LFMsgInfo
- (NSString *)description {
    return [NSString stringWithFormat:@" msgId:%@ \n msgText:%@", _msgId, _msgText];
}
@end
