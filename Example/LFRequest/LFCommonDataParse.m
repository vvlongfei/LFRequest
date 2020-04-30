//
//  LFCommonDataParse.m
//  LFRequest_Example
//
//  Created by feiyu on 2020/4/30.
//  Copyright © 2020 王龙飞. All rights reserved.
//

#import "LFCommonDataParse.h"
#import <YYModel/YYModel.h>

@interface LFCommonCodeModel : NSObject
@property (nonatomic, assign) NSInteger errNo;
@property (nonatomic, copy) NSString *error;
@end
@implementation LFCommonCodeModel
@end

@implementation LFCommonDataParse

- (id)parseDataFromJson:(NSDictionary *)jsonDict toClass:(Class)toClass error:(NSError *__autoreleasing *)error {
    if (![jsonDict isKindOfClass:NSDictionary.class]) {
        *error = [NSError errorWithDomain:@"数据不合法" code:-1 userInfo:nil];
        return nil;
    }
    LFCommonCodeModel *codeModel = [LFCommonCodeModel yy_modelWithJSON:jsonDict];
    if (codeModel.errNo == 0) {
        NSDictionary *data = jsonDict[@"data"];
        if ([data isKindOfClass:NSDictionary.class]) {
            return [toClass yy_modelWithJSON:data];
        } else {
            return nil;
        }
    } else {
        *error = [NSError errorWithDomain:codeModel.error?:@"" code:codeModel.errNo userInfo:nil];
        return nil;
    }
}

@end
