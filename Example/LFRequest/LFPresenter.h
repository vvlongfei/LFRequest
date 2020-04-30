//
//  LFPresenter.h
//  LFRequest_Example
//
//  Created by feiyu on 2020/4/30.
//  Copyright © 2020 王龙飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LFRequest/LFRequest.h>
#import "LFUserInfo.h"
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFPresenter : NSObject<LFDataParseDeleate>

@property (nonatomic, strong) LFRequest *userInfoRequest;

@property (nonatomic, strong) LFRequest *homeRequest;

@property (nonatomic, strong) LFRequest *msgRequest;

@end

NS_ASSUME_NONNULL_END
