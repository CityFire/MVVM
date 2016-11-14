//
//  ResponseData.m
//  MVVM
//
//  Created by wjc on 15/1/5.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import "ResponseData.h"

@implementation ResponseData

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{ @"success" : @"succ",
              @"errorCode" : @"ErrorCode",
              @"message" : @"Message",
              @"perPage" : @"page",
            };
}

- (NSError *)error {
    return [NSError errorWithDomain:@"ERROR" code:self.errorCode userInfo:@{@"Success":@(self.success), @"ErrorCode": @(self.errorCode), @"Message":self.message}];
}

@end
