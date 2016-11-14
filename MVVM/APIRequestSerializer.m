//
//  APIRequestSerializer.m
//  MVVM
//
//  Created by wjc on 15/9/17.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import "APIRequestSerializer.h"

@implementation APIRequestSerializer

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    request.timeoutInterval = 10;
//    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    return request;
}

@end
