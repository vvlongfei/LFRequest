//
//  LFPresenter.m
//  LFRequest_Example
//
//  Created by feiyu on 2020/4/30.
//  Copyright © 2020 王龙飞. All rights reserved.
//

#import "LFPresenter.h"

@interface LFCodeModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@end
@implementation LFCodeModel
@end

@implementation LFPresenter

- (id)parseDataFromJson:(NSDictionary *)jsonDict toClass:(Class)toClass error:(NSError *__autoreleasing *)error {
    if (![jsonDict isKindOfClass:NSDictionary.class]) {
        *error = [NSError errorWithDomain:@"数据不合法" code:-1 userInfo:nil];
        return nil;
    }
    LFCodeModel *codeModel = [LFCodeModel yy_modelWithJSON:jsonDict];
    if (codeModel.code == 1) {
        NSDictionary *data = jsonDict[@"data"];
        if ([data isKindOfClass:NSDictionary.class]) {
            return [toClass yy_modelWithJSON:data];
        } else {
            return nil;
        }
    } else {
        *error = [NSError errorWithDomain:codeModel.message?:@"" code:codeModel.code userInfo:nil];
        return nil;
    }
}

- (LFRequest *)userInfoRequest {
    if (!_userInfoRequest) {
        _userInfoRequest = [LFRequest GetWithUri:@"/userInfo" rspClass:LFUserInfo.class];
        _userInfoRequest.dataParse = self;
    }
    return _userInfoRequest;
}

- (LFRequest *)homeRequest {
    if (!_homeRequest) {
        _homeRequest = [LFRequest PostWithUri:@"/home" rspClass:LFHomeInfo.class];
        _homeRequest.dataParse = self;
    }
    return _homeRequest;
}

- (LFRequest *)msgRequest {
    if (!_msgRequest) {
        _msgRequest = [LFRequest PostWithUri:@"/msg" rspClass:LFMsgInfo.class];
        _msgRequest.serializerType = LFRequestSerializerTypeJson;
    }
    return _msgRequest;
}

@end
