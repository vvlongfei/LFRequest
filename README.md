# LFRequest

[![CI Status](https://img.shields.io/travis/王龙飞/LFRequest.svg?style=flat)](https://travis-ci.org/王龙飞/LFRequest)
[![Version](https://img.shields.io/cocoapods/v/LFRequest.svg?style=flat)](https://cocoapods.org/pods/LFRequest)
[![License](https://img.shields.io/cocoapods/l/LFRequest.svg?style=flat)](https://cocoapods.org/pods/LFRequest)
[![Platform](https://img.shields.io/cocoapods/p/LFRequest.svg?style=flat)](https://cocoapods.org/pods/LFRequest)

## 示例

Example工程中有使用示例，可以下载后 `pod install`试运行，查看简单使用。

## 安装

LFRequest 可以从 [CocoaPods](https://cocoapods.org)上获取。 在Podfile上添加`pod 'LFRequest'`，然后`pod install`即可。

```ruby
pod 'LFRequest'
```

## 使用教程 

#### 一、公共部分设置

```objective-c
#import <LFRequest/LFNetworkManager.h>

LFNetworkConfig *config = [LFNetworkConfig new];
// 域名配置
config.domainBlock = ^NSString * _Nonnull{
    return @"http://mock.studyinghome.com/mock/5eaa69714006b044ae246153/request";
};
// 请求头设置
config.commonHeaderBlock = ^NSDictionary * _Nonnull{
		return @{
        @"commonHeader":@"commonHeader",
        @"userToken":@"xxxxxxxxxxxxxxxxxxx",
    };
};
// 数据解析设置，LFCommonDataParse遵守LFDataParseDelegate协议
config.commonDataParse = [LFCommonDataParse new];
// 设置到manager上
[LFNetworkManager manager].config = config;
```

#### 二、LFRequest创建

```objective-c
+ (instancetype)GetWithDomain:(nullable NSString *)domain
                          uri:(NSString *)uri
                     rspClass:(nullable Class)rspClass
                    needCache:(BOOL)needCache;

+ (instancetype)GetWithUri:(NSString *)uri
                  rspClass:(nullable Class)rspClass
                 needCache:(BOOL)needCache;

+ (instancetype)GetWithUri:(NSString *)uri
                  rspClass:(nullable Class)rspClass;

+ (instancetype)PostWithDomain:(nullable NSString *)domain
                           uri:(NSString *)uri
                      rspClass:(nullable Class)rspClass;

+ (instancetype)PostWithUri:(NSString *)uri
                   rspClass:(nullable Class)rspClass;

// 例如
- (LFRequest *)homeRequest {
    if (!_homeRequest) {
        _homeRequest = [LFRequest PostWithUri:@"/home" rspClass:LFHomeInfo.class];
        _homeRequest.dataParse = self;	// 可以自定义接口的数据解析
        _homeRequest.serializerType = LFRequestSerializerTypeJson;	// 请求序列化，默认为http
        _homeRequest.requestTimeout = 10;	// 设置超时时间
    }
    return _homeRequest;
}
```

#### 三、请求

```objective-c
#pragma mark < 主线程返回数据 >
- (void)requestSuccess:(nullable LFNetSuccBlock)success
               failure:(nullable LFNetFailBlock)failure;

- (void)requestParams:(nullable NSDictionary *)params
              success:(nullable LFNetSuccBlock)success
              failure:(nullable LFNetFailBlock)failure;

- (void)requestParams:(nullable NSDictionary *)params
               header:(nullable NSDictionary *)header
              success:(nullable LFNetSuccBlock)success
              failure:(nullable LFNetFailBlock)failure;

#pragma mark < 异步返回数据 >
- (void)requestAsynBackSuccess:(nullable LFNetSuccBlock)success
                       failure:(nullable LFNetFailBlock)failure;

- (void)requestAsynBackParams:(nullable NSDictionary *)params
                      success:(nullable LFNetSuccBlock)success
                      failure:(nullable LFNetFailBlock)failure;

- (void)requestAsynBackParams:(nullable NSDictionary *)params
                       header:(nullable NSDictionary *)header
                      success:(nullable LFNetSuccBlock)success
                      failure:(nullable LFNetFailBlock)failure;

// 例如
[self.presenter.homeRequest requestParams:@{
     @"userId":@"1233455",
} header:@{
     @"selfHeader":@"www.feiyu.com"
} success:^(id rspModel, NSDictionary *rspJson) {
     
} failure:^(NSError *error) {
  	
}];
```



## Author

feiyu vvlongfei@163.com

## License

LFRequest is available under the MIT license. See the LICENSE file for more info.
