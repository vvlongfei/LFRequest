//
//  LFPresenter.m
//  LFRequest_Example
//
//  Created by feiyu on 2020/4/30.
//  Copyright © 2020 王龙飞. All rights reserved.
//

#import "LFPresenter.h"

@implementation LFPresenter

- (id)parseDataFromJson:(NSDictionary *)jsonDict toClass:(Class)toClass error:(NSError *__autoreleasing *)error {
    return nil;
}

- (LFRequest *)userInfoRequest {
    if (!_userInfoRequest) {
        _userInfoRequest = [LFRequest GetWithUri:@"/userInfo" rspClass:nil];
        _userInfoRequest.dataParse = self;
    }
    return _userInfoRequest;
}

- (LFRequest *)homeRequest {
    if (!_homeRequest) {
        _homeRequest = [LFRequest PostWithUri:@"/home" rspClass:nil];
        _homeRequest.dataParse = self;
    }
    return _homeRequest;
}

- (LFRequest *)msgRequest {
    if (!_msgRequest) {
        _msgRequest = [LFRequest PostWithUri:@"/msg" rspClass:nil];
        _msgRequest.dataParse = self;
        _msgRequest.serializerType = LFRequestSerializerTypeJson;
    }
    return _msgRequest;
}

@end
