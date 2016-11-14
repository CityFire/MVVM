//
//  APIClient.m
//  MVVM
//
//  Created by wjc on 15/9/17.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import "APIClient.h"
#import "RACAFNetworking.h"
#import "APIRequestSerializer.h"

@implementation APIClient

+ (APIClient *)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.88.com.cn/app/"]];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        _sharedClient.securityPolicy = securityPolicy;
        _sharedClient.requestSerializer = [APIRequestSerializer serializer];
    });
    
    return _sharedClient;
}

- (RACSignal *)httpGet:(NSString *)URLString parameters:(id)parameters {
    return [[[self rac_GET:URLString parameters:parameters]
            catch:^RACSignal *(NSError *error) {
                //对Error进行处理
                NSLog(@"error:%@", error);
                //TODO: 这里可以根据error.code来判断下属于哪种网络异常，分别给出不同的错误提示
                return [RACSignal error:[NSError errorWithDomain:@"ERROR" code:error.code userInfo:@{@"Success":@NO, @"Message":@"Bad Network!"}]];
            }]
            reduceEach:^id(id responseObject, NSURLResponse *response){
                NSLog(@"url:%@,resp:%@",response.URL.absoluteString,responseObject);
//                NSArray *data = nil;
//                if ([responseObject[@"succ"] intValue] == 1) {
//                    data = [ProductData objectArrayWithKeyValuesArray:responseObject[@"data"]];
//                }
                ResponseData *data = [ResponseData objectWithKeyValues:responseObject];
                Page *p = [Page new];
                p.PageIndex = [responseObject[@"page"] intValue];
                p.PageCount = [responseObject[@"totalpage"] intValue];
                data.page = p;
                return data;
                
            }];
}

@end

@implementation APIClient (Product)

- (RACSignal *)fetchProductWithPageIndex:(NSNumber *)page {
    
    NSDictionary *params = @{
                             @"type":@"3",
                             @"page":page,
                             @"pagesize":@"100"
                             };
    
    return [self httpGet:@"plistnew" parameters:params];
    
}

@end
