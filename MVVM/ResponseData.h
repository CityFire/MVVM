//
//  ResponseData.h
//  MVVM
//
//  Created by wjc on 15/1/5.
//  Copyright (c) 2015年 CityFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "Page.h"

typedef NS_ENUM(NSInteger, ErrorCode){
    
    kErrorCodeSucess =    1, //成功
    kErrorCodeFail   =    2, //失败
    kErrorCodeAppIdInvalid = 3, //AppId无效
};

@interface ResponseData : NSObject

@property (assign, nonatomic) int success;
@property (assign, nonatomic) int errorCode;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *topyield;
@property (strong, nonatomic) NSArray *data;
@property (nonatomic, strong) Page *page;
@property (assign, nonatomic) int perPage;
@property (assign, nonatomic) int totalpage;

- (NSError *)error;

@end

