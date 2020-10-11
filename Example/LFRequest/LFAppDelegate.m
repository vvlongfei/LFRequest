//
//  LFAppDelegate.m
//  LFRequest
//
//  Created by 王龙飞 on 04/29/2020.
//  Copyright (c) 2020 王龙飞. All rights reserved.
//

#import "LFAppDelegate.h"
#import "LFNetworkManager.h"
#import <YYModel/YYModel.h>

@interface LFCommonCodeModel : NSObject
@property (nonatomic, assign) NSInteger errNo;
@property (nonatomic, copy) NSString *error;
@end
@implementation LFCommonCodeModel
@end

@implementation LFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    LFNetworkConfig *config = [LFNetworkConfig new];
    config.domainBlock = ^NSString * _Nonnull(LFRequest * _Nonnull request) {
        return @"http://mock.studyinghome.com/mock/5eaa69714006b044ae246153/request";
    };
    config.commonHeaderBlock = ^NSDictionary * _Nonnull(LFRequest * _Nonnull request) {
        return @{
            @"commonHeader":@"commonHeader",
            @"userToken":@"xxxxxxxxxxxxxxxxxxx",
        };
    };
    config.dataParse = ^id(LFRequest *request, NSDictionary *jsonDict, NSError *__autoreleasing *error) {
        if (![jsonDict isKindOfClass:NSDictionary.class]) {
            *error = [NSError errorWithDomain:@"数据不合法" code:-1 userInfo:nil];
            return nil;
        }
        LFCommonCodeModel *codeModel = [LFCommonCodeModel yy_modelWithJSON:jsonDict];
        if (codeModel.errNo == 0) {
            NSDictionary *data = jsonDict[@"data"];
            if ([data isKindOfClass:NSDictionary.class]) {
                return [request.rspClass yy_modelWithJSON:data];
            } else {
                return nil;
            }
        } else {
            *error = [NSError errorWithDomain:codeModel.error?:@"" code:codeModel.errNo userInfo:nil];
            return nil;
        }
    };
    [LFNetworkManager manager].config = config;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
