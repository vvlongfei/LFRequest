//
//  LFUserInfo.h
//  LFRequest_Example
//
//  Created by feiyu on 2020/4/30.
//  Copyright © 2020 王龙飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFUserInfo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avator;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *email;
@end

@interface LFHomeInfo : NSObject
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *newsContent;
@end

@interface LFMsgInfo : NSObject
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *msgText;
@end

NS_ASSUME_NONNULL_END
